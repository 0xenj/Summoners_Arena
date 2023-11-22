// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    constructor(
        address initialOwner
    ) Ownable(initialOwner) ERC20("Summoners", "SUMM") {
        _mint(msg.sender, 100000000 * (10 ** 18));
    }

    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }
}
