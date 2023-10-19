import { ethers, upgrades } from "hardhat";
import { NFTMarketplace, NFTMarketplace__factory } from "../typechain"; // eslint-disable-line node/no-missing-import
import { constants } from "../constants";

async function main() {
  const erc721Addr = constants.erc721Address;
  const erc20Adrr = constants.erc20Address;

  const [owner] = await (ethers as any).getSigners();
  const contract = (await upgrades.deployProxy(
    new NFTMarketplace__factory(owner),
    [erc721Addr, erc20Adrr],
    { initializer: "initialize" },
  )) as NFTMarketplace;
  await contract.deployed();

  console.log(`ProxyStorage: ${contract.address}`);
  console.log(
    "Implementation: ",
    await upgrades.erc1967.getImplementationAddress(contract.address),
  );
  console.log("Admin: ", await upgrades.erc1967.getAdminAddress(contract.address));
  console.log(`NFTMarketplace set to ${erc721Addr}, ${erc20Adrr}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
