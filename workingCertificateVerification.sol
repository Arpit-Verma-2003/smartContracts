// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Certifyhub {
    struct Certificate {
        uint256 certificateId;
        string ipfsHash;
        address studentAddress;
        string certificateType;
        bool isValid;
        string issueDate;
    }

    mapping(string => Certificate) public certificates;
    mapping(address => string[]) public studentCertificates;
    mapping(address => bool) public issuers;

    address public owner;
    uint256 public certificateCounter;

    event CertificateIssued(uint256 certificateId, string ipfsHash, address studentAddress, string certificateType, string issueDate);
    event CertificateInvalidated(uint256 certificateId);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event IssuerAdded(address indexed issuer);

    constructor() {
        owner = msg.sender;
        certificateCounter = 0;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Caller is not the owner");
        _;
    }

    modifier onlyIssuer() {
        require(issuers[msg.sender] == true, "Caller is not an issuer");
        _;
    }

    modifier onlyStudent(address _studentAddress) {
        require(msg.sender == _studentAddress, "Caller is not the student");
        _;
    }

    function addIssuer(address _issuer) public onlyOwner {
        issuers[_issuer] = true;
        emit IssuerAdded(_issuer);
    }

    function issueCertificate(
        string memory _ipfsHash,
        address _studentAddress,
        string memory _certificateType,
        string memory _issueDate
    ) public onlyIssuer {
        certificateCounter++;
        Certificate memory newCertificate = Certificate({
            certificateId: certificateCounter,
            ipfsHash: _ipfsHash,
            studentAddress: _studentAddress,
            certificateType: _certificateType,
            isValid: true,
            issueDate: _issueDate
        });
        certificates[_ipfsHash] = newCertificate;
        studentCertificates[_studentAddress].push(_ipfsHash);
        emit CertificateIssued(certificateCounter, _ipfsHash, _studentAddress, _certificateType, _issueDate);
    }

    function validateCertificate(string memory _ipfsHash) public view returns (bool) {
        return certificates[_ipfsHash].isValid;
    }

    function invalidateCertificate(string memory _ipfsHash) public onlyOwner {
    Certificate storage certificate = certificates[_ipfsHash];
    require(certificate.isValid, "Certificate does not exist or is already invalid");
    
    certificate.isValid = false;
    emit CertificateInvalidated(certificate.certificateId);
}


    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
    
    function getCertificateData(string memory _ipfsHash) public view returns (
        uint256, string memory, address, string memory, bool, string memory
    ) {
        Certificate memory certificate = certificates[_ipfsHash];
        return (
            certificate.certificateId,
            certificate.ipfsHash,
            certificate.studentAddress,
            certificate.certificateType,
            certificate.isValid,
            certificate.issueDate
        );
    }

    function getStudentCertificates(address _studentAddress) public view onlyStudent(_studentAddress) returns (string[] memory) {
        return studentCertificates[_studentAddress];
    }
}