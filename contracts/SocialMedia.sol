// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "./NFTFactory.sol";
import "./UserAuthentication.sol";
import "./Group.sol";
import "./GaslessTransactionImplementation.sol";

contract SocialMedia {
    NFTFactory nftFactory;
    UserAuthentication userAuth;
    Group groupContract;
    address gaslessTxImplAddress;


    struct NFT {
        address owner;
        uint256 nftId;
        uint256 likes;
        mapping(address => bool) likedBy;
        string[] comments;
        bool isShared; // New field to track if the NFT has been shared
    }

    mapping(uint256 => NFT) public nfts;
    uint256 public totalNFTs;
    
    event NFTCreated(uint256 indexed nftId, address indexed owner);
    event NFTShared(uint256 indexed nftId, address indexed owner);
    event NFTLiked(uint256 indexed nftId, address indexed liker);
    event NFTCommentAdded(uint256 indexed nftId, address indexed commenter, string comment);

    constructor(address _nftFactoryAddress, address _userAuthAddress, address _groupContractAddress, address _gaslessTxImplAddress) {
        nftFactory = NFTFactory(_nftFactoryAddress);
        userAuth = UserAuthentication(_userAuthAddress);
        groupContract = Group(_groupContractAddress);
        gaslessTxImplAddress = _gaslessTxImplAddress;
    }

    function createNFT(string memory _tokenURI) public {
        require(userAuth.isLoggedIn(msg.sender), "User not logged in");
        require(bytes(userAuth.attachedUserName(msg.sender)).length > 0, "User must have a username");

        uint256 nftId = nftFactory.mintNFT(msg.sender, _tokenURI);
        NFT storage nft = nfts[nftId];

        nft.owner = msg.sender;
        nft.nftId = nftId;
        nft.likes = 0;
        nft.comments = new string[](0);
        nft.isShared = false; // Set to false initially

        totalNFTs++;

        emit NFTCreated(nftId, msg.sender);
    }

    function shareNFT(uint256 _nftId) public {
        require(_nftId < totalNFTs, "Invalid NFT ID");

        NFT storage nft = nfts[_nftId];
        require(nft.owner == msg.sender, "You are not the owner of this NFT");
        require(!nft.isShared, "NFT has already been shared");

        nft.isShared = true;

        emit NFTShared(_nftId, msg.sender);
    }

    function likeNFT(uint256 _nftId) public {
        require(_nftId < totalNFTs, "Invalid NFT ID");

        NFT storage nft = nfts[_nftId];
        require(nft.isShared, "NFT has not been shared yet");

        require(userAuth.isLoggedIn(msg.sender), "User not logged in");
        require(bytes(userAuth.attachedUserName(msg.sender)).length > 0, "User must have a username");
        require(!nft.likedBy[msg.sender], "Already liked");

        nft.likedBy[msg.sender] = true;
        nft.likes++;

        emit NFTLiked(_nftId, msg.sender);
    }

    function commentOnNFT(uint256 _nftId, string memory _comment) public {
        require(_nftId < totalNFTs, "Invalid NFT ID");

        NFT storage nft = nfts[_nftId];
        require(nft.isShared, "NFT has not been shared yet");

        require(userAuth.isLoggedIn(msg.sender), "User not logged in");
        require(bytes(userAuth.attachedUserName(msg.sender)).length > 0, "User must have a username");

        nft.comments.push(_comment);

        emit NFTCommentAdded(_nftId, msg.sender, _comment);
    }

    function createNFTGasless(string memory _tokenURI, bytes memory _signature)
        external
    {
        bytes memory functionData =
            abi.encodeWithSignature("createNFT(string)", _tokenURI);
        executeMetaTransaction(msg.sender, functionData, _signature);
    }

    function likeNFTGasless(uint256 _nftId, bytes memory _signature)
        external
    {
        bytes memory functionData =
            abi.encodeWithSignature("likeNFT(uint256)", _nftId);
        executeMetaTransaction(msg.sender, functionData, _signature);
    }

    function commentOnNFTGasless(
        uint256 _nftId,
        string memory _comment,
        bytes memory _signature
    ) external {
        bytes memory functionData =
            abi.encodeWithSignature("commentOnNFT(uint256,string)", _nftId, _comment);
        executeMetaTransaction(msg.sender, functionData, _signature);
    }

    function executeMetaTransaction(
        address user,
        bytes memory functionData,
        bytes memory signature
    ) internal {
        GaslessTransactionImplementation gaslessTxImpl =
            GaslessTransactionImplementation(gaslessTxImplAddress);
        gaslessTxImpl.executeMetaTransaction(user, functionData, signature);
    }

    function createGroup(string memory _name, address[] memory _members) private {
        require(userAuth.isLoggedIn(msg.sender), "User not logged in");
        require(bytes(userAuth.attachedUserName(msg.sender)).length > 0, "User must have a username");

        groupContract.createGroup(_name, _members);
    }

    function getOwnNFTIndex() external view returns (uint256[] memory) {
        uint256[] memory ownNFTIndexes = new uint256[](totalNFTs);
        uint256 counter = 0;

        for (uint256 i = 0; i < totalNFTs; i++) {
            if (nfts[i].owner == msg.sender) {
                ownNFTIndexes[counter] = i;
                counter++;
            }
        }

        // Trim the array to remove any unused slots
        uint256[] memory result = new uint256[](counter);
        for (uint256 j = 0; j < counter; j++) {
            result[j] = ownNFTIndexes[j];
        }

        return result;
    }

    function getNFTLikes(uint256 _nftId) external view returns (uint256) {
        require(_nftId < totalNFTs, "Invalid NFT ID");

        NFT storage nft = nfts[_nftId];
        return nft.likes;
    }

    function getNFTComments(uint256 _nftId) external view returns (string[] memory) {
        require(_nftId < totalNFTs, "Invalid NFT ID");

        NFT storage nft = nfts[_nftId];
        return nft.comments;
    }
}