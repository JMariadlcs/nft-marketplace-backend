// SPDX-License-Identifier: MIT

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
error NftMarketPlace__NotOwner();
error NftMarketPlace__AlreadyListed(address nftAddress, uint256 tokenId);
error NftMarketPlace__NotListed(address nftAddress, uint256 tokenId);
error NftMarketPlace__PriceNotMet(address nftAddress, uint256 tokenId, uint256 price);


contract NftMarketPlace {

    /// @notice Types
    struct Listing {
        uint256 price;
        address seller;
    }

    /// @notice NFT variables
    // NFT Contract address -> NFT TokenID -> Listing
    mapping(address => mapping(uint256 => Listing)) private s_listings;
    // Seller address -> Earned amount by selling NFTs
    mapping(address => uint256) private s_proceeds;

    /// @notice Events
    event ItemListed(address indexed seller, address indexed nftAddress, uint256 indexed tokenId, uint256 price);

    /// @notice Modifiers
    modifier isOwner(address nftAddress, uint256 tokenId, address spender) {
        IERC721 nft = IERC721(nftAddress);
        address owner = nft.ownerOf(tokenId);
        if (spender != owner) {
            revert NftMarketPlace__NotOwner();
        }
        _;
    }
    
    modifier notListed(address nftAddress, uint256 tokenId, address owner) {
        Listing memory listing = s_listings[nftAddress][tokenId];
        if (listing.price > 0) {
            revert NftMarketPlace__AlreadyListed(nftAddress, tokenId);
        }
        _;
    }

    modifier isListed(address nftAddress, uint256 tokenId) {
        Listing memory listing = s_listings[nftAddress][tokenId];
        if (listing.price <= 0) {
            revert NftMarketPlace__NotListed(nftAddress, tokenId);
        }
        _;
    }

   

    //////////////////////
    //  Main Functions // 
    /////////////////////

    /**
    * @notice Function to list an NFT on sell
    * @dev
    * - Should include notListed and isOwner modifiers
    * - Should check that NFT price is >= 0, if not -> revert
    * - Should check that contract address has approve on the NFT to be transfered, if not -> revert
    * - Update mapping
    * - Emit event
    */
    function listItem(address nftAddress, uint256 tokenId, uint256 price) external notListed(nftAddress, tokenId, msg.sender) isOwner(nftAddress, tokenId, msg.sender) {
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

    /**
    * @notice Function to buy an NFT
    * @dev
    * - Payable to be able to receive ETH
    * - Should include isListed modifier
    * - Should check if msg.value > price
    */
    function buyItem(address nftAddress, uint256 tokenId) external payable isListed(nftAddress, tokenId) {
        Listing memory listedItem = s_listings[nftAddress][tokenId];
        if (msg.value <= listedItem.price) {
            revert NftMarketPlace__PriceNotMet(nftAddress, tokenId, listedItem.price);
        }
    }

}