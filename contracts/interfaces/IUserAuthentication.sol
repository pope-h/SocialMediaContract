// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

interface IUserAuthentication {
    function attachUserName(string memory _username) external;
    function login() external;
    function logout() external;
}