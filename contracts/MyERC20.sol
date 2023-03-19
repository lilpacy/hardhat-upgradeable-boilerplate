// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyERC20 is ERC20 {
    constructor(uint256 initialSupply, address to) ERC20("MyToken", "MTK") {
        _mint(to, initialSupply);
    }
}
