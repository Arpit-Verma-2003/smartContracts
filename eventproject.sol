// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;
contract EventOrg{
    struct eventvar{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketcount;
        uint ticketremain;
    }

    mapping (uint=>eventvar) public events;
    mapping (address=>mapping(uint=>uint))public tickets;
    uint public nextId;
    function createEvent(string memory name , uint date, uint price , uint ticketcount) public{
        require(date>block.timestamp,"the date provided for the event have already passed");
        require(ticketcount>0,"you don't have enough tickets to organize this event");
        events[nextId] = eventvar(msg.sender , name, date , price , ticketcount , ticketcount);
        nextId++;
    }
    function buyTicket(uint id,uint quantity) external payable  {
        require(events[id].date!=0,"this event doesn't exist");
        require(block.timestamp<events[id].date,"event has already occurred");
        eventvar storage _event = events[id];
        require(msg.value==(_event.price*quantity),"you don't have enough ether");
        require(_event.ticketremain>=quantity,"not enough tickets left for the event");
        _event.ticketremain-=quantity;
        tickets[msg.sender][id]+=quantity;
    }

}