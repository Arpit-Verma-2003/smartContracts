// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 < 0.9.0;
contract bank{
    struct account{
        address owner;
        uint amount;
        uint timecreated;
    }
    mapping (address=>account) public member;
    event balanceadd(address owner , uint256 balance,uint256 timestamp);
    event balancemin(address owner , uint256 balance,uint256 timestamp);
    modifier minimum(){
        require(msg.value>=1 ether,"you need atleast 1 ether to deposit");
        _;
    }
    function accountcreate() public payable minimum {
        member[msg.sender].owner = msg.sender;
        member[msg.sender].amount = msg.value;
        member[msg.sender].timecreated = block.timestamp;
        emit balanceadd(msg.sender, msg.value, block.timestamp);
    }
    function depositmoney() public payable {
        require(member[msg.sender].amount>= 1 ether , "you first need to create your bank acc to deposit money");
        member[msg.sender].amount+=msg.value;
        emit balanceadd(msg.sender, msg.value, block.timestamp);
    }
    function withdrawalmoney(uint256 value) public payable {
        // to transfer money to a address(owner)
        require(member[msg.sender].amount>= 1 ether , "you first need to create your bank acc to withdraw money");
        require(value<=member[msg.sender].amount,"not sufficient balance you are asking for");
        payable(msg.sender).transfer(value);
        member[msg.sender].amount -= msg.value;
        emit balancemin(msg.sender , msg.value, block.timestamp);
    }
}