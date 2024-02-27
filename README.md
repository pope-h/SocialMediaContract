# Social Media Smart Contracts

This repository contains smart contracts for a social media platform built on Ethereum blockchain. The contracts are written in Solidity version 0.8.24 and utilize OpenZeppelin for ERC721 token implementation and ECDSA for signature verification.

## Contracts

1. **NFTFactory.sol**: This contract handles the creation (minting) of non-fungible tokens (NFTs) using ERC721 standard. It allows users to mint NFTs with associated metadata.

2. **UserAuthentication.sol**: This contract manages user authentication and roles. Users can register with a username and log in to interact with the platform.

3. **SocialMedia.sol**: This contract implements the core functionalities of the social media platform, including creating NFTs, sharing NFTs, liking NFTs, commenting on NFTs, creating groups, and executing gasless transactions.

4. **GaslessTransactionImplementation.sol**: This contract provides functionality for executing meta-transactions, allowing users to perform actions without directly paying gas fees.

5. **Group.sol**: This contract manages user groups within the platform. Users can create groups and add members to them.

## Usage

To use these contracts, deploy them to an Ethereum-compatible blockchain network using tools like Remix or Truffle. After deployment, interact with the contracts using a web3-enabled application or through Remix IDE.

## Requirements

- Solidity compiler (version 0.8.24)
- Ethereum development environment (Ganache, Remix, Truffle, etc.)
- OpenZeppelin library (ERC721, ECDSA)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.