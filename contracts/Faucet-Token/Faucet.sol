// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./MyToken.sol";

contract Faucet is MyToken {
    Token private immutable _token;
    uint256 private immutable _amount;
    uint256 private constant _requestInterval = 1 minutes;
    mapping(address => uint256) private _lastRequestedTime;

    event UseFaucet(address indexed Receiver, uint256 indexed Amount);

    constructor(address tokenAddress, uint256 amount) {
        _token = Token(tokenAddress);
        _amount = amount * (10 ** 18);
    }

    modifier canDrip() {
        require(
            getLastDripTime() + _requestInterval <= block.timestamp,
            "Recipient has to wait for 5 minutes"
        );
        _;
    }

    modifier tokenSet() {
        require(address(_token) != address(0), "Token address not set");
        _;
    }

    modifier amountSet() {
        require(_amount > 0, "Token address not set");
        _;
    }

    function drip() public tokenSet amountSet canDrip {
        require(msg.sender != address(0), "Cannot send token zero address");
        require(_token.balanceOf(address(this)) >= _amount, "Faucet Empty!");

        _token.transfer(msg.sender, _amount);
        _lastRequestedTime[msg.sender] = block.timestamp;

        emit UseFaucet(msg.sender, _amount);
    }

    function getLastDripTime() public view returns (uint256) {
        return _lastRequestedTime[msg.sender];
    }

    function dripCheck() public view returns (bool) {
        if (getLastDripTime() + _requestInterval <= block.timestamp) {
            return true;
        } else {
            return false;
        }
    }
}
