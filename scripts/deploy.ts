import { ethers } from "hardhat";

async function main(): Promise<void> {
    const MyTokenFactory = await ethers.getContractFactory("MyToken");
    const myToken = await MyTokenFactory.deploy("Summoners", "SUMM", 18, "0xF6547bd336230Ff9A371161b309Ea11b205ae2dC");

    await myToken.deployed();

    console.log(`MyToken deployed to: ${myToken.address}`);
}

main().catch((error: Error) => {
  console.error(error);
  process.exit(1);
});