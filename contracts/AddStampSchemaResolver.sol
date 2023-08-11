// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { SchemaResolver } from "@ethereum-attestation-service/eas-contracts/contracts/resolver/SchemaResolver.sol";

import { IEAS, Attestation } from "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";

contract AddStampSchemaResolver is SchemaResolver {
    constructor(IEAS eas) SchemaResolver(eas) {
    }

    function onAttest(Attestation calldata attestation, uint256 /*value*/) internal pure override returns (bool) {
        require(attestation.data.length > 0, "There is no uri!");
        require(attestation.recipient == address(0), "There is recipient!");
        return true;
    }

    function onRevoke(Attestation calldata /*attestation*/, uint256 /*value*/) internal pure override returns (bool) {
        return false; // we do not want to approve any revokes
    }
}