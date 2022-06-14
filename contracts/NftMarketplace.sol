// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

/** 
1. Create a Decentralized MarketPlace ✅
    1. `listItem`: List NFTs on the Marketplace. ✅
    2. `buyItem`: Buy NFTs directly on the Marketplace. ✅
    3. `cancelItem`: Cancel item listing. ✅
    4. `updateListing`: Update listing price. ✅
    5. `withdrawProceeds`: Withdraw funds from sold NFTs. ✅
*/

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

error NftMarketPlace__PriceMustBeAboveZero();
error NftMarketPlace__NotApprovedForMarketPlace();
error NftMarketPlace__NotOwner();
error NftMarketPlace__AlreadyListed(address nftAddress, uint256 tokenId);
error NftMarketPlace__NotListed(address nftAddress, uint256 tokenId);
error NftMarketPlace__PriceNotMet(address nftAddress, uint256 tokenId, uint256 price);
error  NftMarketPlace__NoProceeds();
error NftMarketPlace__TransferFailed();


contract NftMarketPlace is ReentrancyGuard {

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
    event ItemBought(address indexed buyer, address indexed nftAddress, uint256 indexed tokenId, uint256 price);
    event ItemCanceled(address indexed, address indexed nftAddress, uint256 indexed tokenId);

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
    * - Should include nonReentrant modifier from Openzeppelin (avoid Reentrancy attack)
    * - Should include isListed modifier
    * - Should check if msg.value > price
    * - Update mappings
    * - Delete listing mapping (item is not listed anymore)
    * - Transfer NFT (using OpenZeppeling safeTransferFrom function)
    * - Emit event
    * - ❌ No send Ether to the user
    * - ✅ Push them to withdraw from proceeds listing (better practice)
    */
    function buyItem(address nftAddress, uint256 tokenId) external payable nonReentrant isListed(nftAddress, tokenId) {
        Listing memory listedItem = s_listings[nftAddress][tokenId];
        if (msg.value <= listedItem.price) {
            revert NftMarketPlace__PriceNotMet(nftAddress, tokenId, listedItem.price);
        }
        s_proceeds[listedItem.seller] = s_proceeds[listedItem.seller] + msg.value;
        delete(s_listings[nftAddress][tokenId]);
        // Could just send the money...
        // https://fravoll.github.io/solidity-patterns/pull_over_push.html
        // - ❌ No send Ether to the user
        // ✅ Push them to withdraw from proceeds listing (better practice)
        IERC721(nftAddress).safeTransferFrom(listedItem.seller, msg.sender, tokenId);
        emit ItemBought(msg.sender, nftAddress, tokenId, listedItem.price);
    }

    /**
    * @notice Function cancel NFT sell listing
    * @dev
    * - Should include isListed modifier
    * - Should include isOwner
    * - Delete listing mapping (item is not listed anymore)
    * - Emit event
    */
    function cancelListing(address nftAddress, uint256 tokenId) external isOwner(nftAddress, tokenId, msg.sender) isListed (nftAddress, tokenId) {
        delete (s_listings[nftAddress][tokenId]);
        emit ItemCanceled(msg.sender, nftAddress, tokenId);
    }

    /**
    * @notice Function update selling NFT price
    * @dev
    * - Should include nonReentrant modifier from Openzeppelin (avoid Reentrancy attack)
    * - Should include isListed modifier
    * - Should include isOwner
    * - Update mapping
    * - Emit event
    */
    function updateLiting(address nftAddress, uint256 tokenId, uint256 newPrice) external nonReentrant isOwner(nftAddress, tokenId, msg.sender) isListed (nftAddress, tokenId) {
        s_listings[nftAddress][tokenId].price = newPrice;
        emit ItemListed(msg.sender, nftAddress, tokenId, newPrice);
    }

    /**
    * @notice Function to withdraw proceeds
    * @dev
    * - Should check that procees are > 0, if not -> revert
    * - Update mapping
    * - Transfer funds
    * - Check transfer is correctly done, if not -> revert
    */
    function withdrawProceeds() external {
        uint256 proceeds = s_proceeds[msg.sender];
        if (proceeds <= 0) {
            revert NftMarketPlace__NoProceeds();
        }
        s_proceeds[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: proceeds}("");
        if (!success) {
            revert NftMarketPlace__TransferFailed();
        }
    }

    //////////////////////
    //  Getter Functions // 
    /////////////////////

    function getListing(address nftAddress, uint256 tokenId) external view returns (Listing memory) {
        return s_listings[nftAddress][tokenId];
    }

    function getProceeds(address seller) external view returns (uint256) {
        return s_proceeds[seller];
    }
}