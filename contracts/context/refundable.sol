// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/escrow/RefundEscrow.sol";

/**
 * @title RefundableCrowdsale
 * @dev Extension of `FinalizableCrowdsale` contract that adds a funding goal, and the possibility of users
 * getting a refund if goal is not met.
 *
 * Deprecated, use `RefundablePostDeliveryCrowdsale` instead. Note that if you allow tokens to be traded before the goal
 * is met, then an attack is possible in which the attacker purchases tokens from the crowdsale and when they sees that
 * the goal is unlikely to be met, they sell their tokens (possibly at a discount). The attacker will be refunded when
 * the crowdsale is finalized, and the users that purchased from them will be left with worthless tokens.
 */
abstract contract RefundableContract is Context {
    using SafeMath for uint256;

    // minimum amount of funds to be raised in weis
    uint256 private _goal;

    // refund escrow used to hold funds while crowdsale is running
    RefundEscrow private _escrow;

    /**
     * @dev Constructor, creates RefundEscrow.
     * @param inGoal Funding goal
     */
    constructor (uint256 inGoal, address payable inWallet) 
    {
        require(inGoal > 0, "RefundableCrowdsale: goal is 0");
        _escrow = new RefundEscrow(inWallet);
        _goal = inGoal;
    }

    /**
     * @return minimum amount of funds to be raised in wei.
     */
    function goal() public view returns (uint256) {
        return _goal;
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