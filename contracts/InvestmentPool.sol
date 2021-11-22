// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/security/PullPayment.sol";

/**
 * @title Investment Pool
 * @dev Store & retrieve value in a variable
 */
contract InvestmentPool {

  struct Pool {
    uint256 poolId;
    string poolName;
    uint256 depositAmount;
    uint256 depositTotal;
    address[] members;
    mapping(address => uint256) userDeposits;
    bool isActive;
    uint256 round;
  }

  /* VARIABLES */

  address public owner = msg.sender;
  mapping(uint => Pool) poolsById;
  Pool[] pools;
  mapping(address => Pool[]) public userPools;

  /* EVENTS */

  event poolCreated(uint id);

  /* MODIFIERS */

  constructor() {
    owner = msg.sender;
  }

  /* FUNCTIONS */

  function createPool(address[] memory _poolMembers, uint256 _depositAmount) public returns(uint256) {
    Pool storage pool;
    pool.members = _poolMembers;
    pool.depositAmount = _depositAmount;
    pool.isActive = true; 
    userPools[msg.sender].push(pool);
    pools.push(pool);
    pool.poolId = pools.length;
    poolsById[pool.poolId] = pool;

    emit poolCreated(pool.poolId);
    return pool.poolId;
  }

  function getPoolMembers(uint256 _poolId) public view returns(address[] memory) {
    address[] memory _poolMembers = poolsById[_poolId].members;
    return _poolMembers;
  }

  // return the amount of funds in the pool
  function getPoolAmount() external view returns (uint256) {
    return address(this).balance;
  }

  function getUserPools(address _user) public view returns (Pool[] memory) {
    Pool[] memory currentPools = userPools[_user];
    return currentPools;
  }

  function depositFunds(uint256 _poolId) external payable {
    if(msg.value == 1 ether) {
      revert();
    }
    poolsById[poolsById].userDeposits[msg.sender] += msg.value;
  }

  //function depositFunds(address _depositor) external canDeposit(_depositor) {}
  // pay out only to pool members

  // only pay pool member once
  //function makePayout(address _depositor) external canWithdraw(_depositor){}
}