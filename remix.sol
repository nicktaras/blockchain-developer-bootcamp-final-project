// SPDX-License-Identifier: MIT
pragma solidity 0.8.2;

import "@openzeppelin/contracts-upgradeable@4.3.2/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable@4.3.2/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable@4.3.2/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable@4.3.2/token/ERC1155/extensions/ERC1155BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable@4.3.2/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable@4.3.2/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @custom:security-contact security@blockden.eth
contract Blockden is Initializable, ERC1155Upgradeable, AccessControlUpgradeable, PausableUpgradeable, ERC1155BurnableUpgradeable, UUPSUpgradeable {
    bytes32 public constant URI_SETTER_ROLE = keccak256("URI_SETTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    
    using Counters for Counters.Counter;
    
    // keep track of counter
    Counters.Counter private _tokenIdCounter;
    
    // user will be able to download a pack of these colour blocks - current HTML named Colours list 2021.
    uint256 public constant DARKMATTER = 0;
    uint256 public constant ALICEBLUE = 1;
    uint256 public constant ANTIQUEWHITE = 2;
    uint256 public constant AQUA = 3;
    uint256 public constant AQUAMARINE = 4;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function initialize() initializer public {
        __ERC1155_init("blockden.eth");
        __AccessControl_init();
        __Pausable_init();
        __ERC1155Burnable_init();
        __UUPSUpgradeable_init();

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(URI_SETTER_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
        _setupRole(UPGRADER_ROLE, msg.sender);
        
        // mint: 7,654,321 tokens.
        _mint(msg.sender, DARKMATTER, 1, ""); // More of these.
        _mint(msg.sender, ALICEBLUE, 1, "");
        _mint(msg.sender, ANTIQUEWHITE, 1, "");
        _mint(msg.sender, AQUA, 1, "");
        _mint(msg.sender, AQUAMARINE, 1, "");
        
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
        // onlyRole(MINTER_ROLE)
    {
        _mint(account, id, amount, data);
        // update
        _tokenIdCounter.increment();
    }
    
    // to read from tokens to create 3D visual
    // function getColour(uint index) external view returns(string memory) {
    //     return colours[index];
    // }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyRole(MINTER_ROLE)
    {
        _mintBatch(to, ids, amounts, data);
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
