// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DAOMembership {

    address private owner;
    mapping(address => bool) members;  // member of the DAO
    mapping(address => bool) applied;  // this address applied for becoming a member
    mapping(address => mapping(address => bool)) approved; // approved by this address
    mapping(address => uint) totalApprovals;
    uint total = 1;

    constructor() {
        owner = msg.sender;
        members[owner] = true;
    }

    modifier onlyMembers {
        require(members[msg.sender] == true, "Access denied");
        _;
    }

    //To apply for membership of DAO
    function applyForEntry() public {
        require(!members[msg.sender] && !applied[msg.sender], "Not eligible");
        applied[msg.sender] = true;
    }
    
    //To approve the applicant for membership of DAO
    function approveEntry(address _applicant) public onlyMembers {
        require(applied[_applicant], "Did not apply yet");
        require(msg.sender != _applicant, "You cann't approve yourself");
        require(!approved[msg.sender][_applicant], "You already approved");
        approved[msg.sender][_applicant] = true;
        totalApprovals[_applicant]++;
        if (((totalApprovals[_applicant] * 100) / total) >= 30) {
            members[_applicant] = true;
            total++;
        }
    }

    //To check membership of DAO
    function isMember(address _user) public view onlyMembers returns (bool) {
        return members[_user];
    }

    //To check total number of members of the DAO
    function totalMembers() public view onlyMembers returns (uint256) {
        return total;
    }
}
