import { ethers } from "hardhat";

async function main(): Promise<void> {
  const Faucet = await ethers.getContractFactory("Faucet");
  const faucet = await Faucet.deploy("0xB2996699F2e41C2D588e7C697C1BEf2835ae0Da5", 100);

  await faucet.waitForDeployment();

    console.log('My Faucet deployed to: ', await faucet.getAddress());
}

main().catch((error: Error) => {
  console.error(error);
  process.exit(1);
});