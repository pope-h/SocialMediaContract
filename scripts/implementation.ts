import { ethers } from "hardhat";

async function main() {
  const tokenName = "PopeNFT";
  const tokenSymbol = "PNFT";
  const tokenURI = "ipfs://bafkreigiofncokxnbikv3aczgkmfwf4jb4ex2afde5oqt5vds6izn22jdi";

  const owner = "0xb7B943fFbA78e33589971e630AD6EB544252D88C";

  const userAuthenticationAddress = "0x19d696bCb5674a7f0Ee2660B190D3c386792df15";
  const UserAuthentication = await ethers.getContractAt("IUserAuthentication", userAuthenticationAddress);
  console.log("Getting contract at address: ", userAuthenticationAddress);

// The below was muted as the user was registered on the first run
//   const assignUsernameTx = await UserAuthentication.attachUserName("pope");
//   await assignUsernameTx.wait();

  const loginTx = await UserAuthentication.login();
  await loginTx.wait();

  const nftFactoryAddress = "0x5A57A8F8B6b138e5A36B31644360A55ae98BdCA8";
  const NFTFactory = await ethers.getContractAt("INFTFactory", nftFactoryAddress);
  console.log("Getting contract at address: ", nftFactoryAddress);
  await NFTFactory.mintNFT(owner, tokenURI);

  const socialMediaContractAddress = "0x12cE20400188EC7d7F2aAC1db35B53d0ab5e8168";
  const SocialMediaContract = await ethers.getContractAt("ISocialMedia", socialMediaContractAddress);
  console.log("Getting contract at address: ", socialMediaContractAddress);

//   const getOwnNFTTx = await SocialMediaContract.getOwnNFTIndex();
//   await getOwnNFTTx.wait();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});