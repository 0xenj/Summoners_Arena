import { ethers } from "hardhat";

async function main(): Promise<void> {
    const MyCardsFactory = await ethers.getContractFactory("Cards");
    const Cards = await MyCardsFactory.deploy("0xF6547bd336230Ff9A371161b309Ea11b205ae2dC");

    await Cards.waitForDeployment();

    console.log('Cards deployed to: ', await Cards.getAddress());
}

main().catch((error: Error) => {
  console.error(error);
  process.exit(1);
});