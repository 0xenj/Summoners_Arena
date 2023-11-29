import { ethers } from "hardhat";

async function main(): Promise<void> {
  const Faucet = await ethers.getContractFactory("Faucet");
  const faucet = await Faucet.deploy("0x9c7843Fec55F6Cd47daE08Aa46f87837df6c442c", 100);

  await faucet.waitForDeployment();

    console.log('My Faucet deployed to: ', await faucet.getAddress());
}

main().catch((error: Error) => {
  console.error(error);
  process.exit(1);
});