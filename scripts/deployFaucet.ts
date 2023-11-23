import { ethers } from "hardhat";

async function main(): Promise<void> {
  const Faucet = await ethers.getContractFactory("Faucet");
  const faucet = await Faucet.deploy("", 100);

  await faucet.deployed();

  console.log(`Contract Address: ${faucet.address}`);
}

main().catch((error: Error) => {
  console.error(error);
  process.exit(1);
});