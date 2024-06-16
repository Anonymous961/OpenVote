# OpenVote

OpenVote is a decentralized voting machine implemented on the Ethereum blockchain using Solidity smart contracts. It allows users to create, participate in, and tally votes in a transparent and tamper-proof manner.

## Overview

OpenVote leverages the Ethereum blockchain to provide a secure and auditable platform for conducting various types of voting, including elections, polls, and decision-making processes. By utilizing blockchain technology, OpenVote ensures immutability, transparency, and censorship resistance, making it suitable for a wide range of voting applications.

## Features

- **Ballot Creation**: Users can create new ballots with customizable questions and options.
- **Voting**: Registered users can cast their votes securely and anonymously on active ballots.
- **Tallying**: The system automatically tallies the votes and provides transparent results.
- **Auditability**: All voting activities are recorded on the blockchain, ensuring auditability and transparency.
- **Decentralization**: OpenVote operates on a decentralized network, eliminating the need for a central authority.
- **Security**: Smart contracts are designed to prevent tampering and unauthorized access.

## Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) installed on your machine
- [npm](https://www.npmjs.com/) or [Yarn](https://yarnpkg.com/) package manager
- [Hardhat](https://hardhat.org/) Ethereum development environment

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/OpenVote.git
   ```

2. Navigate to the project directory:
   ```bash
   cd OpenVote
   ```
3. Install dependencies:
   ```bash
   npm install
   ```

## Usage

1. Compile the smart contracts:

   ```bash
   npx hardhat compile
   ```

2. Deploy the contracts to a local Ethereum network:

   ```bash
   npx hardhat node
   ```

3. Run the deployment script:

   ```bash
   npx hardhat run scripts/deploy.js --network localhost
   ```

4. Interact with the deployed contracts using a web3 provider or Ethereum wallet.

## Testing

Run the automated tests to ensure the correctness and functionality of the smart contracts:

```bash
npx hardhat test
```
