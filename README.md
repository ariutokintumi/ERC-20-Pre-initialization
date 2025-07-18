# ERC-20 Pre-initialization EIP

**Author:** German Maria Abal Bazzano  
**Contact:** [@ariutokintumi on X](https://x.com/ariutokintumi) | [@llamame on Telegram](https://t.me/llamame)  
**Live Calculator:** [erc-20-pre-initialization.tiiny.site](https://erc-20-pre-initialization.tiiny.site/)

---

## Overview

This repository accompanies an EIP proposing an **optional pre-initialization function for ERC-20 tokens**, enabling users or operators to pay the storage (SSTORE) gas cost for specific addresses in advance, when network fees are low. This can dramatically reduce gas costs during periods of network congestion, improving onboarding and transfer efficiency for high-demand ERC-20 tokens.

- **EIP Proposal:** See [`/eip/`](./eip) folder for the draft and rationale.
- **Tooling & Analysis:** See [`/tooling/`](./tooling) for scripts and the interactive calculator.
- **Test Contracts:** See [`/test-contracts/`](./test-contracts) for Solidity implementations.

---

## Quick Start

### 🔎 Try the Calculator Online

Test ETH savings with the live web tool:  
👉 [erc-20-pre-initialization.tiiny.site](https://erc-20-pre-initialization.tiiny.site/)

---

## Folder Structure

ERC-20 Pre-initialization EIP/
├── README.md                        # Project overview, setup instructions, and table of contents
├── LICENSE                          # License information
├── .gitattributes                   # Attributes
├── eip/
│   ├── erc20-preinit-eip.md         # EIP draft
│   └── rationale.md                 # Optional: Extended rationale
├── tooling/
│   ├── ERC-20 Pre-initialization ETH Savings Calculator.html   # Interactive calculator (HTML/CSS/js)
│   ├── preinit.py                   # Python: Address initialization
│   └── gas_measurement.py           # Python: transfer gas measurement scripts
├── test-contracts/
│   └── ERC20PreinitExample.sol      # Solidity contract with pre-init logic



---

## How to Use

- **Review the EIP draft** in the `/eip/` folder for specification and rationale.
- **Use the calculator** ([live demo](https://erc-20-pre-initialization.tiiny.site/)) or run locally from `/tooling/`.
- **Run Python scripts** in `/tooling/` for gas measurement and batch actions (requires Python 3, web3.py, Infura, etc).
- **Deploy and test contracts** in `/test-contracts/` for benchmarking or integration.

---

## Author

German Maria Abal Bazzano  
- [X: @ariutokintumi](https://x.com/ariutokintumi)
- [Telegram: @llamame](https://t.me/llamame)
- [GitHub: ariutokintumi](https://github.com/ariutokintumi)

---

## License

MIT (unless otherwise specified in specific files).

---

*For discussion, suggestions, or contributions, please open an issue or contact the author above.*
