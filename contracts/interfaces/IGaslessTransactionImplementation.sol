// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

interface IGaslessTransactionImplementation {
    function executeGaslessTransaction(
        address _to,
        uint256 _value,
        bytes calldata _data,
        bytes calldata _signature
    ) external;

    function executeMetaTransaction(
        address user,
        bytes memory functionData,
        bytes memory signature
    ) external;
}