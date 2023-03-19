import { ethers } from "hardhat";
import { NFTMarketplace } from "../typechain"; // eslint-disable-line node/no-missing-import
import { constants } from "../constants";

async function main() {
  const erc20 = constants.erc20Address;
  const erc721 = constants.erc721Address;

  const Contract = await ethers.getContractFactory("NFTMarketplace");
  const contract = await Contract.deploy(erc721, erc20);
  await contract.deployed();

  console.log(`Contract deployed to ${contract.address}`);
  console.log(`NFTMarketplace set to ${erc721}, ${erc20}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
