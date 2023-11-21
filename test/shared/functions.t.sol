// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "foundry-test-utility/contracts/utils/console.sol";
import "foundry-test-utility/contracts/utils/stdCheats.sol";
import "foundry-test-utility/contracts/utils/vm.sol";
import {CheatCodes} from "foundry-test-utility/contracts/utils/cheatcodes.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Constants} from "./constants.t.sol";
import {Errors} from "./errors.t.sol";
import {MockERC20} from "../../contracts/test_contracts/MockERC20.sol";
import {Cards} from "../../contracts/Game-Airdrop/Cards.sol";

contract Functions is Constants, Errors {
    Cards public game;

    MockERC20 public token;

    enum TestType {
        Standard
    }

    function initialize_tests() public returns (Cards) {
        vm.roll(1);
        vm.warp(100);
        vm.startPrank(ADMIN);

        token = new MockERC20();

        vm.roll(block.number + 1);
        vm.warp(block.timestamp + 100);

        game = new Cards(ADMIN);

        vm.stopPrank();
        vm.roll(block.number + 1);
        vm.warp(block.timestamp + 100);

        return game;
    }

    event PackOpened(
        address indexed user,
        uint256[] cardIds,
        uint256[] amounts
    );
    event Exploration(address indexed user, uint256 tokenId, bool success);
    event TeamCreated(
        address indexed user,
        uint256 totalPower,
        uint256[5] cardIds
    );
}
