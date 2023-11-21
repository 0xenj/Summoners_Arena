// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Airdrop {
    event TokenAirdrop(address beneficiary, uint amount);

    function getSum(uint256[] calldata _arr) public pure returns (uint sum) {
        for (uint i = 0; i < _arr.length; i++) sum = sum + _arr[i];
    }

    /// @notice Transfer ERC20 tokens to multiple addresses, authorization is required before use
    ///
    /// @param _token The address of ERC20 token for transfer
    /// @param _addresses The array of airdrop addresses
    /// @param _amounts The array of amount of tokens (airdrop amount for each address)
    function _airdropToken(
        address _token,
        address[] calldata _addresses,
        uint256[] calldata _amounts
    ) internal returns (bool) {
        require(
            _addresses.length == _amounts.length,
            "Lengths of Addresses and Amounts NOT EQUAL"
        );
        IERC20 token = IERC20(_token);
        uint _amountSum = getSum(_amounts);
        require(
            token.allowance(msg.sender, address(this)) >= _amountSum,
            "Need Approve ERC20 token"
        );

        for (uint8 i; i < _addresses.length; i++) {
            token.transferFrom(msg.sender, _addresses[i], _amounts[i]);
            emit TokenAirdrop(_addresses[i], _amounts[i]);
        }
        return true;
    }

    /// Transfer ETH to multiple addresses
    function _airdropMATIC(
        address payable[] calldata _addresses,
        uint256[] calldata _amounts
    ) public payable returns (bool) {
        require(
            _addresses.length == _amounts.length,
            "Lengths of Addresses and Amounts NOT EQUAL"
        );
        uint _amountSum = getSum(_amounts);
        require(msg.value == _amountSum, "Transfer amount error");
        for (uint256 i = 0; i < _addresses.length; i++) {
            _addresses[i].transfer(_amounts[i]);
            emit TokenAirdrop(_addresses[i], _amounts[i]);
        }
        return true;
    }
}
