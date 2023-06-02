//SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20MetadataUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../ZoKrates/target/release/verifier.sol";

/// @title Bank Transfer Smart Contract
/// @author eludius18
/// @notice This Smart Contract allow to transfer tokens
contract zkERC20Loan is
    Initializable,
    OwnableUpgradeable,
    ReentrancyGuardUpgradeable,
    PausableUpgradeable,
    Verifier
{
    //============== CONSTRUCTOR ==============
    constructor() {
        _disableInitializers();
    }
    //============== INITIALIZE ==============

    function initialize(address erc20ContractAddress) initializer public {
        erc20Contract = IERC20MetadataUpgradeable(erc20ContractAddress);
        __Ownable_init();
        __Pausable_init();
    }

    //============== VARIABLES ==============

    IERC20MetadataUpgradeable private erc20Contract;

    //============== EVENTS ===============

    //============== FUNCTIONS ==============

        /// @notice Enter function to send ETH
    function zkLoan(
        Proof memory proof,
        uint256 value
    )public
        nonReentrant
        whenNotPaused
    {
        // Verify the proof using the verification keys and the inputs
        require(verifyTx(proof), "Doesn't meet the requirements");

        // Transfer the tokens from the contract to the token holder
        erc20Contract.transfer(msg.sender, value);
    }
}