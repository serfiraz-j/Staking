// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StakeToken is ERC20 {
    constructor() ERC20("StakeToken", "ST") {
        _mint(msg.sender, 1000000000000000000 * 10 ** decimals());
    }
}

contract RewardToken is ERC20 {
    constructor() ERC20("RewardToken", "RT") {
        _mint(msg.sender, 1000000000000000000 * 10 ** decimals());
    }
}
