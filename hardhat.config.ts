import * as dotenv from "dotenv";

import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-foundry";
import "@typechain/hardhat";
import "@nomicfoundation/hardhat-verify";

dotenv.config({ path: __dirname + '/.env' });

const {
  RPC_MAINNET,
  RPC_SEPOLIA,
  RPC_MUMBAI,
  PRIVATE_KEY_MAINNET,
  PRIVATE_KEY_SEPOLIA,
  PRIVATE_KEY_MUMBAI,
  ETHERSCAN_API_KEY,
  POLYGONSCAN_API_KEY,
  MUMBAI_API_KEY
} = process.env;

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: '0.8.19',
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      }
    ]
  },
  networks: {
    hardhat: {},
    mainnet: {
      url: RPC_MAINNET,
      chainId: 1,
      gas: 15000000,
      gasPrice: 2000000000,
      accounts: [`${PRIVATE_KEY_MAINNET}`]
    },
    sepolia: {
      url: RPC_SEPOLIA,
      chainId: 11155111,
      accounts: [`${PRIVATE_KEY_SEPOLIA}`]
    },
    mumbai: {
      url: RPC_MUMBAI,
      chainId: 5,
      gas: 15000000,
      gasPrice: 5000000000,
      accounts: [`${PRIVATE_KEY_MUMBAI}`]
    }
  },
  etherscan: {
    apiKey: POLYGONSCAN_API_KEY
  },
  mocha: {
    timeout: 200000
  }
};

export default config;