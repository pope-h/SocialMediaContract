import { ethers } from "hardhat";

async function main() {
  const tokenURI = "ipfs://bafkreigiofncokxnbikv3aczgkmfwf4jb4ex2afde5oqt5vds6izn22jdi";

  const owner = "0xb7B943fFbA78e33589971e630AD6EB544252D88C";

  console.log("Connecting to UserAuthentication Contract -------------------------------------------------");
  const userAuthenticationAddress = "0xeeE560574E6338c86E9347E1FaEdd38318EF8F7F";
  const UserAuthentication = await ethers.getContractAt("IUserAuthentication", userAuthenticationAddress);
  console.log("---------Successfully connecetd to UserAuthentication Contract---------------");

// The below was muted as the user was registered on the first run
  // const assignUsernameTx = await UserAuthentication.attachUserName("pope");
  // await assignUsernameTx.wait();

  const loginTx = await UserAuthentication.login();
  await loginTx.wait();

  console.log("Connecting to NFTFactory Contract -------------------------------------------------");
  const nftFactoryAddress = "0xb88018a0Ceb0F09a232b95d80cBd7D444bdc5E70";
  const NFTFactory = await ethers.getContractAt("INFTFactory", nftFactoryAddress);
  console.log("---------Successfully connecetd to NFTFactory Contract---------------");
  await NFTFactory.mintNFT(owner, tokenURI);

  console.log("Connecting to SocialMedia Contract -------------------------------------------------");
  const socialMediaContractAddress = "0x7B606FCbbFE12eF46292EAC2043c223890bfAf48";
  const SocialMediaContract = await ethers.getContractAt("ISocialMedia", socialMediaContractAddress);
  console.log("---------Successfully connecetd to SocialMedia Contract---------------");

  const getOwnNFTTx = await SocialMediaContract.createNFT(tokenURI);
  await getOwnNFTTx.wait();

  console.log("Implementation Successful");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});