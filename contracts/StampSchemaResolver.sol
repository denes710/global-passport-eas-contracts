// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { SchemaResolver } from "@ethereum-attestation-service/eas-contracts/contracts/resolver/SchemaResolver.sol";

import { IEAS, Attestation } from "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";

import { IStampMap } from "./interfaces/IStampMap.sol";

contract StampSchemaResolver is SchemaResolver {
    // The global EAS contract.
    IStampMap internal immutable _stampMap;

    constructor(IEAS eas, IStampMap stampMap) SchemaResolver(eas) {
        _stampMap = stampMap;
    }

    // we should parse the data by using the schema
    function onAttest(Attestation calldata attestation, uint256 /*value*/) internal view override returns (bool) {
        require(attestation.data.length == 32, "");
        return bytes(_stampMap.getStamp(attestation.attester, bytes32(attestation.data))).length != 0;
    }

    function onRevoke(Attestation calldata /*attestation*/, uint256 /*value*/) internal pure override returns (bool) {
        return false; // we do not want to approve any revokes
    }
}