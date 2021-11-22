const InvestmentPool = artifacts.require("InvestmentPool");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("InvestmentPool", function (accounts) {
  let phInstance;

  beforeEach(async () => {
    phInstance = await InvestmentPool.new();
  });

  describe("Deploy contract", () => {
    it("pool amount equals 0", async () => {

      // verify pool amount is 0
      const poolAmount = await phInstance.getPoolAmount.call();
      assert.equal(poolAmount, 0, `Initial state should be zero`);
    });
  });

  describe("Create an investment pool", () => {
    it("pool should be created", async () => {

      // create pool
      const poolId = await phInstance.createPool(accounts, 2);
      
      // get pools where user is a member
      const newPool = await phInstance.getUserPools(accounts[0]);
      assert.equal(newPool.length, 1, `user should only be in one pool`);
      assert.equal(newPool[0].depositAmount, 2, `pool amount should be set to 2`);
      
      // get users in pool
      const poolMembers = await phInstance.getPoolMembers.call("1");
      assert.equal(poolMembers.length, 10);
    })
  });

  describe("Deposit funds in pool", () => {
    it("pool should accept deposits", async () => {

      // create pool
      const createPool = await phInstance.createPool(accounts, 2);

      // attempt to deposit funds in pool
      try {
        await phInstance.depositFunds.call(2, { from: accounts[0] });
      } catch (error) {
        assert.equal(phInstance.depositTotal, 2, `pool should have 2 eth deposited`);
      }
    })

    it("pool should not accept deposits less than deposit amount", async () => {

      // create pool
      const createPool = await phInstance.createPool(accounts, 2);

      // attempt to deposit funds in pool
      try {
        await phInstance.depositFunds.call(1, { from: accounts[0] });
      } catch (error) {
        assert.throws(error);
      }
    })
/*
    it("pool should not accept deposits from non members", async () => {
      // get deployed contract
      const phInstance = await InvestmentPool.deployed();

      const members = [];
      for(i = 0; i < accounts.length - 1; i++) {
        members.push(accounts[i]);
      }

      // create pool
      const createPool = await phInstance.createPool(members, 2, { from: accounts[0] });

      // attempt to deposit funds in pool
      try {
        await phInstance.depositFunds(2, { from: accounts[accounts.length - 1] });
      } catch (error) {
        //assert();
      }
    })*/
  });
/*
  describe("Distribute pool funds", () => {
    it("funds should be distributed", async () => {
      // get deployed contract
      const phInstance = await InvestmentPool.deployed();

      // create pool
      const createPool = await phInstance.createPool(accounts, 2, { from: accounts[0] });
    })

    it("funds should not be distributed", async () => {
      // get deployed contract
      const phInstance = await InvestmentPool.deployed();

      // create pool
      const createPool = await phInstance.createPool(accounts, 2, { from: accounts[0] });
    })
  });
  
  describe("Withdraw pool funds", () => {
    it("funds should be withdrawn to member", async () => {
      // get deployed contract
      const phInstance = await InvestmentPool.deployed();

      // create pool
      const createPool = await phInstance.createPool(accounts, 2, { from: accounts[0] });
    })

    it("funds should not be withdrawn to non member", async () => {
      // get deployed contract
      const phInstance = await InvestmentPool.deployed();

      // create pool
      const createPool = await phInstance.createPool(accounts, 2, { from: accounts[0] });
    })

    it("funds withdrawn should not be more than total amount", async () => {
      // get deployed contract
      const phInstance = await InvestmentPool.deployed();

      // create pool
      const createPool = await phInstance.createPool(accounts, 2, { from: accounts[0] });
    })
  });*/
});