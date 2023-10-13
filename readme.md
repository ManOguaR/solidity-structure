# solidity-structure
Overloading of some OpenZeppelin contracts to add a ready-to use structural behaviors and interactions between contracts.

## why
Because the old OpenZeppelin 2.5.1 contracts are not compatible with the latest solidity
and I am in need of some contracts to create a crowdsale for a token... Then I ended up
upgrading it all and decided to share it with the world.

### known limitations
Very limited access control. You must implement your own access control for the crowdsale
if you want to use full OpenZeppelin 4.x.x access control features.

## how to use
Directly override the contract you want to use, functionallity is the same as the old
OpenZeppelin versioned contracts.

The contracts are:


	└-contracts
		|-abstractions
		|	|- finalizable.sol: extension where a contract can be finalized.
		|-context
		|	|- pausable.sol: extension where a contract can be paused.
		|	|- refundable.sol: extension where a transacton can be refunded by Escrow.
		|	└- secondary.sol: used as secondary Context. 
		|-math
		|	└- SafeMath.sol: old safe math library. 
		|-security
		|	└- reentrancyGuard.sol: extension that adds reentrancy guard modifier. 
		|-tokens
		|	|- burnable.sol: ERC20 burnable token utility with roles applied.
		|	└- mintable.sol: ERC20 mintable token utility with roles applied. 
		└-utils
		 	└- escrow
				|- conditionaEscrow.sol: conditional escrow abstraction.
				|- escrow.sol: escrow base contract.
		 		└- refunEscrow.sol: refund escrow.
		

And remember:
[@ManOguaR](https://www.github.com/ManOguaR) rules!