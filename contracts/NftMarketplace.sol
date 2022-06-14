// SPX-License-Identifier: MIT

pragma solidity ^0.8.7;

/** 
1. Create a Decentralized MarketPlace ✅
    1. `listItem`: List NFTs on the Marketplace.
    2. `buyItem`: Buy NFTs directly on the Marketplace.
    3. `cancelItem`: Cancel item listing.
    4. `updateListing`: Update listing price.
    5. `withdrawProceeds`: Withdraw funds from sold NFTs.
*/

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

error NftMarketPlace__PriceMustBeAboveZero();
error NftMarketPlace__NotApprovedForMarketPlace();

contract NftMarketPlace {


    //////////////////////
    //  Main Functions // 
    /////////////////////

    /**
    * @notice Function to list an NFT on sell
    * @dev
    * - Should check that NFT price is >= 0, if not -> revert
    * - Should check that contract address has approve on the NFT to be transfered, if not -> revert
    */
    function listItem(address nftAddress, uint256 tokenId, uint256 price) external {
        if (price <= 0) {
            revert NftMarketPlace__PriceMustBeAboveZero();
        }
        IERC721 nft = IERC721(nftAddress);
        if (nft.getApproved(tokenId) != address(this)){
            revert NftMarketPlace__NotApprovedForMarketPlace();
        }
    }

}