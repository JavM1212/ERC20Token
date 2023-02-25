const hre = require("hardhat");

async function main() {
  const PandaSeaPayToken = await hre.ethers.getContractFactory("PandaSeaPayToken");
  const pandaSeaPayToken = await PandaSeaPayToken.deploy(10000000, 1);
  
  await pandaSeaPayToken.deployed();

  console.log("PandaSeaPayToken deployed: ", pandaSeaPayToken.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
