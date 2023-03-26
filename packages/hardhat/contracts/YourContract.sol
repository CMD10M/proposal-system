pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
// import "@openzeppelin/contracts/access/Ownable.sol"; 
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract YourContract {
    string public proposalName;
    string public proposalDescription;
    address public beneficiary;
    uint public amount;
    uint public votesFor;
    uint public votesAgainst;
    uint public start;
    uint public end;
    bool public finalized;
    mapping(address => bool) public voted;
    address[] public voters;
    
    function createProposal(string memory _proposalName, string memory _proposalDescription, address _beneficiary, uint _amount, uint _durationInDays) public {
        proposalName = _proposalName;
        proposalDescription = _proposalDescription;
        beneficiary = _beneficiary;
        amount = _amount;
        start = block.timestamp;
        end = start + (_durationInDays * 1 minutes);
        finalized = false;
    }
    
    function vote(bool _vote) public {
        require(!voted[msg.sender], "Already voted");
        require(block.timestamp < end, "Voting period has ended");
        voted[msg.sender] = true;
        voters.push(msg.sender);
        if(_vote) {
            votesFor++;
        } else {
            votesAgainst++;
        }
    }
    
    function finalize() public payable {
        require(!finalized, "Already finalized");
        require(block.timestamp >= end, "Voting period has not ended yet");
        finalized = true;
        if(votesFor > votesAgainst) {
            (bool sent,) = beneficiary.call{value: amount}("");
            require(sent, "Failed to send Ether");
        }
    }

    function payContract(uint256 _contractPayment) external payable {
  }
}
