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
error NftMarketPlace__AlreadyListed(address nftAddress, uint256 tokenId);

contract NftMarketPlace {

    /// @notice Types
    struct Listing {
        uint256 price;
        address seller;
    }

    /// @notice NFT variables
    // NFT Contract address -> NFT TokenID -> Listing
    mapping(address => mapping(uint256 => Listing)) private s_listings;

    /// @notice Events
    event ItemListed(address indexed seller, address indexed nftAddress, uint256 indexed tokenId, uint256 price);

    /// @notice Modifiers
    modifier notListed(address nftAddress, uint256 tokenId, address owner) {
        Listing memory listing = s_listings[nftAddress][tokenId];
        if (listing.price > 0) {
            revert NftMarketPlace__AlreadyListed(nftAddress, tokenId);
        }
        _;
    }

    //////////////////////
    //  Main Functions // 
    /////////////////////

    /**
    * @notice Function to list an NFT on sell
    * @dev
    * - Should check that NFT price is >= 0, if not -> revert
    * - Should check that contract address has approve on the NFT to be transfered, if not -> revert
    * - Update mapping
    * - Emit event
    */
    function listItem(address nftAddress, uint256 tokenId, uint256 price) external notListed(nftAddress, tokenId, msg.sender) {
        if (price <= 0) {
            revert NftMarketPlace__PriceMustBeAboveZero();
        }
        IERC721 nft = IERC721(nftAddress);
        if (nft.getApproved(tokenId) != address(this)){
            revert NftMarketPlace__NotApprovedForMarketPlace();
        }
        s_listings[nftAddress][tokenId] = Listing(price, msg.sender);
        emit ItemListed(msg.sender, nftAddress, tokenId, price);
    }

}