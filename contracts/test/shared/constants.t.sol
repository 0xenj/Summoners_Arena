// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Constants {
  // Constants value specific to the contracts we are testing.
  string constant CONTRACT_NAME = 'Summoners Arena';
  string constant CONTRACT_VERSION = '0.0.1';

  address constant ADMIN = address(42_000);

  uint256 DEFAULT_BLOCKS_COUNT = 10;
}