import { ethers } from "hardhat";

async function main(): Promise<void> {
    const MyTokenFactory = await ethers.getContractFactory("MyToken");
    const myToken = await MyTokenFactory.deploy();
    await myToken.deployed();
    console.log(`MyToken deployed to: ${myToken.address}`);

    const initializeTx = await myToken.initialize("Summoners", "SUMM", 18);
    await initializeTx.wait();
    console.log("MyToken initialized");
}

main().catch((error: Error) => {
    console.error(error);
    process.exit(1);
});