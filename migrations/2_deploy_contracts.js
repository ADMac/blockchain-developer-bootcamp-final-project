var InvestmentPool = artifacts.require("./InvestmentPool.sol");

module.exports = function(deployer) {
  deployer.deploy(InvestmentPool);
};
