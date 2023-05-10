// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DrugTracker {

    struct Drug {

        string name;

        uint256 quantity;

        address owner;

        uint256 timestamp;

        string[] previousOwners;

    }

    mapping (uint256 => Drug) public drugs;

    uint256 public drugCount = 0;

    event DrugAdded(uint256 drugId, string name, uint256 quantity, address owner, uint256 timestamp);

    event DrugOwnershipChanged(uint256 drugId, address previousOwner, address newOwner, uint256 timestamp);

    function addDrug(string memory _name, uint256 _quantity) public {

        drugCount++;

        drugs[drugCount] = Drug(_name, _quantity, msg.sender, block.timestamp, new string[](0));

        emit DrugAdded(drugCount, _name, _quantity, msg.sender, block.timestamp);

    }

    function transferDrugOwnership(uint256 _drugId, address _newOwner) public {

        require(drugs[_drugId].owner == msg.sender, "Only the current owner can transfer the ownership of the drug.");

        drugs[_drugId].previousOwners.push(getOwner(_drugId));

        drugs[_drugId].owner = _newOwner;

        drugs[_drugId].timestamp = block.timestamp;

        emit DrugOwnershipChanged(_drugId, msg.sender, _newOwner, block.timestamp);

    }

    function getDrugDetails(uint256 _drugId) public view returns(string memory name, uint256 quantity, address owner, uint256 timestamp, string[] memory previousOwners) {

        Drug memory drug = drugs[_drugId];

        return (drug.name, drug.quantity, drug.owner, drug.timestamp, drug.previousOwners);

    }

    function getOwner(uint256 _drugId) internal view returns(string memory) {

        Drug memory drug = drugs[_drugId];

        string memory ownerAddress = toAsciiString(drug.owner);

        string memory ownership = string(abi.encodePacked(ownerAddress, "_", uint2str(drug.timestamp)));

        return ownership;

    }

    function toAsciiString(address x) public pure returns (string memory) {

        bytes memory s = new bytes(40);

        for (uint i = 0; i < 20; i++) {

            bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));

            bytes1 hi = bytes1(uint8(b) / 16);

            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));

            s[2*i] = char(hi);

            s[2*i+1] = char(lo);

        }

        return string(s);

    }

    function char(bytes1 b) public pure returns (bytes1 c) {

        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);

        else return bytes1(uint8(b) + 0x57);

    }

    function uint2str(uint _i) internal pure returns (string memory str) {

        if (_i == 0) {

            return "0";

        }

        uint j = _i;

        uint length;

        while (j != 0) {

            length++;

            j /= 10;

        }

        bytes memory bstr = new bytes(length);

        uint k = length;

        while (_i != 0) {

            k = k-1;

            uint8 temp = uint8(48 + uint8(_i - _i / 10 * 10));

            bytes1 b1

