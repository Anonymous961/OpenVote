import {ethers} from "hardhat"

describe("SimpleVoting", function(){
    async function deploy(){
        const Contract= await ethers.getContractFactory("SimpleVoting");
        const contract= await Contract.deploy();
        await contract.deployed()
        return {contract}
    }
    describe("Creating a ballot",function(){
        it("should create a ballot")
        it("should revert if the ballot has less than 2 options")
        it("should revert if the start time is less than the current time")
        it("should revert if the end time is less than or equal to the start time")
    })
})
