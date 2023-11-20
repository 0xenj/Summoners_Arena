import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("@nomicfoundation/hardhat-foundry");

const config: HardhatUserConfig = {
  solidity: "0.8.19",
};

export default config;