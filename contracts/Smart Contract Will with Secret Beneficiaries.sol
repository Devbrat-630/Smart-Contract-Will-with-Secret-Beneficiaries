// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartContractWill {
    address public owner;
    bool public isDeceased;

    // Encrypted beneficiary data stored on-chain as bytes
    bytes public encryptedBeneficiaries;

    event WillUpdated(bytes encryptedData);
    event DeceasedDeclared();
    event InheritanceClaimed(address beneficiary, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyIfDeceased() {
        require(isDeceased, "Owner is not deceased yet");
        _;
    }

    constructor() {
        owner = msg.sender;
        isDeceased = false;
    }

    // Owner uploads encrypted beneficiaries info
    function updateWill(bytes calldata encryptedData) external onlyOwner {
        encryptedBeneficiaries = encryptedData;
        emit WillUpdated(encryptedData);
    }

    // Owner or trusted party declares death
    function declareDeceased() external onlyOwner {
        isDeceased = true;
        emit DeceasedDeclared();
    }

    // Owner funds the will contract with inheritance amount
    receive() external payable {}

    // Beneficiary claims their share by providing proof off-chain
    // (In practice, this function would be more complex with verification)
    function claimInheritance(address payable beneficiary, uint amount) external onlyIfDeceased {
        require(address(this).balance >= amount, "Insufficient funds");
        beneficiary.transfer(amount);
        emit InheritanceClaimed(beneficiary, amount);
    }

    function getEncryptedBeneficiaries() external view returns (bytes memory) {
        return encryptedBeneficiaries;
    }
}

