// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Faucet is Ownable, IERC20 {
    address public _token;
    uint256 private constant _dripInterval = 1 minutes;
    uint256 private _amount;
    mapping(address => uint256) private _lastDripTime;

    event UseFaucet(address indexed Receiver, uint256 indexed Amount);

    constructor(
        address token,
        uint256 amount,
        address initialOwner
    ) Ownable(initialOwner) {
        _token = token;
        _amount = amount * (10 ** 18);
    }

    modifier canDrip() {
        require(
            getLastDripTime() + _dripInterval <= block.timestamp,
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
        require(token.balanceOf(address(this)) >= _amount, "Faucet Empty!");

        token.transfer(msg.sender, _amount);
        _lastDripTime[msg.sender] = block.timestamp;

        emit UseFaucet(msg.sender, _amount);
    }

    function getLastDripTime() public view returns (uint256) {
        return _lastDripTime[msg.sender];
    }

    function dripCheck() public view returns (bool) {
        if (getLastDripTime() + _dripInterval <= block.timestamp) {
            return true;
        } else {
            return false;
        }
    }
}
