// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

interface ILootery {
    /// @notice Add or remove a beneficiary
    /// @param beneficiary Address to add/remove
    /// @param displayName Display name for the beneficiary
    /// @param isBeneficiary Whether to add or remove
    /// @return didMutate Whether the beneficiary was added/removed
    function setBeneficiary(
        address beneficiary,
        string calldata displayName,
        bool isBeneficiary
    ) external returns (bool didMutate);
}
