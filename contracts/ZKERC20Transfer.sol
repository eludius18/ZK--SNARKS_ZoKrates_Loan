//SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../ZoKrates/target/release/verifier.sol";

/// @title Bank Transfer Smart Contract
/// @author eludius18
/// @notice This Smart Contract allow to transfer tokens
contract zkERC20Transfer is
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
        erc20Contract = IERC20Upgradeable(erc20ContractAddress);
        __Ownable_init();
        __Pausable_init();
    }

    //============== VARIABLES ==============

    using SafeERC20Upgradeable for IERC20Upgradeable;
    IERC20Upgradeable private erc20Contract;

    //============== EVENTS ===============

    //============== FUNCTIONS ==============

        /// @notice Enter function to send ETH
    function zkTransfer(
        Proof memory proof,
        uint[2] memory input,
        address to,
        uint256 value
    )public
        nonReentrant
        whenNotPaused
    {
        // Verify the proof using the verification keys and the inputs
        require(verifyTx(proof, input), "Must be at least 18 years old");
        erc20Contract.safeTransfer(to, value);
    }
    
    function userTransferApproval(Proof memory proof, uint[2] memory input) public view returns (bool) 
    {
        return (verifyTx(proof, input));
    }

}