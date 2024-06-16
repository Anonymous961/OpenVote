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
    mapping(uint =>mapping(uint=>uint)) private _tally;
    mapping(uint=> mapping(address=>bool)) public hasVoted;

    event BallotCreated(uint indexed ballotIndex, string question , string[] options, uint startTime, uint duration);
    event VoteCast(uint indexed ballotIndex,uint indexed optionIndex, address indexed voter);

    /// @notice Creates a new ballot
    /// @param question_ The question for the ballot
    /// @param options_ The options for the ballot
    /// @param startTime_ The start time for the ballot (in seconds since Unix epoch)
    /// @param duration_ The duration for which the ballot is active (in seconds)

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
        emit BallotCreated(counter, question_, options_, startTime_, duration_);
        counter++;
    }

    /// @notice Retrieves a ballot by its index
    /// @param index_ The index of the ballot
    /// @return ballot
    function getBallotByIndex(uint index_) external view returns(Ballot memory ballot){
        return _ballots[index_];
    }

    function getNumberofBallots() public view returns(uint){
        return counter;
    }

    /// @notice Casts a vote on a ballot
    /// @param ballotIndex_ The index of the ballot
    /// @param optionIndex_ The index of the option to vote for
    function cast(uint ballotIndex_, uint optionIndex_) external {
        require(!hasVoted[ballotIndex_][msg.sender],"Address already casted a vote for ballot");
        Ballot memory ballot = _ballots[ballotIndex_];
        require(block.timestamp>= ballot.startTime,"Can't cast before start time");
        require(block.timestamp<= ballot.startTime+ballot.duration,"Can't cast after end time");
        _tally[ballotIndex_][optionIndex_]++;
        hasVoted[ballotIndex_][msg.sender]=true;
        emit VoteCast(ballotIndex_, optionIndex_, msg.sender);
    }

    /// @notice retrive tally for a specific option in a ballot
    /// @param ballotIndex_ the index of the ballot
    /// @param optionIndex_ The index of the option
    /// @return The tally for the option
    function getTally(uint ballotIndex_,uint optionIndex_) external view returns(uint){
        return _tally[ballotIndex_][optionIndex_];
    }
    
    /// @notice Retrieves the results for a ballot
    /// @param ballotIndex_ The index of the ballot
    /// @return The results array
    function results(uint ballotIndex_) external view returns(uint[] memory ){
        Ballot memory ballot = _ballots[ballotIndex_];
        uint len= ballot.options.length;
        uint[] memory result = new uint[](len);
        for(uint i=0;i<len;i++){
            result[i]= _tally[ballotIndex_][i];
        }
        return result;
    }

    /// @notice Retrieves the winners of a ballot
    /// @param ballotIndex_ The index of the ballot
    /// @return The winners array
    function winners(uint ballotIndex_) public view returns(bool[] memory){
        Ballot memory ballot= _ballots[ballotIndex_];
        uint len= ballot.options.length;
        uint max;
        for(uint i=0;i<len;i++){
            uint votes= _tally[ballotIndex_][i];
            if(votes>max){
                max= votes;
            }
        }
        bool[] memory winner = new bool[](len);
        for(uint i=0;i<len;i++){
            if(_tally[ballotIndex_][i]==max){
                winner[i]=true;
            }
        }
        return winner;
    }
}