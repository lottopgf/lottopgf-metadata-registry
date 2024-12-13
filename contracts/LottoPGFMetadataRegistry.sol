// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {ILottoPGFMetadataRegistry} from "./interfaces/ILottoPGFMetadataRegistry.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title LottoPGFMetadataRegistry
/// @notice Maps Lootery contract addresses to offchain metadata
contract LottoPGFMetadataRegistry is ILottoPGFMetadataRegistry {
    /// @notice Lootery contract address => metadata
    mapping(address => LooteryMetadata) public looteryMetadata;

    error NotLooteryOwner(address have, address want);

    function typeAndVersion() external pure returns (string memory) {
        return "LottoPGFMetadataRegistry 1.0.0";
    }

    /// @notice Set metadata for a Lootery contract. Only the owner of the
    ///     Lootery contract may set metadata. The metadata is assumed to be
    ///     valid.
    /// @param lootery Lootery contract address
    /// @param uri URI pointing to metadata
    function setLooteryMetadata(address lootery, string memory uri) external {
        address looteryOwner = Ownable(lootery).owner();
        if (msg.sender != looteryOwner) {
            revert NotLooteryOwner(msg.sender, looteryOwner);
        }
        looteryMetadata[lootery] = LooteryMetadata({
            lootery: lootery,
            uri: uri
        });
    }
}
