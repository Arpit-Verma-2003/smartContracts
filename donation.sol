// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
contract Charity{
    struct Donation{
        address user;
        uint256 amount;
        bool isVerified;
    }
    mapping (address=>Donation) public donations;
    address public owner;
    uint256 public totalDonationAmount;

    event DonationMade(address indexed donor,uint256 amount);
    event DonationVerified(address indexed donor);
    constructor(){
        owner = msg.sender;
        totalDonationAmount = 0;
    }
    modifier onlyOwner(){
        require(msg.sender==owner,"Only owner of this contract can access this");
        _;
    }
    function makeDonation() public payable {
        require(msg.value>0,"Please donate more than 0");
        Donation memory donation = Donation(msg.sender,msg.value,false);
        donations[msg.sender] = donation;
        totalDonationAmount+= msg.value;
        emit DonationMade(msg.sender, msg.value);
    }
    function verifyDonation(address _donor) public onlyOwner {
        Donation storage donation = donations[_donor];
        require(donation.user!=address(0),"Donation not found");
        require(!donation.isVerified,"Donation already verified");
        donation.isVerified = true;
        emit DonationVerified(_donor);
    }
    function getDonation(address _donor) public view returns(uint256,bool){
        Donation memory donation = donations[_donor];
        return (donation.amount,donation.isVerified);
    } 
}