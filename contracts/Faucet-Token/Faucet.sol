// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Faucet is Ownable {
    address public _token;
    uint256 private constant _dripInterval = 1 minutes;
    uint256 private _amount;
    mapping(address => uint256) private _lastDripTime;

    event UseFaucet(address indexed Receiver, uint256 indexed Amount);

    constructor(address token, uint256 amount) {
        _token = token;
        _amount = amount * (10 ** 18);
    }

    constructor(address _tokenContract) {
        tokenContract = _tokenContract; // set token contract
    }

    modifier canDrip() {
        require(
            getLastDripTime(msg.sender) + _dripInterval <= block.timestamp,
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

    function setAmount(uint256 amount) public onlyOwner {
        _amount = amount * (10 ** 18);
    }

    function drip() external tokenSet amountSet canDrip {
        IERC20 token = IERC20(_token);
        require(
            token.balanceOf(address(this)) >= amountAllowed,
            "Faucet Empty!"
        );

        token.transfer(msg.sender, amountAllowed);
        _lastDripTime[msg.sender] = block.timestamp;

        emit UseFaucet(msg.sender, amountAllowed);
    }

    function getLastDripTime() public view returns (uint256) {
        return _lastDripTime[msg.sender];
    }

    function dripCheck() public view returns (bool) {
        if (getLastDripTime(msg.sender) + _dripInterval <= block.timestamp) {
            return true;
        } else {
            return false;
        }
    }
}
