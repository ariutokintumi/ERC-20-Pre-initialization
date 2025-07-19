# Rationale: ERC-20 Pre-initialization Function with Sentinel Value

## Why This EIP?

Ethereum's storage model makes the **first write to any storage slot (SSTORE)** disproportionately expensive: 20,000 gas versus 5,000 gas for subsequent updates. In traditional ERC-20, pre-initializing a balance slot with zero does NOT actually save gas for the user's first real balance update; only a nonzero value allocates the slot. This EIP introduces a clean workaround: store a unique, non-numeric “magic” value in a bytes32 mapping to act as a sentinel, making the slot "allocated" and thus eligible for cheap update in the next transfer or mint.

**Key insight:**  
- You cannot “fake” a nonzero balance or use negative values (ERC-20 is uint256-only).
- Storing a sentinel value using `bytes32` allows the contract to “flag” the slot as pre-initialized without affecting the accounting logic or external ERC-20 compatibility.

This proposal addresses that with a simple, opt-in solution: **pay the "storage rent" early, when it is cheapest**.

## How It Works

- The contract’s balance mapping is changed to `mapping(address => bytes32)`.
- The pre-initialization function stores a constant sentinel value (e.g. `keccak256("preinit")`) in the mapping for any address, only if it’s currently zero.
- When `balanceOf()` is called, or when transfers/mints are performed, if the current value is the sentinel, the contract logic treats it as zero (no tokens).
- On the first real balance update, the sentinel is simply overwritten with the actual uint256 value. This update is now only ~5,000 gas.

**Result:**  
- Users (or wallets, or dApps) can pre-initialize their storage slot when gas is cheap.
- When network is busy, their first actual token buy/claim/mint/transfer costs ~17,000 less gas (by measurements done and available at [../testing/test_results.txt](../testing/test_results.txt)).


## Detailed Use Cases
1. **Presale Gas Hedging**
   - During a presale or major launch, participants can pre-initialize their slot the night before, at low gas prices. Their eventual claim or buy is then cheaper.
2. **Strategic Pre-initialization for Trending Tokens**
   - Savvy users can batch-initialize slots on tokens they may want to trade when hype spikes.
3. **Wallet/dApp Automation**
   - Wallets, bots, and advanced dApps can offer a “pre-initialize now” button or automatic service for users to optimize their on-chain costs.


## Why Not Use Other Approaches?
- **Transfer(0) or balance=0:** Does not allocate the slot; first nonzero write still costs 20,000 gas.
- **Dummy balance (e.g. 1 token):** Breaks accounting, is unsafe, and not compliant.
- **Negative or non-numeric:** Not possible in uint256, and not safe in mapping types.

**Sentinel bytes32 value** is the only way to safely allocate the storage slot with zero external effects.


## Broader Applicability

This mechanism could be generalized for any mapping that suffers high initial SSTORE costs (e.g. ERC-1155, allowances, etc).


## Risks and Limitations
- Slightly more complex contract logic (all reads must check for the sentinel).
- “Storage bloat” possible, but no worse than any other pre-initialization or airdrop.
- This approach is opt-in; only new contracts using this EIP can benefit.


## Conclusion

This EIP is a safe, optional, and backward-compatible method to enable **predictable gas costs** for first-time token holders, especially during high-demand events, while preserving ERC-20 compatibility and preventing any accounting “mess” for token projects.


---

Questions or feedback?  
See the [live calculator & theory](https://erc-20-pre-initialization.tiiny.site/) or open an issue.