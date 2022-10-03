import { HardhatUserConfig, task } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-etherscan";
import * as dotenv from "dotenv";

dotenv.config();

// Total amount of ETH held in the contract (ETHPool)
// @run npx hardhat held --contract DEPLOYED_CONTRACT_ADDRESS

task("held", "Prints the total amount of ETH held in the contract")
  .addParam("contract", "The contract address")
  .setAction(async (taskArgs, { ethers }) => {
    const provider = new ethers.providers.InfuraProvider(
      "goerli",
      process.env.ID
    );
    const balance = await provider.getBalance(taskArgs.contract);
    console.log(ethers.utils.formatEther(balance), "ETH");
  });

// GOERLI TESTNET DEPLOY
// @run TESTNET: npx hardhat run --network goerli ./scripts/deploy-ethPool.ts
// @run VERIFY: npx hardhat verify --network goerli DEPLOYED_CONTRACT_ADDRESS
//
// DEPLOYED CONTRACT (VERIFIED): https://goerli.etherscan.io/address/0xCbb8ED45736F3D4728204A5C35304733c189B806#code

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
