// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

interface IGroup {
    function createGroup(string memory _name, address[] memory _members) external;
}