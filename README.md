# Blockchain AI Agent

A decentralized AI agent system that processes requests on-chain and integrates with OpenAI's GPT models. This project demonstrates how to build AI capabilities into blockchain applications using Stacks smart contracts.

## Architecture

### Smart Contract
- Handles request management
- Stores AI responses
- Manages agent authorization
- Verifies response integrity

### AI Agent
- Monitors blockchain for requests
- Processes requests using OpenAI
- Submits responses on-chain
- Handles error cases

## Features

- On-chain request submission
- AI response verification
- Decentralized processing
- Request/response tracking
- Agent authorization system
- Confidence scoring
- Response integrity checks

## Prerequisites

- Node.js v14+
- Clarinet for Stacks development
- OpenAI API key
- Stacks testnet/mainnet account

## Installation

1. Clone repository:
```bash
git clone https://github.com/yourusername/blockchain-ai-agent
cd blockchain-ai-agent
```

2. Install dependencies:
```bash
npm install
```

3. Configure environment:
```bash
cp .env.example .env
# Edit .env with your credentials
```

## Smart Contract Deployment

1. Test contract:
```bash
clarinet test
```

2. Deploy to testnet:
```bash
clarinet deploy --testnet
```

## Running the AI Agent

1. Set up configuration:
```typescript
const agent = new BlockchainAIAgent(
    process.env.OPENAI_API_KEY,
    'testnet',
    'your-contract-address',
    'ai-agent',
    process.env.STACKS_PRIVATE_KEY
);
```

2. Start the agent:
```typescript
agent.monitorRequests();
```

## Usage

### Submitting Requests

```clarity
;; From Clarity contract
(contract-call? .ai-agent submit-ai-request "Your prompt here")
```

### Processing Requests
The agent automatically:
1. Monitors for new requests
2. Processes them with OpenAI
3. Submits responses on-chain

### Retrieving Results

```clarity
;; Get request details
(contract-call? .ai-agent get-request request-id)

;; Get AI response
(contract-call? .ai-agent get-response request-id)
```

## Security Considerations

1. Agent Authorization
- Only authorized agents can process requests
- Authorization managed by contract owner
- Revocation mechanism available

2. Response Verification
- Response hash stored on-chain
- Confidence scores included
- Model version tracked

3. Rate Limiting
- Request throttling
- Response size limits
- Cost management

## Development

### Testing

```bash
# Run contract tests
clarinet test

# Run agent tests
npm test
```

### Local Development

1. Start local Stacks chain:
```bash
clarinet integrate
```

2. Run agent in development mode:
```bash
npm run dev
```

## Contract Functions

### Core Functions

```clarity
(define-public (submit-ai-request (prompt (string-utf8 500))))
(define-public (process-ai-response (request-id uint) ...))
```

### Admin Functions

```clarity
(define-public (authorize-agent (agent principal)))
(define-public (revoke-agent (agent principal)))
```

## Error Handling

The system handles various error cases:
- Invalid requests
- Unauthorized access
- Network issues
- AI service errors
- Response validation failures

## Contributing

1. Fork repository
2. Create feature branch
3. Commit changes
4. Submit pull request

## License

MIT License - See LICENSE file

---

## Future Enhancements

1. Multi-model support
2. Response validation system
3. Decentralized agent network
4. Enhanced verification mechanisms
5. Cost optimization features