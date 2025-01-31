;; AI Agent Smart Contract
;; Handles AI interactions and stores results on-chain

(use-trait ft-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u101))
(define-constant ERR-INVALID-REQUEST (err u102))
(define-constant ERR-ALREADY-PROCESSED (err u103))

;; Data Variables
(define-map ai-requests 
    {request-id: uint} 
    {
        owner: principal,
        prompt: (string-utf8 500),
        result: (optional (string-utf8 1000)),
        timestamp: uint,
        status: (string-ascii 20)
    }
)

(define-map ai-responses
    {request-id: uint}
    {
        response: (string-utf8 1000),
        confidence: uint,
        model-version: (string-ascii 50),
        verification-hash: (buff 32)
    }
)

(define-map authorized-agents principal bool)
(define-data-var request-counter uint u0)
(define-data-var agent-token-address principal 'SP000000000000000000002Q6VF78.token)

;; Read-only functions
(define-read-only (get-request (request-id uint))
    (map-get? ai-requests {request-id: request-id})
)

(define-read-only (get-response (request-id uint))
    (map-get? ai-responses {request-id: request-id})
)

(define-read-only (is-agent-authorized (agent principal))
    (default-to false (map-get? authorized-agents agent))
)

;; Public functions
(define-public (submit-ai-request (prompt (string-utf8 500)))
    (let (
        (request-id (+ (var-get request-counter) u1))
    )
        ;; Store request
        (map-set ai-requests
            {request-id: request-id}
            {
                owner: tx-sender,
                prompt: prompt,
                result: none,
                timestamp: block-height,
                status: "pending"
            }
        )
        
        ;; Update counter
        (var-set request-counter request-id)
        (ok request-id)
    )
)

(define-public (process-ai-response 
    (request-id uint)
    (response (string-utf8 1000))
    (confidence uint)
    (model-version (string-ascii 50)))
    (let (
        (request (unwrap! (map-get? ai-requests {request-id: request-id}) ERR-INVALID-REQUEST))
    )
        ;; Check authorization
        (asserts! (is-agent-authorized tx-sender) ERR-NOT-AUTHORIZED)
        (asserts! (is-eq (get status request) "pending") ERR-ALREADY-PROCESSED)
        
        ;; Calculate verification hash
        (let (
            (verification-hash (hash response))
        )
            ;; Store response
            (map-set ai-responses
                {request-id: request-id}
                {
                    response: response,
                    confidence: confidence,
                    model-version: model-version,
                    verification-hash: verification-hash
                }
            )
            
            ;; Update request status
            (map-set ai-requests
                {request-id: request-id}
                (merge request {
                    result: (some response),
                    status: "completed"
                })
            )
            
            (ok verification-hash)
        )
    )
)

;; Admin functions
(define-public (authorize-agent (agent principal))
    (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
        (map-set authorized-agents agent true)
        (ok true)
    )
)

(define-public (revoke-agent (agent principal))
    (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
        (map-set authorized-agents agent false)
        (ok true)
    )
)

(define-public (set-agent-token (new-token principal))
    (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
        (var-set agent-token-address new-token)
        (ok true)
    )
)