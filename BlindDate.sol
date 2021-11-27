// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.3.3/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.3.3/security/Pausable.sol";
import "@openzeppelin/contracts@4.3.3/access/AccessControl.sol";
import "@openzeppelin/contracts@4.3.3/token/ERC20/extensions/ERC20FlashMint.sol";

/// @custom:security-contact security@example.com
contract BlindDate is ERC20, Pausable, AccessControl, ERC20FlashMint {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    constructor() ERC20("BlindDate", "BDAT") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
        _mint(msg.sender, 100000 * 10 ** decimals());
    }
    
    enum DateStages { // confirm states }
    
    enum SexAndPreference { // add options }
    
    struct Profile { // add details; alias name, number (to reveal later), location, NFT photo... }
    
    uint dateIdCounter = 0; // assign mapping number to dates stored
    
    struct Date { // date info, id, who is on the date, messages.. }
    
    mapping (address => Profile) public Profiles; // keep track of all the system users
    
    mapping (uint => Date) public Dates; // keeps track of all the dates
    
    function addProfile() external{
        // Require (check is profile exists)
        // Require(dates values length === 5) // this will be used to find potential dates + location? + values and age ranges.
        Profiles[msg.sender] = Profile({ // add dating profile });
    }
    
    function updateProfile() external {
      // Require(dates values length === 5) // this will be used to find potential dates + location? + values and age ranges.
      // push date for requestor
      Profiles[msg.sender] = Profile({ // update profile data });
    }
    
    function addDate() external{
      // Require message max 140 chars
      // Create two date objects - one for each party.
      Dates[dateIdCounter] = Date({}); // dateA
      Dates[dateIdCounter] = Date({}); // dateB
      // increment dates
      dateIdCounter++;
    }
    function endDate() public {
        // end date 
    }
    function setDispute() public {
        // Require the date must have dated that address
        // add dispute count to other address += 1;
    }
    function getDate() view() {
        return date;
    }
    function getMessage() returns () {
        return (message, user);
    }
    function getMessages() public view returns () {
        // Require must be Date A or B
        // list of messages
        return (message, user);
    }
    function getProfile() view (){
        return profile;
    }
    function sendMessage() public {
        // require check that the msg.senders address is inside the Date[index].
        // require Date[blindDateIndex].state == DateStages.active;
        // send message
    }
    // one blind date token TODO - work out the tokenomics.
    // joiningFee $1 = dispute return to each person 30% / 3.
    // 10% goes to platform (use to help protect users / raise awareness).
    function joiningFee() public payable {
       require(msg.value == 1);
       // require payment in dating token
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}
