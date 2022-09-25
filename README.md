# Ethereum Pool 💸

> Actually deployed and verified at **[Goerli](https://goerli.etherscan.io/address/0x86d1beb3ea0a7cda5bb24ff4d13c1f9079cd3c5d#code)**

> Frontend _(with Nextjs, Typescript, Ethers and Ness.css)_ deployed at **[Vercel](https://challenge-interface-gpylypchuk.vercel.app/)**

## Features 🛠

| Feature                               | Supported |
| ------------------------------------- | --------- |
| Users can Deposit                     | ✔         |
| Users can Withdraw                    | ✔         |
| Team Members Can Deposit Rewards      | ✔         |
| Goerli Deployed and Verified Contract | ✔         |
| Tests                                 | ✔         |
| Frontend to Interact                  | ✔         |

## How to Deploy Your ETHPool Contract 📝

> Using Goerli Testing Network (You have balance in your Wallet)

1. Install the dependencies: `npm install --save-dev`
2. Create a `.env` and put your private key and InfuraNode ID following the `.env.example` example
3. Deploy the ETHPool Contract with `npx hardhat run --network goerli ./scripts/deploy-ethPool.ts`
4. The address of the deployed contract will be printed in the console, copy it.
5. Now go to [Goerli](https://goerli.etherscan.io/) and paste the address of the contract.
6. Verify the contract. To do this type in console: `npx hardhat verify --network goerli DEPLOYED_CONTRACT_ADDRESS`
7. Done!, Now, you can test easily the contract in [Goerli Testnet](https://goerli.etherscan.io/)!

#### For Local Deploy

1. Create a local network with Hardhat: `npx hardhat node`
2. Now, deploy it in there: `npx hardhat run --network localhost ./scripts/deploy-ethPool.ts`
3. Done!, now with `npx hardhat console --network localhost` you can interact with the contract calling the differents functions (with ethers)
