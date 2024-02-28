import Web3 from 'web3';

const web3 = new Web3('http://localhost:8545');

const privateKey = '0x5ece710c6825907ba2c3c519007171fe55a8b1de8a506c632653a0e65f50f75b';
const _tokenURI = "ipfs://bafkreialipl4y4dninxvfoghywl4riawwc6s32vbveaszwr62xkwxprnoa";
const nonce = 123; // Replace with the actual nonce value

const functionData = web3.eth.abi.encodeFunctionCall({
    name: 'createNFT',
    type: 'function',
    inputs: [{
        type: 'string',
        name: _tokenURI
    }],
}, [_tokenURI]);

const account = web3.eth.accounts.privateKeyToAccount(privateKey);
const messageHash = web3.utils.soliditySha3(
    { t: 'address', v: account.address },
    { t: 'bytes', v: functionData },
    { t: 'uint256', v: nonce } // nonce is the current nonce of the account
);

if (messageHash) {
    const signature = web3.eth.accounts.sign(messageHash, privateKey);
    console.log(signature.signature);
} else {
    console.error("Failed to compute message hash");
}