//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title Ether Pool
 * @dev Challenge Solution for Exactly Finance
 */

contract ETHPoolV2 is AccessControl {
  /************************ 
  ======== EVENTS ========
  *************************/

  event Withdrew(address indexed user, uint256 amount, bytes data);

  event Deposited(address indexed user, uint256 amount);

  event DepositedRewards(uint256 amount);

  /************************ 
  ==== STATE VARIABLES ====
  *************************/

  bytes32 public constant TEAM_MEMBER = keccak256("TEAM_MEMBER");

  // Total Shares Distributed
  uint256 private _shares;

  // User shares held
  mapping(address => uint256) public share;

  /********************** 
  ===== CONSTRUCTOR =====
  ***********************/

  constructor() {
    _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    _grantRole(TEAM_MEMBER, msg.sender);
  }

  /*********************** 
  === PUBLIC FUNCTIONS ===
  ************************/

  function deposit() external payable {
    uint256 amount = msg.value;
    uint256 pool = address(this).balance - amount;
    uint256 amountOfShares;

    if (_shares * pool == 0) {
      amountOfShares = amount;
    } else {
      (amount * _shares) / pool;
    }

    unchecked {
      _shares += amountOfShares;
      share[msg.sender] += amountOfShares;
    }

    emit Deposited(msg.sender, amount);
  }

  function withdraw() external {
    uint256 pool = address(this).balance;
    uint256 amount = (share[msg.sender] * pool) / _shares;

    _shares -= share[msg.sender];
    share[msg.sender] = 0;

    (bool success, bytes memory data) = payable(msg.sender).call{
      value: amount
    }("");

    require(success, "Withdraw: Withdrawal failed");

    emit Withdrew(msg.sender, amount, data);
  }

  function depositRewards() public payable onlyRole(TEAM_MEMBER) {
    emit DepositedRewards(msg.value);
  }

  /**
   * @dev This receive function with revert evits dust ether or
   * possibles kill hacks.
   */
  receive() external payable {
    revert("No Receive: Only with Deposit function");
  }
}
