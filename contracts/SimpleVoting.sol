// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract SimpleVoting{
    uint public counter=0;

    struct Ballot{
        string questions;
        string[] options;
        uint startTime;
        uint duration;
    }

    mapping(uint => Ballot) private _ballots;

    function createBallot(
        string memory question_,
        string[] memory options_,
        uint startTime_,
        uint duration_
    )external{
        require(options_.length>=2,"Provide at minimum two options");
        require(startTime_ > block.timestamp, "Start time must be in the future");
        require(duration_>0,"Duration must be greater than 0");
        _ballots[counter]=Ballot(question_,options_,startTime_,duration_);
        counter++;
    }

    function getBallotByIndex(uint index_) external view returns(Ballot memory ballot){
        ballot = _ballots[index_];
    }
}