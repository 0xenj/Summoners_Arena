import { ethers } from "hardhat";

async function main(): Promise<void> {
  const Faucet = await ethers.getContractFactory("Faucet");
  const faucet = await Faucet.deploy("", 1000000, "0xF6547bd336230Ff9A371161b309Ea11b205ae2dC");

  await faucet.deployed();

  console.log(`Contract Address: ${faucet.address}`);
}

main().catch((error: Error) => {
  console.error(error);
  process.exit(1);
});