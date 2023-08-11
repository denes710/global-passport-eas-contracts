// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { AttestationRequest, DelegatedAttestationRequest } from "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";

interface IStamper {
    function stamp(DelegatedAttestationRequest calldata delegatedRequest) external payable returns (bytes32);
    function addStamp(AttestationRequest calldata request) external payable returns (bytes32);
}