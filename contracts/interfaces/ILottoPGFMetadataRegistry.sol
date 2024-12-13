// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {ITypeAndVersion} from "./ITypeAndVersion.sol";

/// @title ILottoPGFMetadataRegistry
/// @notice Maps Lootery contract addresses to offchain metadata
interface ILottoPGFMetadataRegistry is ITypeAndVersion {
    struct Beneficiary {
        address beneficiary;
        string name;
    }

    struct LooteryMetadata {
        address lootery;
        string uri;
    }

    function setLooteryMetadata(address lootery, string memory uri) external;
}
