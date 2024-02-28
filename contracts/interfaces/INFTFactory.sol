// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface INFTFactory {
    function mintNFT(address _to, string calldata _tokenURI) external returns(uint);
    
}