import LooteryDeploymentHelper from '../ignition/modules/LooteryDeploymentHelper'
import LottoPGFMetadataRegistry from '../ignition/modules/LottoPGFMetadataRegistry'
import { ethers, ignition, run } from 'hardhat'
import { config } from './config'

async function main() {
    const chainId = await ethers.provider.getNetwork().then((network) => network.chainId)
    const { looteryFactory } = config[chainId.toString() as keyof typeof config]

    const { registry } = await ignition.deploy(LottoPGFMetadataRegistry)
    console.log(`LottoPGFMetadataRegistry deployed at: ${await registry.getAddress()}`)

    const { deploymentHelper } = await ignition.deploy(LooteryDeploymentHelper, {
        parameters: {
            LooteryDeploymentHelper: {
                looteryFactory,
                metadataRegistry: await registry.getAddress(),
            },
        },
    })
    console.log(`LooteryDeploymentHelper deployed at: ${await deploymentHelper.getAddress()}`)

    // Verify all
    await run(
        {
            scope: 'ignition',
            task: 'verify',
        },
        {
            // Not sure this is stable, but works for now
            deploymentId: `chain-${chainId.toString()}`,
        },
    )
}

main()
    .then(() => {
        console.log('Done')
        process.exit(0)
    })
    .catch((err) => {
        console.error(err)
        process.exit(1)
    })
