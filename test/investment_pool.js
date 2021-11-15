const InvestmentPool = artifacts.require("InvestmentPool");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("InvestmentPool", function (accounts) {
  it("should assert true", async function () {
    await InvestmentPool.deployed();
    return assert.isTrue(true);
  });

  it("pool amount equals 0", async () => {
    // get deployed contract
    const phInstance = await InvestmentPool.deployed();

    // verify pool amount is 0
    const poolAmount = await phInstance.getPoolAmount.call();
    assert.equal(poolAmount, 0, `Initial state should be zero`);
  });

  describe("Create an investment pool", () => {
    it("pool should be created", async () => {
      // get deployed contract
      const phInstance = await InvestmentPool.deployed();

      // create pool
      const createPool = await phInstance.createPool(accounts, 20, { from: accounts[0] });
      
      // get pools for user
      const newPool = await phInstance.getPools(accounts[0], { from: accounts[0] });
      assert.equal(newPool[0].depositAmount, 20, `pool amount should be set to 20`);

      //const poolMembers = await phInstance.getPoolMembers(poolId);
      //assert.equal(poolMembers, accounts);
    })
  });

  describe("Deposit funds in pool", () => {
    it("pool should accept deposits", async () => {
      // get deployed contract
      const phInstance = await InvestmentPool.deployed();

      // create pool
      const createPool = await phInstance.createPool(accounts, 20, { from: accounts[0] });

      // attempt to deposit funds in pool
      try {
        await phInstance.depositFunds(20, { from: accounts[0] });
      } catch (error) {
        //assert();
      }
    })

    it("pool should not accept deposits less than deposit amount", async () => {
      // get deployed contract
      const phInstance = await InvestmentPool.deployed();

      // create pool
      const createPool = await phInstance.createPool(accounts, 20, { from: accounts[0] });

      // attempt to deposit funds in pool
      try {
        await phInstance.depositFunds(10, { from: accounts[0] });
      } catch (error) {
        //assert();
      }
    })

    it("pool should not accept deposits from non members", async () => {
      // get deployed contract
      const phInstance = await InvestmentPool.deployed();

      const members = [];
      for(i = 0; i < accounts.length - 1, i++) {
        members.push(accounts[i]);
      }

      // create pool
      const createPool = await phInstance.createPool(members, 20, { from: accounts[0] });

      // attempt to deposit funds in pool
      try {
        await phInstance.depositFunds(20, { from: accounts[accounts.length - 1] });
      } catch (error) {
        //assert();
      }
    })
  });

  describe("Distribute pool funds", () => {
    it("funds should be distributed", async () => {
      // get deployed contract
      const phInstance = await InvestmentPool.deployed();

      // create pool
      const createPool = await phInstance.createPool(accounts, 20, { from: accounts[0] });
    })

    it("funds should not be distributed", async () => {
      // get deployed contract
      const phInstance = await InvestmentPool.deployed();

      // create pool
      const createPool = await phInstance.createPool(accounts, 20, { from: accounts[0] });
    })
  });
});
