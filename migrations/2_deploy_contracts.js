var SavingsPool = artifacts.require("./SavingsPool.sol");

module.exports = function(deployer) {
  deployer.deploy(SavingsPool);
};