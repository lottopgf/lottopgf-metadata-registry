import { buildModule } from '@nomicfoundation/hardhat-ignition/modules'

export default buildModule('LooteryDeploymentHelper', (m) => ({
    deploymentHelper: m.contract('LooteryDeploymentHelper', [
        m.getParameter('looteryFactory'),
        m.getParameter('metadataRegistry'),
    ]),
}))
