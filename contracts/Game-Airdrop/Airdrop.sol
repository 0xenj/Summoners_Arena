// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Airdrop is Ownable {
    IERC20 public tokenAddr;

    constructor(address initialOwner, IERC20 _tokenAddr) Ownable(initialOwner) {
        tokenAddr = _tokenAddr;
    }
}
