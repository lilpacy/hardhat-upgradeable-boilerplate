import { ethers } from "hardhat";
import { constants } from "../constants";

async function main() {
  // 環境に応じて変更すること
  const seller = constants.sellerAddress;
  const buyer = constants.buyerAddress;
  const amountToSend = ethers.utils.parseEther("100");

  // 現在のアカウントを取得する
  const [sender] = await ethers.getSigners();

  // 送信トランザクションを準備する
  const tx1 = await sender.sendTransaction({
    to: seller,
    value: amountToSend,
  });
  const tx2 = await sender.sendTransaction({
    to: buyer,
    value: amountToSend,
  });

  // トランザクションがマイニングされるまで待つ
  await tx1.wait();
  await tx2.wait();

  console.log(`Sent ${amountToSend.toString()} ETH to ${seller}`);
  console.log(`Sent ${amountToSend.toString()} ETH to ${buyer}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
