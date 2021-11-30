
## Design Patterns:

#### Inheritance and Interfaces (Importing and extending contracts and/or using contract interfaces) Inheritances and Interface

Implementation added:

Usage of OpenZeplin libraries.

#### Access Control Design Patterns (Restricting access to certain functions using things like Ownable, Role-based Control) Access Control Design Patterns

Implementation added:

- Applied External to all functions that are to be called externally.
- Applied Private to all functions that are to be called internally only.
- Applied Public to all functions that can be called internally or externally.

#### Optimizing Gas (Creating more efficient Solidity code) Optimizing Gas

Implementation added:

Usage of External rather than using Public to save gas. Solidity copies array arguments to memory, while external functions can read directly from calldata.

#### Use Modifiers Only for Validation

Implementation added:

Modifiers added to all functions. 

## Attack Vectors

#### SWC-131 - Presence of unused variables

Implementation added:

Removed all unused variables from the smart contract. 

#### SWC-129	- Typographical Error

Implementation added:

Correct usage of operators has been applied.

#### SWC-124 - Write to Arbitrary Storage Location 

Implementation added:

Upon creation of the smart contract, a variable 'owner' is used to store the creators/owners addreess.
This is used to ensure critical operations can not be used by anyone other than the owner. 

#### SWC-106 - Self Destruct

Remove self destruct function unless it is required.

#### SWC-100 - Function Default Visibility

- Applied External to all functions that are to be called externally.
- Applied Private to all functions that are to be called internally only.
- Applied Public to all functions that can be called internally or externally.
