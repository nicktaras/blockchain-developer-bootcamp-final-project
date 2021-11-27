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
    enum DateStages {
        active,
        closed
    }
    enum SexAndPreference {
        m,
        f,
        b // both
    }
   // profiles
    struct Profile {
        bool active;
        string name;
        string ageRange;
        SexAndPreference sex;
        string location; // limit this e.g. 40 chars or change to country.
        SexAndPreference preference;
        string[] values;
        uint256 disputeCount;
        uint[] dates;
    }
    uint dateIdCounter = 0;
    // dates
    struct Date {
        uint id;
        DateStages state;
        string[] messagesList;
        address[] messagesListSender;
    }
    // keeps track of all the system users
    mapping (address => Profile) public Profiles;
    // keeps track of all the dates
    mapping (uint => Date) public Dates;
    // add new profile
    function addProfile(
        string memory name,
        string memory ageRange,
        SexAndPreference sex,
        string memory location,
        SexAndPreference preference,
        string[] memory values
    ) external{
        // Check is profile exists
        // TODO require: values length === 5 // max length of each value less than 10 chars.
        uint[] memory emptyDateList;
        Profiles[msg.sender] = Profile({
            active: true,
            name: name,
            ageRange: ageRange,
            sex: sex, 
            location: location,
            preference: preference,
            values: values,
            disputeCount: 0,
            dates: emptyDateList
        });
    }
    // update profile
    function updateProfile(
        string memory name,
        string memory ageRange,
        SexAndPreference sex,
        string memory location,
        SexAndPreference preference,
        string[] memory values
    ) external {
      // TODO require: values length === 5 // max length of each value less than 10 chars.
      // push date for requestor
      Profiles[msg.sender] = Profile({
            active: Profiles[msg.sender].active,
            name: name,
            ageRange: ageRange,
            sex: sex, 
            location: location,
            preference: preference,
            values: values,
            disputeCount: Profiles[msg.sender].disputeCount,
            dates: Profiles[msg.sender].dates
        });
    }
    // add new blind date
    function addDate(address datesAddress, string calldata message) external{
      // TODO Require message max 140 chars
      // Create two date objects - one for each party.
      // requestor
      string[] memory emptyStringList;
      address[] memory emptyAddressList;
      // add date
      Dates[dateIdCounter] = Date({
          id: dateIdCounter,
          state: DateStages.active,
          messagesList: emptyStringList,
          messagesListSender: emptyAddressList
        }
      );
      Dates[dateIdCounter].messagesList.push(message);
      Dates[dateIdCounter].messagesListSender.push(msg.sender);
      Profiles[msg.sender].dates.push(dateIdCounter);
      Profiles[datesAddress].dates.push(dateIdCounter);
      dateIdCounter++;
    }
    function endDate(uint dateIdCounterIndex) public {
        Dates[dateIdCounterIndex].state = DateStages.closed;
    }
    function setDispute(address userAddress) public {
        Profiles[userAddress].disputeCount++;
    }
    function getDate(uint dateIndex) external view returns (Date memory){
        Date memory date = Dates[dateIndex];
        return date;
    }
    function getMessage(uint dateIndex, uint messageIndex) external view returns (string memory, address) {
        string storage message = Dates[dateIndex].messagesList[messageIndex];
        address user = Dates[dateIndex].messagesListSender[messageIndex];
        return (message, user);
    }
    function getMessages(uint dateIndex) public view returns (string[] memory, address[] memory) {
        string[] storage message = Dates[dateIndex].messagesList;
        address[] storage user = Dates[dateIndex].messagesListSender;
        return (message, user);
    }
    function getProfile(address profileAddress) external view returns (Profile memory){
        Profile storage profile = Profiles[profileAddress];
        return profile;
    }
    function sendMessage(uint dateIndex, string memory message) public {
        // TODO reuqire check that the msg.senders address is inside the Date[index].
        // TODO require Date[blindDateIndex].state == DateStages.active;
        Dates[dateIndex].messagesList.push(message);
        Dates[dateIndex].messagesListSender.push(msg.sender);
    }
    // one blind date token TODO - work out the tokenomics.
    // joiningFee $1 = dispute return to each person 30% / 3.
    // 10% goes to platform (use to help protect users / raise awareness).
    function joiningFee() public payable {
       require(msg.value == 1);
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
