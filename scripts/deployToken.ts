import { ethers } from "hardhat";

async function main(): Promise<void> {
    const MyTokenFactory = await ethers.getContractFactory("MyToken");
    const myToken = await MyTokenFactory.deploy("0xF6547bd336230Ff9A371161b309Ea11b205ae2dC");

    await myToken.waitForDeployment();

    console.log('MyToken deployed to: ', await myToken.getAddress());
}

main().catch((error: Error) => {
  console.error(error);
  process.exit(1);
});