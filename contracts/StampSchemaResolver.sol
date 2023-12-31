// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { SchemaResolver } from "@ethereum-attestation-service/eas-contracts/contracts/resolver/SchemaResolver.sol";

import { IEAS, Attestation } from "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";

contract StampSchemaResolver is SchemaResolver {
    constructor(IEAS eas) SchemaResolver(eas) {
    }

    // we should parse the data by using the schema
    function onAttest(Attestation calldata attestation, uint256 /*value*/) internal view override returns (bool) {
        require(attestation.data.length == 0, "There is data!");
        require(attestation.recipient != address(0), "There is no receipent!");
        return _eas.getAttestation(attestation.refUID).attester == attestation.attester;
    }

    function onRevoke(Attestation calldata /*attestation*/, uint256 /*value*/) internal pure override returns (bool) {
        return false; // we do not want to approve any revokes
    }
}