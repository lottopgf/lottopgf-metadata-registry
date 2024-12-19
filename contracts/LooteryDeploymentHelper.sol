// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {ITypeAndVersion} from "./interfaces/ITypeAndVersion.sol";
import {ILottoPGFMetadataRegistry} from "./interfaces/ILottoPGFMetadataRegistry.sol";
import {ILooteryFactory} from "./interfaces/ILooteryFactory.sol";
import {ILootery} from "./interfaces/ILootery.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title LooteryDeploymentHelper
/// @notice Maps Lootery contract addresses to offchain metadata
contract LooteryDeploymentHelper is ITypeAndVersion {
    struct DeployParams {
        string name;
        string symbol;
        uint8 pickLength;
        uint8 maxBallValue;
        uint256 gamePeriod;
        uint256 ticketPrice;
        uint256 communityFeeBps;
        address prizeToken;
        uint256 seedJackpotDelay;
        uint256 seedJackpotMinValue;
    }

    /// @notice LottoPGF v1 Factory
    address public immutable looteryFactory;
    /// @notice LottoPGF v1 Metadata Registry
    address public immutable metadataRegistry;

    constructor(address looteryFactory_, address metadataRegistry_) {
        ILooteryFactory(looteryFactory_).typeAndVersion();
        looteryFactory = looteryFactory_;
        metadataRegistry = metadataRegistry_;
    }

    /// @notice Pinned to LooteryFactory version
    function typeAndVersion() external pure returns (string memory) {
        return "LooteryDeploymentHelper 1.0.0";
    }

    function _deployLootery(
        DeployParams memory params
    ) internal returns (address) {
        return
            ILooteryFactory(looteryFactory).create(
                params.name,
                params.symbol,
                params.pickLength,
                params.maxBallValue,
                params.gamePeriod,
                params.ticketPrice,
                params.communityFeeBps,
                params.prizeToken,
                params.seedJackpotDelay,
                params.seedJackpotMinValue
            );
    }

    /// @notice Deploy a Lootery contract, with beneficiaries, and metadata
    /// @param params Lootery deployment parameters
    /// @param beneficiaries Beneficiaries. In case of duplicate addresses,
    ///     the last beneficiary with that address will be used.
    /// @param uri URI pointing to metadata
    /// @param activateApocalypseMode If true, apocalypse mode will be
    ///     activated immediately.
    function deployLooteryWithMetadata(
        DeployParams calldata params,
        ILottoPGFMetadataRegistry.Beneficiary[] calldata beneficiaries,
        string calldata uri,
        bool activateApocalypseMode
    ) external returns (address) {
        address looteryProxy = _deployLootery(params);

        for (uint256 i; i < beneficiaries.length; ++i) {
            ILootery(looteryProxy).setBeneficiary(
                beneficiaries[i].beneficiary,
                beneficiaries[i].name,
                true
            );
        }

        if (activateApocalypseMode) {
            ILootery(looteryProxy).kill();
        }

        ILottoPGFMetadataRegistry(metadataRegistry).setLooteryMetadata(
            looteryProxy,
            uri
        );

        // This contract is still the owner of the lootery - we need to
        // transfer ownership to the caller.
        Ownable(looteryProxy).transferOwnership(msg.sender);

        return looteryProxy;
    }
}
