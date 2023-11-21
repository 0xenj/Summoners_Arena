import { ethers } from "hardhat";

async function main(): Promise<void> {
  const Faucet = await ethers.getContractFactory("Faucet");
  const faucet = await Faucet.deploy("0xC10E2395121D323C79d24a93CB110D06f4537bc8", 2);

  await faucet.deployed();

  console.log(`Contract Address: ${faucet.address}`);
}

main().catch((error: Error) => {
  console.error(error);
  process.exit(1);
});