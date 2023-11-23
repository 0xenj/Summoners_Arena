import { ethers } from "hardhat";

async function main(): Promise<void> {
  const Faucet = await ethers.getContractFactory("Faucet");
  const faucet = await Faucet.deploy("0x8c89b567CB651ED38FE1d57e3eb6B475aCef36C8", 100);

  await faucet.waitForDeployment();

    console.log('My Faucet deployed to: ', await faucet.getAddress());
}

main().catch((error: Error) => {
  console.error(error);
  process.exit(1);
});