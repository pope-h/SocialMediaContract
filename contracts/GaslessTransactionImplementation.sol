// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract GaslessTransactionImplementation {
    using ECDSA for bytes32;

    // Define a struct for meta-transactions
    struct MetaTransaction {
        address user;
        bytes functionData;
    }

    // Define events for meta-transactions
    event MetaTransactionExecuted(address indexed user, bytes functionData);

    // Define a mapping to track nonce for each user
    mapping(address => uint256) public nonces;

    // Define a function to verify the user's signature
    function verifySignature(
        address user,
        bytes memory functionData,
        bytes memory signature
    ) internal view returns (bool) {
        bytes32 hash = keccak256(
            abi.encodePacked(user, functionData, nonces[user])
        );
        address signer = hash.recover(signature);
        return signer == user;
    }

    // Define a function to execute the meta-transaction
    function executeMetaTransaction(
        address user,
        bytes memory functionData,
        bytes memory signature
    ) external {
        // Verify the user's signature
        require(
            verifySignature(user, functionData, signature),
            "Invalid signature"
        );

        // Increment the nonce
        nonces[user]++;

        // Execute the function call
        (bool success, ) = address(this).call(functionData);
        require(success, "Meta-transaction execution failed");

        // Emit an event
        emit MetaTransactionExecuted(user, functionData);
    }
}