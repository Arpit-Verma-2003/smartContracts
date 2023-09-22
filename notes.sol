// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract notesDapp{
    struct Notes{
        string content;
        uint ID;
    }
    struct collectionNotes{
        Notes[] notes;
        address addr;
    }
    mapping (address=>collectionNotes) addrToCollection;
    function setNotes(string memory _content) public {
        uint counter = addrToCollection[msg.sender].notes.length;
        counter++;
        addrToCollection[msg.sender].notes.push(Notes(_content,counter));
    }
    function getNotes() view public returns (string[] memory) {
        uint counter = addrToCollection[msg.sender].notes.length;
        string[] memory allNotes = new string[](counter);
        for(uint i=0;i<counter;i++){
            allNotes[i] = addrToCollection[msg.sender].notes[i].content;
        }
        return allNotes;
    }
}