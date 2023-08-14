// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IStamper } from "./interfaces/IStamper.sol";

import { EIP712Verifier } from "./EIP712Verifier.sol";

import { IEAS, DelegatedAttestationRequest, AttestationRequest } from "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract Stamper is IStamper, Ownable, EIP712Verifier {
    // The global EAS contract.
    IEAS internal immutable _eas;

    bytes32 internal immutable _addSchemaId;
    bytes32 internal immutable _stampSchemaId;

    constructor(
        IEAS eas,
        string memory name,
        string memory version,
        bytes32 addSchemaId,
        bytes32 stampSchemaId
    ) Ownable() EIP712Verifier(name, version)  {
        _eas = eas;
        _addSchemaId = addSchemaId;
        _stampSchemaId = stampSchemaId;
    }

    function addStamp(AttestationRequest calldata request) external override payable onlyOwner returns (bytes32) {
        require(request.schema == _addSchemaId, "It is not the expected add schema!");
        return _eas.attest(request);
    }

    function stamp(DelegatedAttestationRequest calldata delegatedRequest) external override payable returns (bytes32) {
        require(delegatedRequest.schema == _stampSchemaId, "It is not the expected stamp schema!");
        require(delegatedRequest.attester == owner(), "The attester is not the owner!");
        _verifyAttest(delegatedRequest);

        return _eas.attest(AttestationRequest(_stampSchemaId, delegatedRequest.data));
    }
}