/*  This Script is used to Cancel a listing of a BasicNft on the marketplace
    and also move on 1 block on our local blockchain -> to confirm logs on Moralis server database for example.

    To execute script on local network
    1. `yarn hardhat node``
    2. `yarn hardhat run scripts/cancel-item.js --network localhost`
*/

const { ethers, network } = require("hardhat")
const { moveBlocks } = require("../utils/move-blocks")

const TOKEN_ID = 0 // You should update with the TOKEN_ID of the BasicNft you want to cancel

async function mintAndList() {
    const nftMarketplace = await ethers.getContract("NftMarketplace")
    const basicNft = await ethers.getContract("BasicNft")
    const tx = await nftMarketplace.cancelListing(basicNft.address, TOKEN_ID)
    await tx.wait(1)
    console.log("NFT Canceled!")
    if ((network.config.chainId = "31337")) {
        await moveBlocks(2, (sleepAmount = 1000))
    }
}

mintAndList()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })