import { ethers } from "hardhat";

async function main(): Promise<void> {
  const Faucet = await ethers.getContractFactory("Faucet");
  const faucet = await Faucet.deploy("0x3f1b0BDdf498C98dd7917f70c5e2404cD9A72012", 100);

  await faucet.waitForDeployment();

    console.log('My Faucet deployed to: ', await faucet.getAddress());
}

main().catch((error: Error) => {
  console.error(error);
  process.exit(1);
});