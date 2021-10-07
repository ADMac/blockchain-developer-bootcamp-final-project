// SPDX-License-Identifier: MIT
pragma solidity >=0.5.22 <0.9.0;

contract SavingsPool {
  mapping(address -> bool) public poolMembers;
  uint depositAmount;
  address public owner = msg.sender;

  event depositorAdded(address _depositor);
  event depositMade(address _depositor, uint amount);
  event payout(address _depositor, uint amount);

  constructor() public {
    owner = msg.sender;
  }

  // add pool members
  function addDepositor(address _depositor) external canAddDepositor() {
    members[_depositor] = false;
    depositors.size += 1;
  }

  // accept deposits
  modifier canDeposit(address _depositor) { 
    poolMembers[_depositor] == true; 
    _; 
  }
  function acceptDeposit(address _depositor) external canDeposit(_depositor) {}
  // pay out only to pool members
  modifier canAddDepositor() { 
    members.size + 1 >= depositors.size;
    _; 
  }
  // only pay pool member once
}
