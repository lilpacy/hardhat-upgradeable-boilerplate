import { ethers } from "hardhat";
import { constants } from "../constants";

async function main() {
  const to = constants.sellerAddress;

  const Contract = await ethers.getContractFactory("MyERC721");
  const contract = await Contract.deploy(to);

  await contract.deployed();

  console.log(`Contract deployed to ${contract.address}`);
  console.log(`MyERC721 minted to ${to}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
