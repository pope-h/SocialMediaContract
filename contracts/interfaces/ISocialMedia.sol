// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

interface ISocialMedia {
    function createNFT(string memory _tokenURI) external;
    function shareNFT(uint256 _nftId) external;
    function likeNFT(uint256 _nftId) external;
    function commentOnNFT(uint256 _nftId, string memory _comment) external;
    function createNFTGasless(string memory _tokenURI, bytes memory _signature) external;
    function likeNFTGasless(uint256 _nftId, bytes memory _signature) external;
    function commentOnNFTGasless(uint256 _nftId, string memory _comment, bytes memory _signature) external;
    function getOwnNFTIndex() external view returns (uint256[] memory);
    function getNFTLikes(uint256 _nftId) external view returns (uint256);
    function getNFTComments(uint256 _nftId) external view returns (string[] memory);
}