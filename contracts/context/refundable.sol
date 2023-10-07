// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Context} from "@openzeppelin/contracts/utils/Context.sol";
import {RefundEscrow} from "../utils/escrow/refundEscrow.sol";

/**
 * @title RefundableCrowdsale
 * @dev Extension of `Context`contract that the possibility of users getting a refund.
 */
abstract contract Refundable is Context {
    // refund escrow used to hold funds
    RefundEscrow private _escrow;

    /**
     * @dev Constructor, creates RefundEscrow.
     */
    constructor (address payable inWallet) 
    {
        _escrow = new RefundEscrow(inWallet, address(this));
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