import { buildModule } from '@nomicfoundation/hardhat-ignition/modules'

export default buildModule('LottoPGFMetadataRegistry', (m) => ({
    registry: m.contract('LottoPGFMetadataRegistry'),
}))
