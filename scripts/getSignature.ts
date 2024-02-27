const Web3 = require('web3');
const web3 = new Web3('http://localhost:8545'); // Or whatever your provider is

const privateKey1 = "0x5ece710c6825907ba2c3c519007171fe55a8b1de8a506c632653a0e65f50f75b";
const privateKey2 = "0xe6c065b5bff71425c6348d53a4a1a2b75f8427f1b3a4082e6a19bd15018a46c8";
const privateKey3 = "0x069ba2b65d20c8102ea4d3e6d7f8c5c8c5a5a3b1d85e8ab578f8a4899a5be1c3";
const privateKey4 = "0x1c52a806603e6a3f83e1a2ec3e3962d5b8b40578930e2c79f41b2b0c37e0b578";
const privateKey5 = "0x64c8b8a024ac24c4c6e8e4b600064b37343fb3a1d7542ed3c236fbf6b8bb7585";
const _tokenURI = "ipfs://bafkreialipl4y4dninxvfoghywl4riawwc6s32vbveaszwr62xkwxprnoa";

// This is one of the private keys provided by the JavaScript VM in Remix
const privateKey = '0xYourPrivateKey';

const account = web3.eth.accounts.privateKeyToAccount(privateKey);
const functionData = web3.eth.abi.encodeFunctionCall({
    name: 'createNFT',
    type: 'function',
    inputs: [{
        type: 'string',
        name: _tokenURI
    }],
}, [_tokenURI]);

const nonce = 123; // Replace with the actual nonce value

const messageHash = web3.utils.soliditySha3(
    { t: 'address', v: account.address },
    { t: 'bytes', v: functionData },
    { t: 'uint256', v: nonce } // nonce is the current nonce of the account
);

const signature = web3.eth.accounts.sign(messageHash, privateKey).then((result: any) => {
    console.log(result.signature);
}).catch((error: any) => {
    console.error(error);
});
