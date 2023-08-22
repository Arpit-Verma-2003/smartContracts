// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/ERC20.sol";
contract token is ERC20{
    constructor() ERC20("ARPIT","VERMACOIN"){
        _mint(msg.sender, 100000 * 10**uint(100));
    }
}