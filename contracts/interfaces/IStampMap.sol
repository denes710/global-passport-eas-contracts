// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/// @title Minimal StampMap interface for global passport
interface IStampMap {
    /// @notice Returns the stamp uri of a place
    /// @param owner The account of the place owner
    /// @param uid The unique identifier of the place
    /// @return The corresponding stamp to the owner and id
    function getStamp(address owner, bytes32 uid) external view returns (string memory);

    /// TODO
    function register(string calldata uri) external returns (bytes32);

    function remove(bytes32 uid) external;

    /// TODO
    event Registered(address indexed owner, bytes32 uid, string uri);

    /// TODO
    event Removed(address indexed owner, bytes32 uid);
}