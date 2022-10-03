//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract ETHPool is AccessControl {
  event Deposit(address indexed user, uint256 amount);
  event Withdrew(address indexed user, uint256 amount);
  event DepositedRewards(address indexed account, uint256 rewards);

  bytes32 public constant TEAM_MEMBER = keccak256("TEAM_MEMBER");

  mapping(address => uint256) public userShares;
  uint256 public totalShares;

  constructor() {
    _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    _grantRole(TEAM_MEMBER, msg.sender);
  }

  function deposit() external payable {
    uint256 depositValue = msg.value;
    uint256 poolEth = address(this).balance - depositValue;

    uint256 share = (totalShares * poolEth == 0)
      ? depositValue
      : (depositValue * totalShares) / poolEth;

    totalShares += share;

    userShares[msg.sender] += share;

    emit Deposit(msg.sender, depositValue);
  }

  function withdraw() external {
    uint256 amount = (userShares[msg.sender] * address(this).balance) /
      totalShares;

    totalShares -= userShares[msg.sender];
    userShares[msg.sender] = 0;

    Address.sendValue(payable(msg.sender), amount);

    emit Withdrew(msg.sender, amount);
  }

  function depositRewards() public payable onlyRole(TEAM_MEMBER) {
    emit DepositedRewards(msg.sender, msg.value);
  }

  receive() external payable {
    revert("No Receive: Only with Deposit function");
  }
}
