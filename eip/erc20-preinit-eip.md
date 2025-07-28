---
eip: 
title: ERC-20 Pre-initialization Function for Gas Savings
author: German Maria Abal Bazzano (@ariutokintumi)
discussions-to: https://github.com/ariutokintumi/ERC-20-Pre-initialization
type: Standards Track
status: Draft
category: ERC
status: Pre-Draft
created: 2025-07-17
updated: 2025-07-28
requires: ERC-20
---

# Simple Summary

This EIP introduces an **optional pre-initialization function** for ERC-20 tokens, leveraging a sentinel (magic) value and a `bytes32` storage mapping for balances. This mechanism allows users to pay the high SSTORE gas cost in advance (when gas is cheap), so that the later first real token transfer to that address costs far less gas during a potential upcoming network congestion.


# Abstract

Pre-initializing an ERC-20 token balance storage slot can save significant gas for users, but a simple approach (writing 0 to a `uint256` balance) does **not** actually reduce costs for the eventual first real transfer at all. This EIP proposes a safe, ERC-20-compatible method using `mapping(address => bytes32)` for balances and a unique sentinel value. The contract's ERC-20 interface remains 100% standard: all reads/writes are still performed as `uint256`. Only the internal pre-initialization function ever stores the sentinel value; all normal functions interpret it as zero, and any later transfer/mint simply overwrites it.

This allows users or integrators to "prepay" storage rent and optimize gas costs before high-demand launches, presales, and trending tokens. An easy way to understand for experienced developers is that this mirrors the principle of gas-shifting found in [ERC-721A](https://www.erc721a.org), but applied in reverse for ERC-20 storage.


# Motivation

In Ethereum, the **first write to a new storage slot** costs 20,000 gas (SSTORE from zero to nonzero). Pre-initializing by setting zero to the balance mapping does *not* help, since the cost is incurred only when a nonzero value is first written. By using a sentinel (magic) value in a `bytes32` mapping, contracts can explicitly allocate the storage slot for a given address, paying the high gas fee in advance, and later updating the slot with the real balance at only 5,000 gas.

This makes gas costs predictable and manageable for scenarios where a spike in network fees is likely at time of launch, claim, or trending event.


# Specification

ERC-20 contracts implementing this EIP **MUST**:
- Store balances as `mapping(address => bytes32)`.
- Provide a public/external function:
  ```solidity
  /// @notice Pre-initialize an address' balance slot with a sentinel value
  /// @param user The address to pre-initialize
  function preInitializeAddress(address user) external;
  ```

## Behavior:
- The function MUST store a unique, contract-wide constant sentinel value in the mapping if and only if the slot is currently empty.
- The ERC-20 interface (`balanceOf` , etc.) MUST interpret this sentinel value as zero for all logic and external views.
- Any subsequent mint/transfer to that address MUST overwrite the slot with the correct `uint256` value.
- No ERC-20 event emission or extra logic is required in `preInitializeAddress`.


# Use Cases
1. Presale Gas Optimization
Users can pre-initialize their address for a token before a high-traffic trading season (bull run), claim, or airdrop, when network gas is low, so they save gas later during the actual purchase or claim.
2. Strategic Pre-initialization Before Trends
Traders and power users can batch pre-initialize their addresses on trending or soon-to-launch tokens as a gas-saving strategy.
3. Power Users & dApps
Wallets, bots, and aggregators can offer “pre-initialize” functionality to users as a service, providing a competitive edge in congested markets.


# Justification: Why Use bytes32 + Sentinel?
- Writing zero to a slot does **not** save gas for the first real (nonzero) balance write. EVM only discounts overwrites of already-allocated slots with nonzero value.
- A nonzero, non-numeric “magic” value as a sentinel (e.g., `bytes32(keccak256("preinit"))`) can be easily recognized and replaced by the contract on the first real write.
- The contract logic ensures full ERC-20 compatibility: all reads/writes are interpreted as `uint256` externally; only the internal mapping uses `bytes32`.


# Backwards Compatibility

This function and pattern are optional and fully backward compatible: all ERC-20 views, transfers, and approvals remain unchanged in interface and behavior.


# Security Considerations

- No risk of funds loss: pre-initialization cannot set balances to nonzero token values or affect accounting.
- The sentinel is never visible or accessible externally. ERC-20 APIs always interpret it as zero.
- Minimal “storage bloat” risk; a slot with sentinel is no worse than a slot initialized via normal transfers.


# Reference Implementation

Check a testing example at [../contracts/ERC20PreinitExample.sol](../contracts/ERC20PreinitExample.sol). Don't use for production until a security audit is performed.


# Copyright

Copyright and license: MIT