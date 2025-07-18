---
eip: <to-be-assigned>
title: ERC-20: Pre-initialization Function for Gas Savings
author: German Maria Abal Bazzano (@ariutokintumi)
discussions-to: https://github.com/ariutokintumi/ERC-20-Pre-initialization
status: Draft
type: Standards Track
category: ERC
created: 2025-07-17
requires: ERC-20
---

# Simple Summary

Adds an **optional pre-initialization function** to ERC-20, allowing any address to pre-fill its token balance storage slot at a low gas price. This enables users to pay the SSTORE gas cost (20,000 gas) in advance—when gas is cheap—so that later transfers to that address incur a much lower gas cost (5,000) even during congestion.

# Abstract

This EIP extends ERC-20 with an optional `preInitializeAddress(address)` function. By calling this function, any address (user or operator) can ensure the storage slot for a token balance is initialized (set to zero), allowing subsequent balance changes to be much cheaper in high-gas scenarios. This mechanism is backward-compatible, safe, and particularly useful for high-demand launches, presales, and trending tokens.

# Motivation

Due to Ethereum’s gas cost model, writing to a new storage slot (`SSTORE` from "empty" to nonzero) costs 20,000 gas, while updating an existing slot costs only 5,000 gas. In popular ERC-20 tokens, new buyers often face high gas fees (especially during launches or market spikes) just to initialize their balance. By pre-initializing addresses during periods of low gas prices, users and protocols can optimize for cost and user experience.

# Specification

Add the following **optional function** to any ERC-20 contract:

```solidity
/// @notice Pre-initialize an address' balance storage slot to 0 if not set.
/// @param user The address to pre-initialize
function preInitializeAddress(address user) external;

## Behavior:

- The function MUST set balanceOf[user] = 0 if and only if the slot is not yet initialized.
- No value transfer or event emission is required.
- Any address may call this function for any address.

# Use Cases

1. Presale Gas Optimization
When a new token is about to launch (IDO, presale, airdrop claim, etc.), participants can pre-initialize their address at a time when gas prices are low. Later, when the sale opens (and gas fees spike), buying the token requires much less gas since the expensive storage write was already paid.

2. Strategic Pre-initialization Before Trends
If a user expects to buy a trending token (e.g., meme coin or hyped launch), they can pre-initialize their address for that token contract days or hours in advance, minimizing gas even if the network becomes congested at launch.

3. Power Users & dApps
Wallets, bots, or aggregators can provide an option to batch pre-initialize target addresses for popular tokens on behalf of users, as a value-added service.

# Backwards Compatibility

This function is optional and does not modify ERC-20's transfer, approve, or balance logic. Existing tokens remain fully compatible.

# Security Considerations

- No risk of funds loss: preInitializeAddress cannot modify nonzero balances or transfer tokens.
- Potential for "storage bloat" is minimal, as the function only sets a zero value and such behavior is possible already via a transfer(0) call.
- Best practice: contracts may wish to include a gas check or disable pre-initialization after a certain period.

# Reference Implementation

See [../test-contracts/ERC20PreinitExample.sol](https://github.com/ariutokintumi/ERC-20-Pre-initialization/blob/main/test-contracts/ERC20PreinitExample.sol).

# Copyright

Copyright and license: MIT