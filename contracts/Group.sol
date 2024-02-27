// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract Group {
    struct GroupData {
        string name;
        // string description;
        address[] members;
    }

    mapping(address => GroupData) public groups;

    event GroupCreated(string name, address creator);

    function createGroup(string memory _name, address[] memory _members) external {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(_members.length > 0, "Group must have at least one member");

        GroupData storage newGroup = groups[msg.sender];
        newGroup.name = _name;
        newGroup.members = _members;

        emit GroupCreated(_name, msg.sender);
    }
}