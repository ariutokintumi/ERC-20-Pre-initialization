# ERC-20 Pre-initialization Extension

**Author:** German Maria Abal Bazzano  
**Contact:** [@ariutokintumi on X](https://x.com/ariutokintumi) | [@llamame on Telegram](https://t.me/llamame)  
**Live Conceptual Calculator:** [erc-20-pre-initialization.tiiny.site](https://erc-20-pre-initialization.tiiny.site/)  
**Discussion:** [Ethereum Magicians Post](https://ethereum-magicians.org/t/erc-tbd-erc-20-pre-initialization-extension-sentinel-storage-gas-savings-for-first-time-token-receivers/24993)

---

## Overview

This repository presents a new ERC-20 extension and complete reference implementation for **gas-optimized pre-initialization of ERC-20 balances** using a “sentinel value” technique.  
The problem: On Ethereum, the *first* storage write for a new address in an ERC-20 (`mapping(address => uint256)`) adds ~20,000 gas cost, making first-time buys expensive in gas spikes.

**This ERC-20 extension proposes an optional function to pre-initialize addresses using a special sentinel value in a `bytes32` mapping, so users can pay the storage cost in advance (when gas is low).  
All ERC-20 interfaces remain fully compatible and balances work as normal.  
For full details, see the [ERC draft](erc/erc20-preinit-erc.md).**


---

## The Sentinel (Magic Value) Solution
- Balances are stored as `mapping(address => bytes32)`.
- The new function `preInitializeAddress(address user)` writes a contract-wide unique “magic” value to pre-initialize the slot (only if not already set).
- All normal ERC-20 reads and writes are interpreted as `uint256`. The sentinel is treated as zero for accounting, and is overwritten on first real token transfer or mint.
- This allows users or wallets to pay the high storage gas fee at a convenient time, and only pay extra ~5,000 gas cost for their later purchase, regardless of network congestion.

**Test results** ([testing/test_results.txt](testing/test_results.txt)):  
- Pre-initialization: 44,221 gas (this is expected to done executed under low gas price circumstances)
- First transfer to non-initialized: 52,146 gas
- Transfer to pre-initialized: 35,050 gas
- *Savings can be >30% ETH depending on gasPrice spike conditions.*


---

## Quick Start

### 🔎 Try the Calculator Online

Estimate savings for any gas price scenario with the [conceptual live calculator](https://erc-20-pre-initialization.tiiny.site/) or run [ERC-20 Pre-initialization ETH Savings Calculator.html](tooling/ERC-20%20Pre-initialization%20ETH%20Savings%20Calculator.html) locally.

Note: The conceptual calculator reflect the complete transaction cost, considering the mapping costs section of the ([testing transactions](testing/test_results.txt)).


---

## Folder Structure


```plaintext
contracts/
    ERC20PreinitExample.abi            # ABI for testing/scripts
    ERC20PreinitExample.sol            # Reference Solidity contract

eip-for-ethereum/
    eip-erc20-preinit-sentinel-storage.md # ERC-20 extension draft to PR in ethereum/EIPs repo

erc/
    erc20-preinit-erc.md               # ERC-20 extension draft/specification
    rationale.md                       # Extended rationale, theory, and use cases

testing/
    test_results.txt                   # Real-world gas measurement results

tooling/
    ERC-20 Pre-initialization ETH Savings Calculator.html # Interactive savings conceptual calculator (HTML/CSS/JS)

.gitattributes                          # Ensures consistent line endings
LICENSE                                 # MIT License
README.md                               # You are here
```


---

## How to Use

- **Read the ERC-20 extension draft:** See [ERC-20 extension draft](erc/erc20-preinit-erc.md) and [ERC rationale](erc/rationale.md) for the full specification, motivation, and analysis.
- **Test the contract:** Deploy [ERC20PreinitExample.sol](contracts/ERC20PreinitExample.sol) on any EVM chain (since the contract is not audited yet, just use on testnet).
- **Check real-world gas savings:** See [Real Testing Gas Results](testing/test_results.txt) for gas profiles of transfers with and without pre-initialization.
- **Estimate ETH savings:** Try the [conceptual live calculator](https://erc-20-pre-initialization.tiiny.site/) or open the HTML file in [tooling](tooling/ERC-20%20Pre-initialization%20ETH%20Savings%20Calculator.html)).

---

## Why bytes32 and a sentinel value?
- Simply writing `0` does not reduce gas for future transfers. Only writing a unique nonzero value ("magic"/sentinel) in a `bytes32` mapping can safely pre-allocate storage for future updates.
- This trick is invisible to ERC-20 users and does not break compatibility with wallets or dApps.

See [rationale.md](erc/rationale.md) for a detailed explanation.

---

## Author

German Maria Abal Bazzano  
- [X: @ariutokintumi](https://x.com/ariutokintumi)
- [Telegram: @llamame](https://t.me/llamame)

---

## License

MIT

---

*For discussion, suggestions, or contributions, please reply in the [Ethereum Magicians Post](https://ethereum-magicians.org/t/erc-tbd-erc-20-pre-initialization-function-gas-savings-for-first-time-token-receivers/24993).
