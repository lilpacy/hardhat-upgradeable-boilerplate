import { ethers } from "hardhat";
import { constants } from "../constants";

async function main() {
  const initialSupply = ethers.utils.parseEther("100000000");
  const to = constants.buyerAddress;

  const Contract = await ethers.getContractFactory("MyERC20");
  const contract = await Contract.deploy(initialSupply, to);

  await contract.deployed();

  console.log(`Contract deployed to ${contract.address}`);
  console.log(`MyERC20 minted to ${to}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
