const hre = require("hardhat");

async function main() {
  const Lottery = await hre.ethers.getContractFactory("BlockchainLottery");
  const lottery = await Lottery.deploy();

  await lottery.deployed();

  console.log("BlockchainLottery deployed to:", lottery.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
