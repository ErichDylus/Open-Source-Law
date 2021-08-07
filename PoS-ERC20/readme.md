The following is an arbitrary Proof-of-Stake ERC-20.

It takes a normal OpenZepplin ERC-20 and adds a few functions.

Users can mint a token and stake it using the `mintandstake()` function, which will create 1 token and automatically stake it in the contract.

The `mintandstake()` function can only be called if the user is not already staking.

The function `isStaked()` returns a true/false bool if the user is staking.

The function `stakedAmount()` returns a uint256 value of the users staking.

Users cannot unstake, and cannot stake an additional balance if they are already staked.

Using the `isStaked()` and `stakedAmount()` protocols can restrict access to their features, but, this initial `mintandstake()` only needs to be run once and so can be setup similar to a "use this transaction to activate your account" process. Not disimilar to the experience of a user using approve on an ERC20.

In the case of restricting access to a protocol based on this valueless, one time created, non-withdrawable token being staked, your protocol now requires proof that a user is staked in order to access the protocol.

You are now a proof-of-stake protocol.

Created by @adamscochran
