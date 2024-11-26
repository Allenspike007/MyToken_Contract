# MyToken Smart Contract

A professional implementation of a fungible token smart contract built on Stacks blockchain using Clarity language. This contract implements the [SIP-010](https://github.com/stacksgov/sips/blob/main/sips/sip-010/sip-010-fungible-token-standard.md) fungible token standard with additional features for metadata management and token operations.

## Features

- **SIP-010 Compliance**: Implements all standard fungible token interfaces
- **Metadata Management**: Built-in support for token metadata storage and retrieval
- **Access Control**: Secure owner-only functions for sensitive operations
- **Comprehensive Error Handling**: Clear error messages and proper error handling
- **Flexible Token Operations**: Support for minting, burning, and transfers
- **Balance Management**: Efficient tracking of token balances and allowances

## Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) - Clarity smart contract development tool
- [Stacks Wallet](https://www.hiro.so/wallet) - For contract deployment and testing
- Basic understanding of Clarity and Stacks blockchain concepts

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/mytoken-contract
cd mytoken-contract
```

2. Install dependencies:
```bash
clarinet requirements
```

3. Test the contract:
```bash
clarinet test
```

## Contract Interface

### Read-Only Functions

```clarity
(get-balance (account principal) → uint)
(get-total-supply () → uint)
(get-token-name () → (string-ascii 32))
(get-token-symbol () → (string-ascii 10))
(get-token-metadata (token-id uint) → {name: (string-ascii 64), description: (string-utf8 256)})
```

### Public Functions

```clarity
(transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))) → (response bool uint))
(mint (amount uint) (recipient principal) → (response bool uint))
(burn (amount uint) (owner principal) → (response bool uint))
(set-token-metadata (token-id uint) (name (string-ascii 64)) (description (string-utf8 256)) → (response bool uint))
```

## Usage Examples

### Transferring Tokens

```clarity
;; Transfer 100 tokens from tx-sender to another address
(contract-call? .mytoken transfer u100 tx-sender 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9 none)
```

### Minting New Tokens (Owner Only)

```clarity
;; Mint 1000 tokens to a specified address
(contract-call? .mytoken mint u1000 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9)
```

### Setting Token Metadata

```clarity
;; Set metadata for token ID 1
(contract-call? .mytoken set-token-metadata u1 "Special Edition" "Limited release token with unique properties")
```

## Testing

The contract includes a comprehensive test suite. Run the tests using:

```bash
clarinet test tests/mytoken_test.clar
```

## Security Considerations

- Only the contract owner can mint new tokens
- Transfer function includes sender verification
- Balance checks prevent overdraft
- Critical functions have proper access control
- All state changes are protected by appropriate guards

## Deployment

1. Build the contract:
```bash
clarinet build
```

2. Deploy using Clarinet console:
```bash
clarinet console
```

3. Or deploy to mainnet using the Stacks wallet:
   - Load the contract in the wallet
   - Configure deployment parameters
   - Submit the transaction

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Contact

Your Name - [@yourtwitter](https://twitter.com/yourtwitter)
Project Link: [https://github.com/yourusername/mytoken-contract](https://github.com/yourusername/mytoken-contract)

## Acknowledgments

- [Stacks Documentation](https://docs.stacks.co)
- [Clarity Language Reference](https://docs.stacks.co/references/language-overview)
- [SIP-010 Standard](https://github.com/stacksgov/sips/blob/main/sips/sip-010/sip-010-fungible-token-standard.md)
