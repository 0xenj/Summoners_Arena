import { ethers } from "hardhat";

async function main(): Promise<void> {
    const MyCardsFactory = await ethers.getContractFactory("Cards");
    const Cards = await MyCardsFactory.deploy("0x2BFA005d8E646478CD64FE71AD8E7f748a1c2641");

    await Cards.waitForDeployment();

    console.log('Cards deployed to: ', await Cards.getAddress());
}

main().catch((error: Error) => {
  console.error(error);
  process.exit(1);
});