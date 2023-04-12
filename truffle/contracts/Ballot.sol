// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// making a voting contract

// 1. we want the ability to accept proposals and store them
// proposal: their name, number

// 2. voters & voting ability
// keep track of voting
// check voters are authenticated to vote

// 3. chairperson
// authentication and deploy contract

contract Ballot {

    // struct is a method to create your own data type

    // voters: voted = bool, access to vote = uint, vote index = uint

    struct Voter {
        uint vote;
        bool voted;
        uint weight;
    }
    
    struct Proposal {   
        // bytes are abasic unit measurement of information in computer processing
        bytes32 name; // the name of each proposal
        uint voteCount; // number of accumulated votes
    }

    Proposal[] public proposals;

    // mapping allows for us to create a store value with keys and indexes

    mapping(address => Voter) public voters; //voters get the address as a key and Voter for value 

    address public chairperson;

    constructor(bytes32[] memory proposalNames) {
        // memory defines a temporary data location in Solidity during runtime only of methods
        // we guarantee space for it

        // msg.sender is a global variable that states the person 
        // who is curently connecting to the contract
        chairperson = msg.sender;

        // add 1 to chairperson weigth
        voters[chairperson].weight = 1;        

        // will add the proposal names to the smart contract upon deployment
        for(uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    // function authenticate voter

    function giveRightToVote(address voter) public {
        require(msg.sender == chairperson, 
                "Only the Chairperson can give access to vote");
        // require that the voter hasn`t voted yet
        require(!voters[voter].voted, 
                "The voter has alredy voted");
        require(voters[voter].weight == 0);
        
        voters[voter].weight = 1;
    }
    // function for voting

    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight !=0, "Has no right to vote");
        require(!sender.voted, "Already voted"); 
        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += sender.weight;       
    }
    
    // functions for showing the results

    // 1. function that shows the winning proposal by interger

    function winningProposal() public view returns (uint winningProposal_) {

        uint winningVoteCount = 0;
        for(uint i = 0; i < proposals.length; i++) {
            if(proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposal_ = i;
            }
        }        
    }

    // 2. function that shows the winner by name
    function winningName() public view returns (bytes32 winningName_) {
        winningName_ = proposals[winningProposal()].name;
    } 
}