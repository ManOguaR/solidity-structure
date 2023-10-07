// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {Context} from "@openzeppelin/contracts/utils/Context.sol";
import {RefundEscrow} from "@openzeppelin/contracts/utils/escrow/RefundEscrow.sol";

/**
 * @title RefundableCrowdsale
 * @dev Extension of `Context`contract that the possibility of users getting a refund.
 */
abstract contract RefundableContract is Context {
    // refund escrow used to hold funds
    RefundEscrow private _escrow;

    /**
     * @dev Constructor, creates RefundEscrow.
     */
    constructor (address payable inWallet) 
    {
        _escrow = new RefundEscrow(inWallet);
    }

    /**
     * @dev Investors can claim refunds here if crowdsale is unsuccessful.
     * @param refundee Whose refund will be claimed.
     */
    function _claimRefund(address payable refundee) internal {
        _escrow.withdraw(refundee);
    }

    function _closeAndWithdraw() internal {
        _escrow.close();
        _escrow.beneficiaryWithdraw();
    }

    function _enableRefunds() internal  {
        _escrow.enableRefunds();
    }

    function _depositInEscrow() internal {
        _escrow.deposit{value: msg.value}(_msgSender());
    }
}