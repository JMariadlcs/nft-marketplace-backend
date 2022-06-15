/*  This Script is used to buy a BasicNft from the Marketplace 
    and also move on 1 block on our local blockchain -> to confirm logs on Moralis server database for example.

    To execute script on local network
    1. `yarn hardhat node``
    2. `yarn hardhat run scripts/buy-item.js --network localhost`
*/

const { ethers, network } = require("hardhat")
const { moveBlocks } = require("../utils/move-blocks")

const TOKEN_ID = 1

async function buyItem() {
    const nftMarketplace = await ethers.getContract("NftMarketplace")
    const basicNft = await ethers.getContract("BasicNft")
    const listing = await nftMarketplace.getListing(basicNft.address, TOKEN_ID)
    const price = listing.price.toString()
    const tx = await nftMarketplace.buyItem(basicNft.address, TOKEN_ID, { value: price })
    await tx.wait(1)
    console.log("NFT Bought!")
    if ((network.config.chainId = "31337")) {
        await moveBlocks(2, (sleepAmount = 1000))
    }
}

buyItem()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })