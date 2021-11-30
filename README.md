# blockchain-developer-bootcamp-final-project
blockchain-developer-bootcamp-final-project

BlindDate

An ERC20 Utility Smart Contract / Token. 

That enables people to meet on chain, converse and decide whether to date in real life, in the metaverse or continue looking for a match. 

## Setup (React, Truffle, Ganache)

- inside the root folder
- install dependancies `npm i`
- run react dapp `npm run start`
- open ganache app
- `truffle compile --network development` to build contracts (copy the output into /src/build/contracts)
- deploy smart contract inside local development env `truffle migrate --network development`
- when making contract changes run: `truffle compile` then `truffle migrate --reset --network development` (move root/contracts folder into REACT src/build/contracts each time)
- Once the Dapp is running, select create mock profile
- Change your wallet address and create another
- With 2 addresses, select 'date' which will create a date between the two addresses

## Tests

run `truffle test`
## Project Demo walk through

https://www.youtube.com/watch?v=WHeQudPyhjc&feature=youtu.be

Please answer the following questions. Does your project:

1. Follow this naming format: https://github.com/YOUR_GITHUB_USERNAME_HERE/blockchain-developer-bootcamp-final-project? YES

2. Contain a README.md file which describes the project, describes the directory structure, and where the frontend project can be accessed? And has your public Ethereum address if you'd like your certification as an NFT (optional)? YES

3. Contain smart contract(s) which:
--Are commented to the specs described by NatSpec Solidity documentation
--Use at least two design patterns from the "Smart Contracts" section
--Protect against two attack vectors from the "Smart Contracts" section with its the SWC number
--Inherits from at least one library or interface
--Can be easily compiled, migrated and tested? YES

4. Contain a Markdown file named design_pattern_decisions.md and avoiding_common_attacks.md? YES

5. Have at least five smart contract unit tests that pass? YES

6. Contain a `deployed_address.txt` file which contains the testnet address and network where your contract(s) have been deployed? YES/NO

7. Have a frontend interface built with a framework like React or HTML/CSS/JS that:
--Detects the presence of MetaMask
--Connects to the current account
--Displays information from your smart contract
--Allows a user to submit a transaction to update smart contract state
--Updates the frontend if the transaction is successful or not? YES

8. Hosted on Github Pages, Heroku, Netlify, Fleek, or some other free frontend service that gives users a public interface to your decentralized application? (That address should be in your README.md document) YES/NO

9. Have clear instructions for: 
1) Installing dependencies for your project 
2) Accessing orâ€”if your project needs a server (not required)â€”running your project
3) Running your smart contract unit tests and which port a local testnet should be running on. YES/NO

10. A screencast of you walking through your project? YES

Congratulations on finishing your final project!


