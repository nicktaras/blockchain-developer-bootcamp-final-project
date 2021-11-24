// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts-upgradeable@4.3.2/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable@4.3.2/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable@4.3.2/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable@4.3.2/token/ERC1155/extensions/ERC1155BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable@4.3.2/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable@4.3.2/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @custom:security-contact security@buildingblocks.eth
contract BuildingBlocks is Initializable, ERC1155Upgradeable, AccessControlUpgradeable, PausableUpgradeable, ERC1155BurnableUpgradeable, UUPSUpgradeable {
    bytes32 public constant URI_SETTER_ROLE = keccak256("URI_SETTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    
    using Counters for Counters.Counter;

    struct Block {
        uint id;
        uint skin; // e.g. 1 = ALICEBLUE
        int[] coords; // x, y, z
        string content; //
    }

    // store all blocks
    mapping(uint => Block) public blocks;
    
    // keep track of counter
    Counters.Counter private _tokenIdCounter;
    
    // call stack is close to free.
    // memory is cheaper
    // storage is expensive

    // state > always inside storage
    // structs, arrays, mappings are passed by 

    // TODO where is the best place to store
    // constant values e.g. on chain, off chain.
    // why not? If we mint from data off chain, what's the harm?

    // user will be able to download a pack of these colour blocks - current HTML named Colours list 2021.
    uint256 public constant DARKMATTER = 0;
    uint256 public constant ALICEBLUE = 1;
    uint256 public constant ANTIQUEWHITE = 2;
    uint256 public constant AQUA = 3;
    uint256 public constant AQUAMARINE = 4;
    uint256 public constant AZURE = 5;
    uint256 public constant BEIGE = 6;
    uint256 public constant BISQUE = 7;
    uint256 public constant BLACK = 8;
    uint256 public constant BLANCHEDALMOND = 9;
    uint256 public constant BLUE = 10;
    uint256 public constant BLUEVIOLET = 11;
    uint256 public constant BROWN = 12;
    uint256 public constant BURLYWOOD = 13;
    uint256 public constant CADETBLUE = 14;
    uint256 public constant CHARTREUSE = 15;
    uint256 public constant CHOCOLATE = 16;
    uint256 public constant CORAL = 17;
    uint256 public constant CORNFLOWERBLUE = 18;
    uint256 public constant CORNSILK = 19;
    uint256 public constant CRIMSON = 20;
    uint256 public constant CYAN = 21;
    uint256 public constant DARKBLUE = 22;
    uint256 public constant DARKCYAN = 23;
    uint256 public constant DARKGOLDENROD = 24;
    uint256 public constant DARKGRAY = 25;
    uint256 public constant DARKGREY = 26;
    uint256 public constant DARKGREEN = 27;
    uint256 public constant DARKKHAKI = 28;
    uint256 public constant DARKMAGENTA = 29;
    uint256 public constant DARKOLIVEGREEN = 30;
    uint256 public constant DARKORANGE = 31;
    uint256 public constant DARKORCHID = 32;
    uint256 public constant DARKRED = 33;
    uint256 public constant DARKSALMON = 34;
    uint256 public constant DARKSEAGREEN = 35;
    uint256 public constant DARKSLATEBLUE = 36;
    uint256 public constant DARKSLATEGRAY = 37;
    uint256 public constant DARKSLATEGREY = 38;
    uint256 public constant DARKTURQUOISE = 39;
    uint256 public constant DARKVIOLET = 40;
    uint256 public constant DEEPPINK = 41;
    uint256 public constant DEEPSKYBLUE = 42;
    uint256 public constant DIMGRAY = 43;
    uint256 public constant DIMGREY = 44;
    uint256 public constant DODGERBLUE = 45;
    uint256 public constant FIREBRICK = 46;
    uint256 public constant FLORALWHITE = 47;
    uint256 public constant FORESTGREEN = 48;
    uint256 public constant FUCHSIA = 49;
    uint256 public constant GAINSBORO = 50;
    uint256 public constant GHOSTWHITE = 51;
    uint256 public constant GOLD = 52;
    uint256 public constant GOLDENROD = 53;
    uint256 public constant GRAY = 54;
    uint256 public constant GREY = 55;
    uint256 public constant GREEN = 56;
    uint256 public constant GREENYELLOW = 57;
    uint256 public constant HONEYDEW = 58;
    uint256 public constant HOTPINK = 59;
    uint256 public constant INDIANRED = 60;
    uint256 public constant INDIGO = 61;
    uint256 public constant IVORY = 62;
    uint256 public constant KHAKI = 63;
    uint256 public constant LAVENDER = 64;
    uint256 public constant LAVENDERBLUSH = 65;
    uint256 public constant LAWNGREEN = 66;
    uint256 public constant LEMONCHIFFON = 67;
    uint256 public constant LIGHTBLUE = 68;
    uint256 public constant LIGHTCORAL = 69;
    uint256 public constant LIGHTCYAN = 70;
    uint256 public constant LIGHTGOLDENRODYELLOW = 71;
    uint256 public constant LIGHTGRAY = 72;
    uint256 public constant LIGHTGREY = 73;
    uint256 public constant LIGHTGREEN = 74;
    uint256 public constant LIGHTPINK = 75;
    uint256 public constant LIGHTSALMON = 76;
    uint256 public constant LIGHTSEAGREEN = 77;
    uint256 public constant LIGHTSKYBLUE = 78;
    uint256 public constant LIGHTSLATEGRAY = 79;
    uint256 public constant LIGHTSLATEGREY = 80;
    uint256 public constant LIGHTSTEELBLUE = 81;
    uint256 public constant LIGHTYELLOW = 82;
    uint256 public constant LIME = 83;
    uint256 public constant LIMEGREEN = 84;
    uint256 public constant LINEN = 85;
    uint256 public constant MAGENTA = 86;
    uint256 public constant MAROON = 87;
    uint256 public constant MEDIUMAQUAMARINE = 88;
    uint256 public constant MEDIUMBLUE = 89;
    uint256 public constant MEDIUMORCHID = 90;
    uint256 public constant MEDIUMPURPLE = 91;
    uint256 public constant MEDIUMSEAGREEN = 92;
    uint256 public constant MEDIUMSLATEBLUE = 93;
    uint256 public constant MEDIUMSPRINGGREEN = 94;
    uint256 public constant MEDIUMTURQUOISE = 95;
    uint256 public constant MEDIUMVIOLETRED = 96;
    uint256 public constant MIDNIGHTBLUE = 97;
    uint256 public constant MINTCREAM = 98;
    uint256 public constant MISTYROSE = 99;
    uint256 public constant MOCCASIN = 100;
    uint256 public constant NAVAJOWHITE = 101;
    uint256 public constant NAVY = 102;
    uint256 public constant OLDLACE = 103;
    uint256 public constant OLIVE = 104;
    uint256 public constant OLIVEDRAB = 105;
    uint256 public constant ORANGE = 106;
    uint256 public constant ORANGERED = 107;
    uint256 public constant ORCHID = 108;
    uint256 public constant PALEGOLDENROD = 109;
    uint256 public constant PALEGREEN = 110;
    uint256 public constant PALETURQUOISE = 111;
    uint256 public constant PALEVIOLETRED = 112;
    uint256 public constant PAPAYAWHIP = 113;
    uint256 public constant PEACHPUFF = 114;
    uint256 public constant PERU = 115;
    uint256 public constant PINK = 116;
    uint256 public constant PLUM = 117;
    uint256 public constant POWDERBLUE = 118;
    uint256 public constant PURPLE = 119;
    uint256 public constant REBECCAPURPLE = 120;
    uint256 public constant RED = 121;
    uint256 public constant ROSYBROWN = 122;
    uint256 public constant ROYALBLUE = 123;
    uint256 public constant SADDLEBROWN = 124;
    uint256 public constant SALMON = 125;
    uint256 public constant SANDYBROWN = 126;
    uint256 public constant SEAGREEN = 127;
    uint256 public constant SEASHELL = 128;
    uint256 public constant SIENNA = 129;
    uint256 public constant SILVER = 130;
    uint256 public constant SKYBLUE = 131;
    uint256 public constant SLATEBLUE = 132;
    uint256 public constant SLATEGRAY = 133;
    uint256 public constant SLATEGREY = 134;
    uint256 public constant SNOW = 135;
    uint256 public constant SPRINGGREEN = 136;
    uint256 public constant STEELBLUE = 137;
    uint256 public constant TAN = 138;
    uint256 public constant TEAL = 139;
    uint256 public constant THISTLE = 140;
    uint256 public constant TOMATO = 141;
    uint256 public constant TURQUOISE = 142;
    uint256 public constant VIOLET = 143;
    uint256 public constant WHEAT = 144;
    uint256 public constant WHITE = 145;
    uint256 public constant WHITESMOKE = 146;
    uint256 public constant YELLOW = 147;
    uint256 public constant YELLOWGREEN = 148;
    uint256 public constant MULTICOLOUR = 149;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function initialize() initializer public {
        __ERC1155_init("tobeconfirmed.eth");
        __AccessControl_init();
        __Pausable_init();
        __ERC1155Burnable_init();
        __UUPSUpgradeable_init();

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(URI_SETTER_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
        _setupRole(UPGRADER_ROLE, msg.sender);
        
        // TODO 
        // on load where should we place the blocks? 0,0,0?

        // TODO: Mint X amount of tokens
        _mint(msg.sender, TRANSPARENT, 1, ""); // 10 times as many transparent as whole.
        _mint(msg.sender, ALICEBLUE, 1, "");
        _mint(msg.sender, ANTIQUEWHITE, 1, "");
        _mint(msg.sender, AQUA, 1, "");
        _mint(msg.sender, AQUAMARINE, 1, "");
        _mint(msg.sender, AZURE, 1, "");
        _mint(msg.sender, BEIGE, 1, "");
        _mint(msg.sender, BISQUE, 1, "");
        _mint(msg.sender, BLACK, 1, "");
        _mint(msg.sender, BLANCHEDALMOND, 1, "");
        _mint(msg.sender, BLUE, 1, "");
        _mint(msg.sender, BLUEVIOLET, 1, "");
        _mint(msg.sender, BROWN, 1, "");
        _mint(msg.sender, BURLYWOOD, 1, "");
        _mint(msg.sender, CADETBLUE, 1, "");
        _mint(msg.sender, CHARTREUSE, 1, "");
        _mint(msg.sender, CHOCOLATE, 1, "");
        _mint(msg.sender, CORAL, 1, "");
        _mint(msg.sender, CORNFLOWERBLUE, 1, "");
        _mint(msg.sender, CORNSILK, 1, "");
        _mint(msg.sender, CRIMSON, 1, "");
        _mint(msg.sender, CYAN, 1, "");
        _mint(msg.sender, DARKBLUE, 1, "");
        _mint(msg.sender, DARKCYAN, 1, "");
        _mint(msg.sender, DARKGOLDENROD, 1, "");
        _mint(msg.sender, DARKGRAY, 1, "");
        _mint(msg.sender, DARKGREY, 1, "");
        _mint(msg.sender, DARKGREEN, 1, "");
        _mint(msg.sender, DARKKHAKI, 1, "");
        _mint(msg.sender, DARKMAGENTA, 1, "");
        _mint(msg.sender, DARKOLIVEGREEN, 1, "");
        _mint(msg.sender, DARKORANGE, 1, "");
        _mint(msg.sender, DARKORCHID, 1, "");
        _mint(msg.sender, DARKRED, 1, "");
        _mint(msg.sender, DARKSALMON, 1, "");
        _mint(msg.sender, DARKSEAGREEN, 1, "");
        _mint(msg.sender, DARKSLATEBLUE, 1, "");
        _mint(msg.sender, DARKSLATEGRAY, 1, "");
        _mint(msg.sender, DARKSLATEGREY, 1, "");
        _mint(msg.sender, DARKTURQUOISE, 1, "");
        _mint(msg.sender, DARKVIOLET, 1, "");
        _mint(msg.sender, DEEPPINK, 1, "");
        _mint(msg.sender, DEEPSKYBLUE, 1, "");
        _mint(msg.sender, DIMGRAY, 1, "");
        _mint(msg.sender, DIMGREY, 1, "");
        _mint(msg.sender, DODGERBLUE, 1, "");
        _mint(msg.sender, FIREBRICK, 1, "");
        _mint(msg.sender, FLORALWHITE, 1, "");
        _mint(msg.sender, FORESTGREEN, 1, "");
        _mint(msg.sender, FUCHSIA, 1, "");
        _mint(msg.sender, GAINSBORO, 1, "");
        _mint(msg.sender, GHOSTWHITE, 1, "");
        _mint(msg.sender, GOLD, 1, "");
        _mint(msg.sender, GOLDENROD, 1, "");
        _mint(msg.sender, GRAY, 1, "");
        _mint(msg.sender, GREY, 1, "");
        _mint(msg.sender, GREEN, 1, "");
        _mint(msg.sender, GREENYELLOW, 1, "");
        _mint(msg.sender, HONEYDEW, 1, "");
        _mint(msg.sender, HOTPINK, 1, "");
        _mint(msg.sender, INDIANRED, 1, "");
        _mint(msg.sender, INDIGO, 1, "");
        _mint(msg.sender, IVORY, 1, "");
        _mint(msg.sender, KHAKI, 1, "");
        _mint(msg.sender, LAVENDER, 1, "");
        _mint(msg.sender, LAVENDERBLUSH, 1, "");
        _mint(msg.sender, LAWNGREEN, 1, "");
        _mint(msg.sender, LEMONCHIFFON, 1, "");
        _mint(msg.sender, LIGHTBLUE, 1, "");
        _mint(msg.sender, LIGHTCORAL, 1, "");
        _mint(msg.sender, LIGHTCYAN, 1, "");
        _mint(msg.sender, LIGHTGOLDENRODYELLOW, 1, "");
        _mint(msg.sender, LIGHTGRAY, 1, "");
        _mint(msg.sender, LIGHTGREY, 1, "");
        _mint(msg.sender, LIGHTGREEN, 1, "");
        _mint(msg.sender, LIGHTPINK, 1, "");
        _mint(msg.sender, LIGHTSALMON, 1, "");
        _mint(msg.sender, LIGHTSEAGREEN, 1, "");
        _mint(msg.sender, LIGHTSKYBLUE, 1, "");
        _mint(msg.sender, LIGHTSLATEGRAY, 1, "");
        _mint(msg.sender, LIGHTSLATEGREY, 1, "");
        _mint(msg.sender, LIGHTSTEELBLUE, 1, "");
        _mint(msg.sender, LIGHTYELLOW, 1, "");
        _mint(msg.sender, LIME, 1, "");
        _mint(msg.sender, LIMEGREEN, 1, "");
        _mint(msg.sender, LINEN, 1, "");
        _mint(msg.sender, MAGENTA, 1, "");
        _mint(msg.sender, MAROON, 1, "");
        _mint(msg.sender, MEDIUMAQUAMARINE, 1, "");
        _mint(msg.sender, MEDIUMBLUE, 1, "");
        _mint(msg.sender, MEDIUMORCHID, 1, "");
        _mint(msg.sender, MEDIUMPURPLE, 1, "");
        _mint(msg.sender, MEDIUMSEAGREEN, 1, "");
        _mint(msg.sender, MEDIUMSLATEBLUE, 1, "");
        _mint(msg.sender, MEDIUMSPRINGGREEN, 1, "");
        _mint(msg.sender, MEDIUMTURQUOISE, 1, "");
        _mint(msg.sender, MEDIUMVIOLETRED, 1, "");
        _mint(msg.sender, MIDNIGHTBLUE, 1, "");
        _mint(msg.sender, MINTCREAM, 1, "");
        _mint(msg.sender, MISTYROSE, 1, "");
        _mint(msg.sender, MOCCASIN, 1, "");
        _mint(msg.sender, NAVAJOWHITE, 1, "");
        _mint(msg.sender, NAVY, 1, "");
        _mint(msg.sender, OLDLACE, 1, "");
        _mint(msg.sender, OLIVE, 1, "");
        _mint(msg.sender, OLIVEDRAB, 1, "");
        _mint(msg.sender, ORANGE, 1, "");
        _mint(msg.sender, ORANGERED, 1, "");
        _mint(msg.sender, ORCHID, 1, "");
        _mint(msg.sender, PALEGOLDENROD, 1, "");
        _mint(msg.sender, PALEGREEN, 1, "");
        _mint(msg.sender, PALETURQUOISE, 1, "");
        _mint(msg.sender, PALEVIOLETRED, 1, "");
        _mint(msg.sender, PAPAYAWHIP, 1, "");
        _mint(msg.sender, PEACHPUFF, 1, "");
        _mint(msg.sender, PERU, 1, "");
        _mint(msg.sender, PINK, 1, "");
        _mint(msg.sender, PLUM, 1, "");
        _mint(msg.sender, POWDERBLUE, 1, "");
        _mint(msg.sender, PURPLE, 1, "");
        _mint(msg.sender, REBECCAPURPLE, 1, "");
        _mint(msg.sender, RED, 1, "");
        _mint(msg.sender, ROSYBROWN, 1, "");
        _mint(msg.sender, ROYALBLUE, 1, "");
        _mint(msg.sender, SADDLEBROWN, 1, "");
        _mint(msg.sender, SALMON, 1, "");
        _mint(msg.sender, SANDYBROWN, 1, "");
        _mint(msg.sender, SEAGREEN, 1, "");
        _mint(msg.sender, SEASHELL, 1, "");
        _mint(msg.sender, SIENNA, 1, "");
        _mint(msg.sender, SILVER, 1, "");
        _mint(msg.sender, SKYBLUE, 1, "");
        _mint(msg.sender, SLATEBLUE, 1, "");
        _mint(msg.sender, SLATEGRAY, 1, "");
        _mint(msg.sender, SLATEGREY, 1, "");
        _mint(msg.sender, SNOW, 1, "");
        _mint(msg.sender, SPRINGGREEN, 1, "");
        _mint(msg.sender, STEELBLUE, 1, "");
        _mint(msg.sender, TAN, 1, "");
        _mint(msg.sender, TEAL, 1, "");
        _mint(msg.sender, THISTLE, 1, "");
        _mint(msg.sender, TOMATO, 1, "");
        _mint(msg.sender, TURQUOISE, 1, "");
        _mint(msg.sender, VIOLET, 1, "");
        _mint(msg.sender, WHEAT, 1, "");
        _mint(msg.sender, WHITE, 1, "");
        _mint(msg.sender, WHITESMOKE, 1, "");
        _mint(msg.sender, YELLOW, 1, "");
        _mint(msg.sender, YELLOWGREEN, 1, "");
        _mint(msg.sender, MULTICOLOUR, 1, "");
        
    }

    function setURI(string memory newuri) public onlyRole(URI_SETTER_ROLE) {
        _setURI(newuri);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyRole(MINTER_ROLE)
    {
        _mint(account, id, amount, data);
        // update
        _tokenIdCounter.increment();
    }
    
    // to read from tokens to create 3D visual
    // function getColour(uint index) external view returns(string memory) {
    //     return colours[index];
    // }

    function transferBatch(address _operator, address _from, address _to, uint256[] _ids, uint256[] _values)
        public
        onlyRole(MINTER_ROLE)
    {
        // transfer batch of blocks from A to B
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyRole(MINTER_ROLE)
    {
        _mintBatch(to, ids, amounts, data);
        // update
        _tokenIdCounter.increment();
    }

    event BlockUpdated(
        uint id,
        uint skin,
        int[] coords,
        string content
    );

    // player move blocks around
    // TODO decide if anyone can move any blocks around.
    // play nice
    // Others can lock those blocks? 
    function moveBlocks(uint256[] memory ids, int[] coords){
        // _ msg.sender = block owner
        // _ blocks are free in x,y, space
        // apply update
        // e.g. ids.forEach((block, index) => { block.coords = coords[index] });
        // Block memory _block = blocks[_id];
        // _block.coords = coords[index]
        // blocks[_id] = _block;
        // emit TaskCompleted(_id, _block.coords);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyRole(UPGRADER_ROLE)
        override
    {}

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155Upgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
