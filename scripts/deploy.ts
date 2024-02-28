import { ethers } from "hardhat";

async function main() {
  const tokenName = "PopeNFT";
  const tokenSymbol = "PNFT";

  const nftFactory = await ethers.deployContract("NFTFactory", [tokenName, tokenSymbol]);
  await nftFactory.waitForDeployment();

  const userAuthentication = await ethers.deployContract("UserAuthentication", [nftFactory.target]);
  await userAuthentication.waitForDeployment();

  const group = await ethers.deployContract("Group");
  await group.waitForDeployment();

  const gaslessTransactionImplementation = await ethers.deployContract("GaslessTransactionImplementation");
  await gaslessTransactionImplementation.waitForDeployment();

  const socialMedia = await ethers.deployContract("SocialMedia", [nftFactory.target, userAuthentication.target, group.target, gaslessTransactionImplementation.target]);
  await socialMedia.waitForDeployment();

  console.log(`NFTFactory contract deployed to ${nftFactory.target}`);
  console.log(`UserAuthentication contract deployed to ${userAuthentication.target}`);
  console.log(`Group contract deployed to ${group.target}`);
  console.log(`GaslessTransactionImplementation contract deployed to ${gaslessTransactionImplementation.target}`);
  console.log(`SocialMedia contract deployed to ${socialMedia.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
