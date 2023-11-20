// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";

/*import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";*/

contract Cards is ERC1155, Ownable, ERC1155Burnable /*VRFConsumerBaseV2*/ {
    uint256 public packPrice = 0.001 ether;
    uint256 public constant explorationCooldown = 4 hours;

    struct Card {
        uint256 id;
        uint256 power;
        uint256 attributes; //1= elemental, 2= arcanic, 3= warrior, 4= spiritual, 5= mythic
    }

    struct Team {
        uint256 totalPower;
        uint256[5] cardIds;
    }

    /*VRFCoordinatorV2Interface COORDINATOR;
    uint64 private s_subscriptionId;
    bytes32 private keyHash;
    uint32 private callbackGasLimit;
    uint16 private requestConfirmations;
    uint32 private numWords;
    mapping(uint256 => uint256[]) public requestIdToRandomNumbers;*/

    mapping(uint256 => Card) public cards;
    mapping(address => Team) public teams;
    mapping(address => uint256) public lastOpenedFreePack;
    mapping(address => uint256) public lastExplorationTime;

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

    /*event RandomnessRequested(uint256 requestId);
    event RandomnessFulfilled(uint256 requestId, uint256[] randomNumbers);*/

    constructor(
        address initialOwner
    )
        // uint64 subscriptionId
        ERC1155("")
        // VRFConsumerBaseV2(0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625)
        Ownable(initialOwner)
    {
        /*COORDINATOR = VRFCoordinatorV2Interface(
            0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625
        );
        s_subscriptionId = subscriptionId;
        keyHash = 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c;
        callbackGasLimit = 100000;
        requestConfirmations = 3;
        numWords = 1;*/
        _initializeCards();
    }

    function _initializeCards() internal onlyOwner {
        cards[0] = Card(0, 10, 4);
        cards[1] = Card(1, 11, 3);
        cards[2] = Card(2, 11, 2);
        cards[3] = Card(3, 13, 4);
        cards[4] = Card(4, 15, 1);
        cards[5] = Card(5, 16, 1);
        cards[6] = Card(6, 16, 5);
        cards[7] = Card(7, 18, 5);
        cards[8] = Card(8, 20, 2);
        cards[9] = Card(9, 20, 3);
        cards[10] = Card(10, 25, 4);
        cards[11] = Card(11, 25, 2);
        cards[12] = Card(12, 27, 1);
        cards[13] = Card(13, 27, 1);
        cards[14] = Card(14, 28, 3);
        cards[15] = Card(15, 29, 5);
        cards[16] = Card(16, 30, 4);
        cards[17] = Card(17, 32, 2);
        cards[18] = Card(18, 34, 5);
        cards[19] = Card(19, 35, 3);
        cards[20] = Card(20, 40, 1);
        cards[21] = Card(21, 42, 3);
        cards[22] = Card(22, 42, 4);
        cards[23] = Card(23, 43, 2);
        cards[24] = Card(24, 43, 4);
        cards[25] = Card(25, 45, 1);
        cards[26] = Card(26, 47, 2);
        cards[27] = Card(27, 47, 5);
        cards[28] = Card(28, 48, 3);
        cards[29] = Card(29, 50, 5);
        cards[30] = Card(30, 60, 4);
        cards[31] = Card(31, 62, 3);
        cards[32] = Card(32, 62, 4);
        cards[33] = Card(33, 63, 3);
        cards[34] = Card(34, 64, 1);
        cards[35] = Card(35, 66, 1);
        cards[36] = Card(36, 66, 5);
        cards[37] = Card(37, 68, 2);
        cards[38] = Card(38, 69, 5);
        cards[39] = Card(39, 70, 2);
        cards[40] = Card(40, 85, 5);
        cards[41] = Card(41, 86, 2);
        cards[42] = Card(42, 87, 5);
        cards[43] = Card(43, 89, 1);
        cards[44] = Card(44, 90, 4);
        cards[45] = Card(45, 92, 1);
        cards[46] = Card(46, 93, 2);
        cards[47] = Card(47, 95, 3);
        cards[48] = Card(48, 97, 4);
        cards[49] = Card(49, 100, 3);
    }

    // Fonction pour demander un nombre aléatoire à Chainlink VRF
    /*function requestRandomNumber() internal returns (uint256 requestId) {
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );

        // Émettre un événement pour signaler qu'une demande a été faite
        emit RandomnessRequested(requestId);
    }*/

    // Fonction de rappel appelée par Chainlink VRF avec la réponse
    /*function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {
        requestIdToRandomNumbers[requestId] = randomWords;

        emit RandomnessFulfilled(requestId, randomWords);
    }*/

    function createTeam(uint256[5] calldata cardIds) external {
        uint256 totalPower = 0;

        for (uint i = 0; i < 5; i++) {
            require(
                balanceOf(msg.sender, cardIds[i]) > 0,
                "User does not own this card"
            );

            Card memory card = cards[cardIds[i]];
            totalPower += card.power;
        }

        teams[msg.sender] = Team({totalPower: totalPower, cardIds: cardIds});

        emit TeamCreated(msg.sender, totalPower, cardIds);
    }

    function openFreePack() external {
        require(
            block.timestamp - lastOpenedFreePack[msg.sender] >= 1 days,
            "Must wait 1 day to open a free pack"
        );

        _openPack(msg.sender);
        lastOpenedFreePack[msg.sender] = block.timestamp;
    }

    function openBuyPack() external payable {
        require(msg.value >= packPrice, "Insufficient ETH sent");

        if (msg.value > packPrice) {
            payable(msg.sender).transfer(msg.value - packPrice);
        }

        _openPack(msg.sender);
    }

    function _openPack(address user) internal {
        uint256[] memory ids = new uint256[](5);
        uint256[] memory amounts = new uint256[](5);

        for (uint256 i = 0; i < 5; i++) {
            /*uint256 randomness = requestRandomNumber();*/
            uint256 randomness = uint256(
                keccak256(
                    abi.encodePacked(blockhash(block.number - 1), user, i)
                )
            );
            uint256 categoryRandom = randomness % 100;
            uint256 idRandom = (randomness / 100) % 10;

            if (categoryRandom < 60) {
                ids[i] = idRandom;
            } else if (categoryRandom < 84) {
                ids[i] = idRandom + 10;
            } else if (categoryRandom < 94) {
                ids[i] = idRandom + 20;
            } else if (categoryRandom < 99) {
                ids[i] = idRandom + 30;
            } else {
                ids[i] = idRandom + 40;
            }

            amounts[i] = 1;
        }

        _mintBatch(user, ids, amounts, "");
        emit PackOpened(user, ids, amounts);
    }

    function explore(uint256 tokenId) external {
        require(balanceOf(msg.sender, tokenId) > 0, "You do not own this NFT");
        require(
            lastExplorationTime[msg.sender] + explorationCooldown <=
                block.timestamp,
            "Exploration cooldown not over yet"
        );

        lastExplorationTime[msg.sender] = block.timestamp;

        uint256 successProbability;

        if (tokenId < 10) {
            successProbability = 10;
        } else if (tokenId < 20) {
            successProbability = 15;
        } else if (tokenId < 30) {
            successProbability = 25;
        } else if (tokenId < 40) {
            successProbability = 50;
        } else {
            successProbability = 99;
        }

        uint256 randomness = uint256(
            keccak256(
                abi.encodePacked(
                    blockhash(block.number - 1),
                    msg.sender,
                    tokenId
                )
            )
        ) % 100;

        if (randomness < successProbability) {
            _openPack(msg.sender);
            emit Exploration(msg.sender, tokenId, true);
        } else {
            _burn(msg.sender, tokenId, 1);
            emit Exploration(msg.sender, tokenId, false);
        }
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyOwner {
        _mint(account, id, amount, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }

    function calculateTeamPower(
        uint256[5] calldata cardIds
    ) internal pure returns (uint256) {
        uint256 basePower = 0;
        uint256 multiplier = 10;
        mapping(uint256 => uint256) attributeCounts;
        uint256 legendaryCount = 0;
        uint256 epicCount = 0;

        for (uint i = 0; i < 5; i++) {
            uint256 cardId = cardIds[i];
            if (balanceOf(msg.sender, cardId) > 0) {
                Card memory card = cards[cardIds[i]];
                basePower += card.power;
                attributeCounts[card.attributes]++;

                if (cardIds >= 40 && cardIds <= 49) {
                    legendaryCount++;
                } else if (cardId >= 30 && cardId <= 39) {
                    epicCount++;
                }
            }
        }

        uint256 distinctAttributes = 0;
        for (uint256 attribute = 1; attribute <= 5; attribute++) {
            if (attributeCounts[attribute] > 0) {
                distinctAttributes++;
            }
        }

        if (distinctAttributes == 5) {
            multiplier = 2;
        } else if (distinctAttributes == 4) {
            multiplier = 15; // Multiplié par 10 pour éviter les fractions
        } else if (distinctAttributes == 3) {
            multiplier = 13; // Multiplié par 10
        } else if (distinctAttributes == 2) {
            multiplier = 12; // Multiplié par 10
        } else if (distinctAttributes == 1) {
            multiplier = 11; // Multiplié par 10
        }

        // Ajout du bonus de rareté
        multiplier += legendaryCount * 5; // Multiplié par 10
        multiplier += epicCount;

        // Calcul de la puissance totale
        return (basePower * multiplier) / 10; // Diviser par 10 pour ajuster le multiplicateur
    }

    function teamPower(address user) external view returns (uint256) {
        Team memory userTeam = teams[user];
        uint256 totalPower = 0;

        for (uint i = 0; i < 5; i++) {
            uint256 cardId = userTeam.cardIds[i];

            if (balanceOf(user, cardId) > 0) {
                totalPower += cards[cardId].power;
            }
        }

        return totalPower;
    }

    function showTeam(address user) external view returns (uint256[5] memory) {
        Team memory userTeam = teams[user];
        return userTeam.cardIds;
    }

    function getFreePackCooldown(address user) external view returns (uint256) {
        uint256 lastPackTime = lastOpenedFreePack[user];
        uint256 cooldownEnd = lastPackTime + 1 days;

        if (block.timestamp >= cooldownEnd) {
            return 0; // No cooldown left
        } else {
            return cooldownEnd - block.timestamp; // Return the remaining cooldown in seconds
        }
    }

    function getExplorationCooldown(
        address user
    ) external view returns (uint256) {
        uint256 lastExploreTime = lastExplorationTime[user];
        uint256 cooldownEnd = lastExploreTime + explorationCooldown;

        if (block.timestamp >= cooldownEnd) {
            return 0;
        } else {
            return cooldownEnd - block.timestamp;
        }
    }
}
