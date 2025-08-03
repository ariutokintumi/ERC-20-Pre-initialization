// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ERC20 with bytes32 balance storage and pre-initialization
/// @title ERC-20 with Pre-initialization (ERC draft) - Author: @ariutokintumi

contract ERC20PreinitBytes32 {
    string public name = "PreinitToken";
    string public symbol = "PINIT";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;

    // Store as bytes32 for magic value support
    mapping(address => bytes32) private _balanceBytes32;
    mapping(address => mapping(address => uint256)) public allowance;

    // Magic value (could be any rare pattern)
    bytes32 constant MAGIC = keccak256("preinit");

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Pre-initialize with magic value
    function preInitializeAddress(address user) external {
        if (_balanceBytes32[user] == bytes32(0)) {
            _balanceBytes32[user] = MAGIC;
        }
    }

    // Read ERC-20 compatible balance
    function balanceOf(address user) public view returns (uint256) {
        bytes32 val = _balanceBytes32[user];
        // If magic, treat as zero for external view
        if (val == MAGIC) return 0;
        return uint256(val);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        uint256 current = balanceOf(to);
        // Overwrite magic with actual value, or just add if already numeric
        _balanceBytes32[to] = bytes32(current + amount);
        totalSupply += amount;
        emit Transfer(address(0), to, amount);
    }

    function transfer(address to, uint256 value) external returns (bool) {
        uint256 senderBal = balanceOf(msg.sender);
        require(senderBal >= value, "Insufficient");
        unchecked {
            _balanceBytes32[msg.sender] = bytes32(senderBal - value);
            _balanceBytes32[to] = bytes32(balanceOf(to) + value);
        }
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        uint256 fromBal = balanceOf(from);
        require(fromBal >= value, "Insufficient");
        require(allowance[from][msg.sender] >= value, "Allowance");
        unchecked {
            _balanceBytes32[from] = bytes32(fromBal - value);
            _balanceBytes32[to] = bytes32(balanceOf(to) + value);
            allowance[from][msg.sender] -= value;
        }
        emit Transfer(from, to, value);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
