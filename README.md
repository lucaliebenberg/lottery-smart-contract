# Proveably Random Raffle Contract

1. Users can enter by paying for a ticket
    - The ticket fees will go to the winner during the draw
2. After X period of time, the lottery will automatically draw a winner
   - Implemented programatically
4. Using Chainlink VRF & Chainlink Automation
    - Chainlink VRF --> Randomness
    - Chainlink Automation --> Time based trigger


## Layout of Contract

```solidity

    // SPDX-License-Identifier: MIT

    // pragma solidity <version>

    // imports
    // errors
    // interfaces, libraries, contracts
    // Type declarations
    // State variables
    // Events
    // Modifiers
    // Functions

```

## Layout of Functions

```solidity
    // constructor
    // receive function (if exists)
    // fallback function (if exists)
    // external
    // public
    // internal
    // private
    // view & pure functions
```

## Important Acknowledgement.

```solidity
    function enjoy() payable external returns (HappyBlockchainDeveloper) {
        if (developer.notCurious) {
            revert Web3__GetThisDeveloperOutOfHere(); // LOL
        }
    }
```
