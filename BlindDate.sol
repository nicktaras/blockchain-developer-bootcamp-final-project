// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.2;

// import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20FlashMintUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
// import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

// /// @custom:security-contact security@example.com
// contract MyToken is Initializable, ERC20Upgradeable, PausableUpgradeable, AccessControlUpgradeable, ERC20FlashMintUpgradeable, UUPSUpgradeable {
//     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
//     bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
//     bytes32 seed;
//     /// @custom:oz-upgrades-unsafe-allow constructor
//     constructor() initializer {}
//     function initialize() initializer public {
//         __ERC20_init("BlindDate", "BLD");
//         __Pausable_init();
//         __AccessControl_init();
//         __ERC20FlashMint_init();
//         __UUPSUpgradeable_init();
//         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
//         _setupRole(PAUSER_ROLE, msg.sender);
//         _mint(msg.sender, 100000 * 10 ** decimals());
//         _setupRole(UPGRADER_ROLE, msg.sender);
//     }
//     / profiles
//     struct Profile {
//         bool active;
//         string name;
//         string image;
//         string ageRange;
//         string sex;
//         string location;
//         string preference;
//         string[] values;
//         uint16 number;
//         string[] dates;
//     }
//     // dates
//     struct Date {
//         bool pending;
//         bool closed;
//         Message[] messages;
//     }
//     struct Message {
//         string userAddress;
//         string message;
//     }
//     // disputes
//     struct Dispute {
//         string userAddress;
//         string reason;
//     }
//     // suitors or suitresses and all in between
//     struct SelectedMatch {
//         string[] datesAddress;
//     }
//     // 
//     mapping (address => bytes32) public commitments;
//     // keeps track of all the system users    
//     mapping (address => Profile[]) public Users;
//     // keeps track of all the dates
//     mapping (address => Date[]) public Dates;
//     // keeps track of all people invited to dates
//     mapping (address => SelectedMatch[]) public SelectedMatches;
//     // disputes
//     mapping (address => Dispute[]) public Disputes;
//     // reveal share data
//     // function reveal(uint rand) public {
//     //     bytes32 hash = createCommitment(msg.sender, rand);
//     //     require(hash == commitments[msg.sender]);
//     //     seed = keccak256(abi.encode(seed, rand));
//     //     // tickets.push(msg.sender);
//     //     Profile[msg.sender]
//     // }
//     // add new profile
//     function addProfile(
//         uint rand,
//         string memory name,
//         string memory image,
//         string memory ageRange,
//         string memory sex,
//         string memory location,
//         string memory preference,
//         string[] memory values,
//         string memory mobileNumber
//     ) external{
//         // ???
//         // bytes32 hash = createCommitment(msg.sender, rand);
//         // // require(hash == commitments[msg.sender]);
//         // seed = keccak256(abi.encode(seed, rand));
//         // // tickets.push(msg.sender);
//         // Profile[msg.sender]
//         // push date for requestor
//         Users[msg.sender].push(
//             Profile({
//             active: true,
//             name: name,
//             image: "", // IPFS
//             ageRange: ageRange,
//             sex: sex, 
//             location: location,
//             preference: preference,
//             values: values,
//             mobileNumber: mobileNumber,
//             dates: undefined
//         }));
//     }
//     // update profile
//     function updateProfile(
//         string memory name,
//         string memory image,
//         string memory ageRange,
//         string memory sex,
//         string memory location,
//         string memory preference,
//         string[] memory values,
//         string memory mobileNumber
//     ) external {
//       // push date for requestor
//       Users[msg.sender].push(
//         Profile({
//             active: Users[msg.sender].active,
//             name: name,
//             image: "", // IPFS
//             ageRange: ageRange,
//             sex: sex, 
//             location: location,
//             preference: preference,
//             values: values,
//             mobileNumber: mobileNumber,
//             dates: Users[msg.sender].dates
//         }
//       ));
//     }
//     // add new blind date
//     function addBlindDate(string calldata _date) external{
//       // create date
//       Dates[msg.sender].push(
//         Date({
//           pending: true,
//           closed: false,
//           messages: []
//         }
//       ));
//       // store the recipient (reference to date)
//       SelectedMatches[_date.address].push(
//         SelectedMatch({
//           datesAddress: true
//         }
//       ));
//     }
//     // get blind date by index
//     function getBlindDate(uint blindDateIndex) external view returns (Date memory){
//         Date storage date = Dates[msg.sender][blindDateIndex];
//         return date;
//     }
//     // send message
//     function sendMessage(uint blindDateIndex, Message memory message) public {
//         Dates[msg.sender][blindDateIndex].message.push(message);
//     }
//     // one blind date token TODO - work out the tokenomics.
//     // joiningFee $1 = dispute return to each person 30% / 3.
//     // 10% goes to platform (use to help protect users / raise awareness).
//     function joiningFee() public {
//        require(msg.value == 1);
//     }
//     // // createCommitment
//     // function createCommitment(address player, uint rand) public pure returns (bytes32) {
//     //     return keccak256(abi.encode(player, rand));
//     // }
//     // function drawWinner() public {
//     //     require(now > revealingCloses + 5 minutes);
//     //     require(winner == address(0));
//     //     winner = tickets[uint(seed) % tickets.length];
//     // }
//     // pause contract safety mechanism
//     function pause() public onlyRole(PAUSER_ROLE) {
//         _pause();
//     }
//     // unpause contract safety mechanism
//     function unpause() public onlyRole(PAUSER_ROLE) {
//         _unpause();
//     }
//     // safe token transfer
//     function _beforeTokenTransfer(address from, address to, uint256 amount)
//         internal
//         whenNotPaused
//         override
//     {
//         super._beforeTokenTransfer(from, to, amount);
//     }
//     // safe upgrade 
//     function _authorizeUpgrade(address newImplementation)
//         internal
//         onlyRole(UPGRADER_ROLE)
//         override
//     {}
// }

// MERGE With

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.3.3/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.3.3/security/Pausable.sol";
import "@openzeppelin/contracts@4.3.3/access/AccessControl.sol";
import "@openzeppelin/contracts@4.3.3/token/ERC20/extensions/ERC20FlashMint.sol";

// TODO EMIT Events: emit TaskCreated(taskCount, _content, false);
// NFT - Dating owner has to own NFT e.g. APEs, Punks.
// DATE An Ape...
// Where do they meet - give MetaVerse location e.g. Decentaland ferris wheel.

// emit
// require
// payment per transaction
// pay to reactivate contract (funds to disputors)
// 2 complaints will de-activate contract
// 

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
