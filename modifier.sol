// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;
contract modi{
    address owner;
    constructor(){
        owner = msg.sender;
    }
    modifier ownerac(){
        require(msg.sender==owner,"you should be owner to access this");
        _;
    }
    function random() public view ownerac returns (uint){
        return 5;
    }
}