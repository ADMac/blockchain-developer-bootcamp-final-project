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
    bool isActive;
    uint256 round;
  }

  /* VARIABLES */

  address public owner = msg.sender;
  mapping(uint256 => Pool) public poolsById;
  Pool[] pools;
  mapping(address => Pool[]) public userPools;
  mapping(uint256 => mapping(address => bool)) userDepositTracker;

  /* EVENTS */

  event poolCreated(uint256 id);
  event depositMade(address depositor, uint256 amount);

  /* MODIFIERS */

  modifier canDeposit(uint256 _poolId) {
      require(userDepositTracker[_poolId][msg.sender] == true, "You cannot add deposits to this pool");
      _;
  }

  modifier canWithdraw(uint256 _poolId) {
      require(userDepositTracker[_poolId][msg.sender] == false, "You cannot withdraw funds from this pool");
      _;
  }

  constructor() {
    owner = msg.sender;
  }

  /* FUNCTIONS */

  function createPool(address[] memory _poolMembers, uint256 _depositAmount, string memory _name) public returns(uint256) {
    Pool memory pool = Pool(pools.length, _name, _depositAmount, 0, _poolMembers, true, 0); 
    pools.push(pool);
    userPools[msg.sender].push(pool);
    poolsById[pool.poolId] = pool;
    //pool.members = _poolMembers;
    //pool.depositAmount = _depositAmount;
    //pool.isActive = true;
    //pool.poolId = pools.length;

    emit poolCreated(pool.poolId);
    return pool.poolId;
  }

  function getPoolMembers(uint256 _poolId) public view returns(address[] memory) {
    address[] memory _poolMembers = poolsById[_poolId].members;
    return _poolMembers;
  }

  function getDepositTotal(uint256 _poolId) public view returns(uint256 _total) {
    return poolsById[_poolId].depositTotal;
  }

  // return the amount of funds in the pool
  function getPoolAmount() external view returns (uint256) {
    return address(this).balance;
  }

  function getUserPools(address _user) public view returns (Pool[] memory) {
    Pool[] memory currentPools = userPools[_user];
    return currentPools;
  }

  function depositFunds(uint256 _poolId) external payable canDeposit(_poolId){
    // ensure that deposit amount matches pool deposit amount
    //if(msg.value == pools[_poolId].depositAmount ** 18 wei) {
    if(msg.value == 10 ** 18 wei) {
      revert();
    }

    // add new funds to pool amount
    pools[_poolId].depositTotal += msg.value;

    // set canDeposit to false for the user/pool combo
    userDepositTracker[_poolId][msg.sender] = false;
  }

  // only pay pool member once
  function withdrawFunds(uint256 _poolId) external canWithdraw(_poolId){}

  // only pay pool member once
  //function makePayout(address _depositor) external canWithdraw(_depositor){}
}