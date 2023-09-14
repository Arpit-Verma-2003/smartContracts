// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract onlineCertificate {
    address public owner;
    
    struct Certificate {
        address issuer;
        string certificateHash;
        bool isValid;
    }
    
    mapping(address => Certificate) public certificates;

    event CertificateIssued(address indexed recipient, address indexed issuer, string certificateHash);
    event CertificateRevoked(address indexed recipient, address indexed issuer);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    function issueCertificate(address recipient, string memory certificateHash) public onlyOwner {
        require(recipient != address(0), "Recipient address cannot be zero");
        require(certificates[recipient].issuer == address(0), "Certificate for recipient already exists");
        
        certificates[recipient] = Certificate(msg.sender, certificateHash, true);
        emit CertificateIssued(recipient, msg.sender, certificateHash);
    }
    
    function revokeCertificate(address recipient) public onlyOwner {
        require(recipient != address(0), "Recipient address cannot be zero");
        require(certificates[recipient].issuer != address(0), "Certificate for recipient does not exist");
        
        certificates[recipient].isValid = false;
        emit CertificateRevoked(recipient, certificates[recipient].issuer);
    }
    
    function verifyCertificate(address recipient) public view returns (bool) {
        return certificates[recipient].isValid;
    }
}
