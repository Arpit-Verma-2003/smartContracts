// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 < 0.9.0;
contract lottery{
    address public manager;
    address payable[] public participants;

    constructor(){
        manager = msg.sender; //global variable
    }
    receive() external payable{
        // require = ifelse
        require(msg.value==2 ether);
        participants.push(payable(msg.sender));
    } 
    function checkBalance() public view returns(uint){
        require(msg.sender==manager);
        return address(this).balance;
    }
    function rand() public view returns (uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,participants.length))); 
    }
    function selectWinner() public {
        require(msg.sender==manager);
        require(participants.length>=3);
        uint r = rand();
        uint index = r % participants.length;
        address payable winner;
        winner = participants[index];
        winner.transfer(checkBalance());
        participants = new address payable [](0);
    }
}