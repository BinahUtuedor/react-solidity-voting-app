const Ballot = artifacts.require('Ballot')

module.exports = function (deployer) {
  deployer.deploy(
    Ballot, [
      '0x636f666665652d6d616368696e65000000000000000000000000000000000000',
      '0x6f66666963652d737570706c6965730000000000000000000000000000000000'
    ]
    )
}
