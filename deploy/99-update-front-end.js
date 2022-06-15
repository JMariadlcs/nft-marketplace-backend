/* This Script is used to deploy update frontend contract addresses and ABI
    - LOCALLY:
        Deploy all scripts: 'yarn hardhat deploy'
        Deploy ONLY this script: 'yarn hardhat deploy --tags frontend --network localhost'
    - TESTNET
        Deploy all scripts: 'yarn hardhat deploy --network rinkeby --tags frontend'
        Deploy ONLY this script: 'yarn hardhat deploy --network rinkeby --tags frontend'
*/

const { frontEndContractsFile, frontEndAbiFile } = require("../helper-hardhat-config")
const fs = require("fs")
const { network, ethers } = require("hardhat")

module.exports = async () => {
    if (process.env.UPDATE_FRONT_END) {
        console.log("Writing to front end...")
        await updateAbi()
        await updateContractAddresses()
        console.log("Front end written!")
    }
}

async function updateAbi() {
    const nftMarketplace = await ethers.getContract("NftMarketplace")
    fs.writeFileSync(`${frontEndAbiFile}NftMarketplace.json`, nftMarketplace.interface.format(ethers.utils.FormatTypes.json))

    const basicNft = await ethers.getContract("BasicNft")
    fs.writeFileSync(`${frontEndAbiFile}BasicNft.json`, basicNft.interface.format(ethers.utils.FormatTypes.json))
}

async function updateContractAddresses() {
    const nftMarketplace = await ethers.getContract("NftMarketplace")
    const contractAddresses = JSON.parse(fs.readFileSync(frontEndContractsFile, "utf8"))
    if (network.config.chainId.toString() in contractAddresses) {
        if (!contractAddresses[network.config.chainId.toString()]["NftMarketplace"].includes(nftMarketplace.address)) {
            contractAddresses[network.config.chainId.toString()]["NftMarketplace"].push(nftMarketplace.address)
        }
    } else {
        contractAddresses[network.config.chainId.toString()] = { NftMarketplace: [nftMarketplace.address] }
    }
    fs.writeFileSync(frontEndContractsFile, JSON.stringify(contractAddresses))
}
module.exports.tags = ["all", "frontend"]