// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { EIP712 } from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

import { AttestationRequestData, DelegatedAttestationRequest } from "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";
import { EIP712Signature, InvalidSignature } from "@ethereum-attestation-service/eas-contracts/contracts/Common.sol";

/**
 * @title EIP712 typed signatures verifier for EAS delegated attestations.
 */
abstract contract EIP712Verifier is EIP712 {
    // keccak256("Stamper(bytes32 schema,address receipent,uint64 expirationTime,bool revocable,bytes32 refUID,bytes data)");
    bytes32 private constant STAMPER_TYPEHASH = 0xe550f18a5cf4d2f542bd92105423c103c4c0e1f54285b912f74af9c6df371b89;

    /**
     * @dev Creates a new EIP712Verifier instance.
     *
     * @param version The current major version of the signing domain
     */
    constructor(string memory name, string memory version) EIP712(name, version) {
    }

    /**
     * @dev Verifies delegated attestation request.
     *
     * @param request The arguments of the delegated attestation request.
     */
    function _verifyAttest(DelegatedAttestationRequest memory request) view internal {
        AttestationRequestData memory data = request.data;
        EIP712Signature memory signature = request.signature;

        bytes32 digest = _hashTypedDataV4(
            keccak256(
                abi.encode(
                    STAMPER_TYPEHASH,
                    request.schema,
                    data.recipient,
                    data.expirationTime,
                    data.revocable,
                    data.refUID,
                    keccak256(data.data)
                )
            )
        );

        if (ECDSA.recover(digest, signature.v, signature.r, signature.s) != request.attester) {
            revert InvalidSignature();
        }
    }
}
