// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./MyToken.sol";

contract Faucet {
    MyToken private immutable _token;
    uint256 private immutable _amount;
    uint256 private constant _requestInterval = 1 minutes;
    mapping(address => uint256) public userNextBuyTime;

    event UseFaucet(address indexed Receiver, uint256 indexed Amount);

    constructor(address tokenAddress, uint256 amount) {
        _token = MyToken(tokenAddress);
        _amount = amount * (10 ** 18);
    }

    function requestTokens() public {
        require(msg.sender != address(0), "Cannot send token zero address");
        require(
            block.timestamp > userNextBuyTime[msg.sender],
            "Your next request time is not reached yet"
        );
        require(
            _token.transfer(msg.sender, _amount),
            "requestTokens(): Failed to Transfer"
        );
        userNextBuyTime[msg.sender] = block.timestamp + _requestInterval;

        emit UseFaucet(msg.sender, _amount);
    }

    function getNextBuyTime() public view returns (uint256) {
        return userNextBuyTime[msg.sender];
    }
}
