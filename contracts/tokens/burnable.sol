// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {Context} from "@openzeppelin/contracts/utils/Context.sol";

interface IBurnable {
    function burn(uint256 value) external returns (bool);
    function burnFrom(address account, uint256 value) external returns (bool);

    function assignBurnerRole(address assignedBurner) external;
    function revokeBurnerRole(address revokedBurner) external;
}

abstract contract ERC20Burnable is Context, ERC20, IBurnable, AccessControl {
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    event TokensBurnt(address indexed by, address indexed from, uint256 amount);

    constructor(address defaultAdmin, address burner)
    {
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _grantRole(BURNER_ROLE, burner);
    }

     /**
     * @dev Destroys a `value` amount of tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 value) public virtual onlyRole(BURNER_ROLE) returns (bool) {
        _burn(_msgSender(), value);
        emit TokensBurnt(_msgSender(), _msgSender(), value);
        return  true;
    }

    /**
     * @dev Destroys a `value` amount of tokens from `account`, deducting from
     * the caller's allowance.
     *
     * See {ERC20-_burn} and {ERC20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have allowance for ``accounts``'s tokens of at least
     * `value`.
     */
    function burnFrom(address account, uint256 value) public virtual onlyRole(BURNER_ROLE) returns (bool) {
        _spendAllowance(account, _msgSender(), value);
        _burn(account, value);
        emit TokensBurnt(_msgSender(), account, value);
        return  true;
    }

    function assignBurnerRole(address assignedBurner) public override onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(BURNER_ROLE, assignedBurner);
    }

    function revokeBurnerRole(address revokedBurner) public override onlyRole(DEFAULT_ADMIN_ROLE) {
        _revokeRole(BURNER_ROLE, revokedBurner);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IBurnable).interfaceId || super.supportsInterface(interfaceId);
    }
}