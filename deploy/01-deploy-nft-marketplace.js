/* This Script is used to deploy NftMarkeplace.sol contract:
    - LOCALLY:
        Deploy all scripts: 'yarn hardhat deploy'
        Deploy ONLY this script: 'yarn hardhat deploy --tags nftmarketplace'
    - TESTNET
        Deploy all scripts: 'yarn hardhat deploy --network rinkeby'
        Deploy ONLY this script: 'yarn hardhat deploy --network rinkeby --tags nftmarketplace'
*/

const { network } = require("hardhat")
const { developmentChains } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()

    log("----------------------------------------------------")
    const args = []
    const nftMarketplace = await deploy("NftMarketplace", {
        from: deployer,
        args: args,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    // Verify the deployment
    if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        log("Verifying...")
        await verify(nftMarketplace.address, args)
    }
    log("----------------------------------------------------")
}

module.exports.tags = ["all", "nftmarketplace"]