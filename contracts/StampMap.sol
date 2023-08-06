// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IStampMap } from "./interfaces/IStampMap.sol";

contract StampMap is IStampMap {
    mapping(address owner => mapping(bytes32 uid => string uri)) private _db;

    function register(string calldata uri) external returns (bytes32) {
        require(bytes(uri).length > 0, "No uri!");

        bytes32 uid;
        uint32 bump = 0;
        while (true) {
            uid = keccak256(
                abi.encodePacked(
                    uri,
                    msg.sender,
                    bump
                )
            );

            if (bytes(_db[msg.sender][uid]).length == 0) {
                break;
            }

            unchecked {
                ++bump;
            }
        }

        _db[msg.sender][uid] = uri;
        emit Registered(msg.sender, uid, uri);
        return uid;
    }

    function getStamp(address owner, bytes32 uid) external view returns (string memory) {
        return  _db[owner][uid];
    }

    function remove(bytes32 uid) external {
        require(bytes(_db[msg.sender][uid]).length > 0, "There is no stamp!");
        _db[msg.sender][uid] = "";
        emit Removed(msg.sender, uid);
    }
}