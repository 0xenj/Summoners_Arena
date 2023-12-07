import { ethers } from "hardhat";

async function main(): Promise<void> {
    const MyTokenFactory = await ethers.getContractFactory("MyToken");
    const myToken = await MyTokenFactory.deploy("0x2BFA005d8E646478CD64FE71AD8E7f748a1c2641");

    await myToken.waitForDeployment();

    console.log('MyToken deployed to: ', await myToken.getAddress());
}

main().catch((error: Error) => {
  console.error(error);
  process.exit(1);
});