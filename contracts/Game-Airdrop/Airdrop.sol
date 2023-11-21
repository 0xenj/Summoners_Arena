// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Airdrop is Ownable {
    IERC20 public tokenAddr;

    event TokenTransfer(address beneficiary, uint amount);

    constructor(address initialOwner, IERC20 _tokenAddr) Ownable(initialOwner) {
        tokenAddr = _tokenAddr;
    }

    function dropTokens(
        address[] memory _recipients,
        uint256[] memory _amount
    ) public onlyOwner returns (bool) {
        for (uint i = 0; i < _recipients.length; i++) {
            require(_recipients[i] != address(0));
            require(IERC20(tokenAddr).transfer(_recipients[i], _amount[i]));
        }

        return true;
    }

    function dropMatic(
        address[] memory _recipients,
        uint256[] memory _amount
    ) public payable onlyOwner returns (bool) {
        uint total = 0;

        for (uint j = 0; j < _amount.length; j++) {
            total = total.add(_amount[j]);
        }

        require(total <= msg.value);
        require(_recipients.length == _amount.length);

        for (uint i = 0; i < _recipients.length; i++) {
            require(_recipients[i] != address(0));
            payable(_recipients[i]).transfer(_amount[i]);
            emit EtherTransfer(_recipients[i], _amount[i]);
        }

        return true;
    }

    function updateTokenAddress(address newTokenAddr) public onlyOwner {
        tokenAddr = newTokenAddr;
    }

    function withdrawTokens(address beneficiary) public onlyOwner {
        require(
            Token(tokenAddr).transfer(
                beneficiary,
                Token(tokenAddr).balanceOf(address(this))
            )
        );
    }

    function withdrawEther(address payable beneficiary) public onlyOwner {
        beneficiary.transfer(address(this).balance);
    }
}
