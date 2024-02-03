// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import 'foundry-test-utility/contracts/utils/console.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import { Helper } from './shared/helper.t.sol';
import { Errors } from './shared/errors.t.sol';

contract Cards_test is Helper {

  function setUp() public {
    initialize_helper();
  }

  function test_SimpleNftMarketplace_basic_name() public {
    assertEq(marketplace.name(), CONTRACT_NAME);
  }

  function test_SimpleNftMarketplace_basic_version() public {
    assertEq(marketplace.version(), CONTRACT_VERSION);
  }
}