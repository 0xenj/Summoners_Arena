// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "foundry-test-utility/contracts/utils/console.sol";
import {CheatCodes} from "foundry-test-utility/contracts/utils/cheatcodes.sol";
import {Signatures} from "foundry-test-utility/contracts/shared/signatures.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import {Constants} from "./constants.t.sol";
import {Errors} from "./errors.t.sol";
import {TestStorage} from "./testStorage.t.sol";

import {MockERC20} from "../../mocks/MockERC20.sol";
import {MockERC721} from "../../mocks/MockERC721.sol";
import {SimpleNftMarketplace} from "../../SimpleNftMarketplace.sol";

interface IERC721 {
    function mint(address sender, uint256 tokenId) external;

    function approve(address to, uint256 tokenId) external;

    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);
}

interface IERC20 {
    function mint(address sender, uint256 amount) external;

    function approve(address to, uint256 amount) external;
}

contract Functions is Constants, Errors, TestStorage, Signatures {
    SimpleNftMarketplace public marketplace;

    MockERC20 public token;

    MockERC721 public nft1;
    MockERC721 public nft2;
    MockERC721 public nft3;

    enum TestType {
        Standard
    }

    function initialize_tests(
        uint8 LOG_LEVEL_
    ) public returns (SimpleNftMarketplace) {
        // Set general test settings
        _LOG_LEVEL = LOG_LEVEL_;
        vm.roll(1);
        vm.warp(100);
        vm.startPrank(ADMIN);

        marketplace = new SimpleNftMarketplace();

        token = new MockERC20();
        nft1 = new MockERC721();
        nft2 = new MockERC721();
        nft3 = new MockERC721();

        marketplace.initialize(TREASSURY);

        marketplace.giveModeratorAccess(MODERATOR);

        vm.stopPrank();
        vm.roll(block.number + 1);
        vm.warp(block.timestamp + 100);

        return marketplace;
    }

    event TransactionFeeChanged(uint32 indexed oldFee, uint32 indexed newFee);
    event SupportedContractRemoved(address indexed contractAddress);
    event SupportedContractAdded(address indexed contractAddress);
    event ListingCreated(
        uint256 listingId,
        address tokenContract,
        uint256 tokenId,
        uint256 salePrice,
        address seller
    );
    event Sale(uint256 listingId, address buyer);
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );
