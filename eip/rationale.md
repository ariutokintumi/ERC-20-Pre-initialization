
---

## `eip/rationale.md` — Extended Rationale

```markdown
# Rationale: ERC-20 Pre-initialization Function

## Why This EIP?

Ethereum's storage cost model makes **first writes to new storage slots (SSTORE)** disproportionately expensive. In ERC-20, the first time a user's balance is updated, it typically costs 20,000 gas (vs. 5,000 for subsequent changes). In busy markets or hyped launches, this translates to high dollar fees, unpredictable UX, and sometimes failed transactions if users underestimate gas requirements.

This proposal addresses that with a simple, opt-in solution: **pay the "storage rent" early, when it is cheapest**.

## Detailed Use Cases

### 1. Presale Gas Hedging

In any presale, claim, or mint window, most participants are waiting for a specific time (e.g. launch block). If the contract supports pre-initialization, these users can pay the SSTORE cost at a quiet moment (e.g. the night before). When the sale opens and the mempool fills up, their first `transferFrom` or claim costs much less gas, letting them compete more fairly for limited slots and avoid sudden fee spikes.

### 2. Strategic Gas Saving on Trending Tokens

Hyped meme coins and protocol launches often see users "camp" gas prices. Savvy traders can pre-initialize the mapping slot for their wallet on likely targets. If they decide to buy (or snipe) when the token starts trending, the on-chain transaction uses much less gas—sometimes making the difference between a profitable or failed buy.

### 3. dApp/WALLET Automation

Wallets, bots, and relayers can offer users a "pre-initialize now" or "auto-gas optimize" button. Advanced users and power wallets may batch-initialize dozens of tokens they plan to interact with, saving cumulative fees.

## Why Not Just Use Transfer(0)?

While a transfer of 0 will also initialize the slot, this EIP makes the mechanism explicit, gas-efficient, and easy to track. It can also be further optimized (no event emission, no access checks).

## Broader Applicability

Any protocol or token that expects high onboarding activity, claim waves, or first-use spikes (e.g. airdrops, Layer 2 bridges, stablecoin minting) can benefit from this pattern.

## Future Extensions

This approach could be extended to other mappings (e.g. allowances, other standards) and generalized as a "storage rent prepay" tool.

## Risks and Limitations

- "Storage bloat" is theoretically possible if spammed, but already possible via normal transfers.
- Value for one-off users is limited, but large aggregators, bots, and pro users can benefit the most.
- The function must not allow setting non-zero balances.

## Conclusion

This proposal is a low-risk, backwards-compatible, and highly optional extension to ERC-20 that enables gas-conscious users and wallets to optimize costs during periods of unpredictable network congestion, with minimal contract changes and no loss of functionality or security.

---

Questions or feedback?  
See the [live calculator & theory](https://erc-20-pre-initialization.tiiny.site/) or open an issue.
