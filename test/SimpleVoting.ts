import { ethers } from "hardhat";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { time } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { BigNumber, Contract } from "ethers";

describe("SimpleVoting", function () {
    async function deploy() {
        const Contract = await ethers.getContractFactory("SimpleVoting");
        const contract = await Contract.deploy();
        return { contract }
    }
    describe("Creating a ballot", function () {
        it("should create a ballot", async () => {
            const { contract } = await loadFixture(deploy)
            const startTime = await time.latest() + 60
            const duration = 300
            const question = "Who is the greatest rapper of all time?"
            const options = [
                "Tupac Shakur",
                "The Notorious B.I.G.",
                "Eminem",
                "Jay-Z"
            ]
            await contract.createBallot(question, options, startTime, duration)
            const ballot = await contract.getBallotByIndex(0);

            expect(ballot.questions).to.equal(question);
            expect(ballot.options).to.deep.equal(options);
            expect(ballot.startTime).to.equal(startTime);
            expect(ballot.duration).to.equal(duration);

        })
        it("should revert if the ballot has less than 2 options", async () => {
            const { contract } = await loadFixture(deploy);
            const startTime = (await time.latest()) + 60;
            const duration = 300;
            const question = "Who is the greatest rapper of all time?";
            const options = ["Tupac Shakur"];

            await expect(contract.createBallot(
                question, options, startTime, duration
            )).to.be.revertedWith("Provide at minimum two options")

        })
        it("should revert if the start time is less than the current time", async () => {
            const { contract } = await loadFixture(deploy)
            const startTime = await time.latest() - 60 // start the ballot 60 seconds before the current time
            const duration = 300 // the ballot will be open for 300 seconds
            const question = "Who is the greatest rapper of all time?"
            const options = [
                "Tupac Shakur",
                "The Notorious B.I.G.",
                "Eminem",
                "Jay-Z"
            ]
            await expect(contract.createBallot(
                question, options, startTime, duration
            )).to.be.revertedWith("Start time must be in the future")
        })
        it("should revert if the duration is less than 1", async function () {
            const { contract } = await loadFixture(deploy)
            const startTime = await time.latest() + 60 // start the ballot in 60 seconds
            const duration = 0 // the ballot will never be open
            const question = "Who is the greatest rapper of all time?"
            const options = [
                "Tupac Shakur",
                "The Notorious B.I.G.",
                "Eminem",
                "Jay-Z"
            ]
            await expect(contract.createBallot(
                question, options, startTime, duration
            )).to.be.revertedWith("Duration must be greater than 0")
        })
    });
    describe("Casting a vote", function () {
        let contract: Contract;
        const duration = 300;

        beforeEach(async () => {
            const fixture = { contract } = await loadFixture(deploy)
            const startTime = await time.latest() + 60;
            const question = "Who is the greatest rapper of all time?"
            const options = [
                "Tupac Shakur",
                "The Notorious B.I.G.",
                "Eminem",
                "Jay-Z"
            ]
            await contract.createBallot(question, options, startTime, duration)
        })
        it("should be able to vote", async () => {
            const [signer] = await ethers.getSigners()
            await time.increase(61)
            await contract.cast(0, 0)
            expect(await contract.hasVoted(0, signer.address)).to.eq(true)
            expect(await contract.getTally(0, 0)).to.be.eq(1)
        })
        it("should revert if the user tries to vote before the start time", async () => {
            await expect(contract.cast(0, 0)).to.be.revertedWith("Can't cast before start time")
        })
        it("should revert if the user tries to vote after the end time", async () => {
            await time.increase(2000)
            await expect(contract.cast(0, 0)).to.be.revertedWith("Can't cast after end time")
        })
        it("should revert if the user tries to vote multiple times", async () => {
            await time.increase(61)
            await contract.cast(0, 0)
            await expect(contract.cast(0, 1)).to.be.revertedWith("Address already casted a vote for ballot")
        })
    })
})
