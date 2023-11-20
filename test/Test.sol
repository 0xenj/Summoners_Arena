// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "foundry-test-utility/contracts/utils/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {Functions} from "./shared/functions.t.sol";

contract cardGame_test is Functions {
    function setUp() public {
        initialize_tests();
    }

    function test_game_name() public {
        assertEq(game.name(), CONTRACT_NAME);
    }

    function test_game_version() public {
        assertEq(game.version(), CONTRACT_VERSION);
    }
}
