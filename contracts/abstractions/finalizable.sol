// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Finalizable contract
 * @dev Contract abstraction with a one-off finalization action, where one
 * can do extra work after finishing.
 */
abstract contract Finalizable {
    bool private _finalized;

    event ContractFinalized();

    /**
     * @dev Constructor, sets _finalized to false.
     */
    constructor () {
        _finalized = false;
    }

    /**
     * @return true if the crowdsale is finalized, false otherwise.
     */
    function finalized() public view returns (bool) {
        return _finalized;
    }

    /**
     * @dev Must be called after crowdsale ends, to do some extra finalization
     * work. Calls the contract's finalization function wich returns a bool value
     * to set the state of the contract to finalized or not if finalization fails.
     */
    function finalize() public virtual  {
        require(!_finalized, "FinalizableCrowdsale: already finalized");
        _finalized = _finalization();
        if (_finalized) {
            emit ContractFinalized();
        }
    }

    /**
     * @dev Can be overridden to add finalization logic. The overriding function
     * should call super._finalization() to ensure the chain of finalization is
     * executed entirely.
     * @return true if the finalization succeeds.
     */
    function _finalization() virtual internal returns (bool) {
        return true;
    }
}