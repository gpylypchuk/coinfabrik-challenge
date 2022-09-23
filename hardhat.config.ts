import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-etherscan";
import * as dotenv from "dotenv";

dotenv.config();

// GOERLI TESTNET DEPLOY
// @run TESTNET: npx hardhat run --network goerli ./scripts/deploy-ethPool.ts
// @run VERIFY: npx hardhat verify --network goerli DEPLOYED_CONTRACT_ADDRESS

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    goerli: {
      url: process.env.GOERLI_URL || "",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
  },
  etherscan: {
    apiKey: {
      goerli: process.env.API_KEY || "",
    },
  },
};

export default config;
