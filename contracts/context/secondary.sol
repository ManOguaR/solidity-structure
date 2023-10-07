// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";

/**
 * @dev A Secondary contract can only be used by its primary account (the one that created it).
 */
abstract contract Secondary is Context {
    address private _primary;

    /**
     * @dev Sets the primary account to the one that is creating the Secondary contract.
     */
    constructor () {
        address msgSender = _msgSender();
        _primary = msgSender;
    }

    /**
     * @dev Reverts if called from any account other than the primary.
     */
    modifier onlyPrimary() {
        require(_msgSender() == _primary, "Secondary: caller is not the primary account");
        _;
    }

    /**
     * @return the address of the primary.
     */
    function primary() public view returns (address) {
        return _primary;
    }
}