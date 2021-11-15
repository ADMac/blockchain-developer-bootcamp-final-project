// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Investment Pool
 * @dev Store & retrieve value in a variable
 */
contract InvestmentPool {

  struct Pool {
    string poolId;
    string poolName;
    uint256 depositAmount;
    address[] members;
    bool isActive;
    uint256 round;
  }

  address public owner = msg.sender;
  mapping(address => Pool[]) public userPools;
  uint256 public poolAmount;

  constructor() {
    owner = msg.sender;
  }

  // return the amount of funds in the pool
  function getPoolAmount() public view returns (uint256) {
    return poolAmount;
  }

  function getPools(address _user) public view returns (Pool[] memory) {
    Pool[] memory currentPools = userPools[_user];
    return currentPools;
  }

  function createPool(address[] memory _poolMembers, uint256 _depositAmount) public {
    Pool memory pool;
    pool.members = _poolMembers;
    pool.depositAmount = _depositAmount;
    pool.isActive = true; 
    userPools[msg.sender].push(pool);
  }
/*
  function addDepositors(address dep) public {
    poolMembers[dep] = true;
    depositors += 1;
  }
*/
  //function depositFunds(address _depositor) external canDeposit(_depositor) {}
  // pay out only to pool members

  // only pay pool member once
  //function makePayout(address _depositor) external canWithdraw(_depositor){}
}
