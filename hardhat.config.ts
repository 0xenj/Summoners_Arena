import { HardhatUserConfig } from "hardhat/config";
import dotenv from 'dotenv';
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-foundry";

dotenv.config({ path: __dirname + '/.env' });

const {
  RPC_MAINNET,
  RPC_SEPOLIA,
  PRIVATE_KEY_MAINNET,
  PRIVATE_KEY_SEPOLIA,
  ETHERSCAN_API_KEY,
} = process.env;

const config: HardhatUserConfig = {
  networks: {
    hardhat: {},
    mainnet: {
      url: RPC_MAINNET,
      chainId: 1,
      gas: 15000000,
      gasPrice: 2000000000,
      accounts: PRIVATE_KEY_MAINNET ? [PRIVATE_KEY_MAINNET] : DUMMY_PRIVATE_KEY ? [DUMMY_PRIVATE_KEY] : []
    },

    sepolia: {
      url: RPC_SEPOLIA,
      chainId: 11155111,
      accounts: PRIVATE_KEY_SEPOLIA ? [PRIVATE_KEY_SEPOLIA] : DUMMY_PRIVATE_KEY ? [DUMMY_PRIVATE_KEY] : []
    },
    mumbai: {
      url: RPC_GOERLI,
      chainId: 5,
      gas: 15000000,
      gasPrice: 5000000000,
      accounts: PRIVATE_KEY_GOERLI ? [PRIVATE_KEY_GOERLI] : DUMMY_PRIVATE_KEY ? [DUMMY_PRIVATE_KEY] : []
    }
  },
  etherscan: {
    apiKey: {
    },
    customChains: [
      {
        network: 'zhejiang',
        chainId: 1337803,
        urls: {
          apiURL: 'https://blockscout.com/eth/zhejiang-testnet/api',
          browserURL: 'https://blockscout.com/eth/zhejiang-testnet'
        }
      }
    ]
  },
  solidity: {
    version: '0.8.19',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  mocha: {
    timeout: 200000
  }
};

export default config;