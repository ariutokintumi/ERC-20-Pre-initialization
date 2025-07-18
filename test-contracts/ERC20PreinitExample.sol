// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ERC-20 with Pre-initialization (EIP draft) - Author: @ariutokintumi
contract ERC20PreinitMock {
    string public name = "PreinitToken";
    string public symbol = "PINIT";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Pre-initialize an address' balance storage slot to 0 if not yet set (EIP function)
    /// @param user The address to pre-initialize
    function preInitializeAddress(address user) external {
        // Only write if not set (avoid extra SSTORE for already-initialized)
        if (balanceOf[user] == 0) {
            // This will cost 20,000 gas if user slot is empty, 5,000 if already set
            balanceOf[user] = 0;
        }
    }

    /// @notice Mint new tokens (for testing/demo). Only owner can mint.
    function mint(address to, uint256 amount) external onlyOwner {
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    function transfer(address to, uint256 value) external returns (bool) {
        require(balanceOf[msg.sender] >= value, "Insufficient");
        unchecked {
            balanceOf[msg.sender] -= value;
            balanceOf[to] += value;
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
        require(balanceOf[from] >= value, "Insufficient");
        require(allowance[from][msg.sender] >= value, "Allowance");
        unchecked {
            balanceOf[from] -= value;
            balanceOf[to] += value;
            allowance[from][msg.sender] -= value;
        }
        emit Transfer(from, to, value);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
