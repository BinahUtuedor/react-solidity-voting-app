const Ballot = artifacts.require('Ballot')
const ethers = require('ethers');

// require('chai').use(require('chai-as-promised')).should()

contract('Ballot', (accounts) => {
    const proposalNames = [
      '0x636f666665652d6d616368696e65000000000000000000000000000000000000',
      '0x6f66666963652d737570706c6965730000000000000000000000000000000000'
    ]

    let ballot
    let name

    before(async ()=> {
        ballot = await Ballot.deployed(proposalNames) 
        await ballot.giveRightToVote(accounts[1])
        await ballot.giveRightToVote(accounts[2])
        await ballot.vote(1, {from: accounts[1]})
        await ballot.vote(1, {from: accounts[2]})
    })

    it('should return 1 as winner', async() => { 
      winning_proposal = await ballot.winningProposal()
      assert.equal(winning_proposal, '1', 'The winner is proposal 1')
    })

    it('should return office-supplies as winner', async() => {
      winner = await ballot.winningName()
      name = ethers.utils.parseBytes32String(winner);
      assert.equal(name, 'office-supplies', 'The winner is office-supplies')
    })
}) 