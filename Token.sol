// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AVtoken is ERC20 , ERC20Burnable , Ownable{
    uint public tokenPrice;
    uint public maxSupply;

    constructor() ERC20("AVtoken","AV"){
        tokenPrice = 2000000000000000;
        maxSupply = 1000000000000000000000;
    }

    function mint(uint amount) public payable{
        require(msg.value*10**decimals()/amount>= tokenPrice,"buy token according to its given price");
        _mint(msg.sender, amount);
    }

    function withdrawEther() public onlyOwner{
        payable (owner()).transfer(address(this).balance);
    }

    function returnState() public view returns(uint _myBalance , uint _maxSupply , uint _totalSupply , uint _tokenPrice){
        return(balanceOf(msg.sender),maxSupply,totalSupply(),tokenPrice);
    }
}