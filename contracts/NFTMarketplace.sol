pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/EIP712Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "hardhat/console.sol";

contract NFTMarketplace is Initializable, EIP712Upgradeable {
    using SafeERC20 for IERC20;
    using ECDSA for bytes32;

    struct Listing {
        uint256 tokenId;
        uint256 price;
        address seller;
        bool isSold;
    }

    bytes32 private _LISTING_TYPEHASH;

    IERC721 public nft;
    IERC20 public erc20;

    mapping(uint256 => Listing) public listings;
    mapping(bytes32 => bool) public canceled;

    event Listed(
        uint256 indexed tokenId,
        uint256 price,
        address indexed seller
    );
    event Bought(
        uint256 indexed tokenId,
        uint256 price,
        address indexed seller,
        address indexed buyer
    );

    function initialize(IERC721 _nft, IERC20 _erc20)
        public
        virtual
        initializer
    {
        __EIP712_init("NFTMarketplace", "1");
        nft = _nft;
        erc20 = _erc20;
        _LISTING_TYPEHASH = keccak256(
            "Buy(uint256 tokenId,uint256 price,address seller)"
        );
    }

    function list(uint256 _tokenId, uint256 _price) external {
        require(nft.ownerOf(_tokenId) == msg.sender, "You don't own this NFT");

        listings[_tokenId] = Listing({
            tokenId: _tokenId,
            price: _price,
            seller: msg.sender,
            isSold: false
        });

        emit Listed(_tokenId, _price, msg.sender);
    }

    function buy(uint256 _tokenId, bytes calldata _signature) external {
        Listing storage listing = listings[_tokenId];
        require(listing.isSold == false, "This NFT has already been sold");
        require(listing.price > 0, "This NFT is not for sale");

        bytes32 structHash = keccak256(
            abi.encode(
                _LISTING_TYPEHASH,
                listing.tokenId,
                listing.price,
                listing.seller
            )
        );
        bytes32 messageHash = _hashTypedDataV4(structHash);

        console.logBytes32(bytes32(_signature));
        console.logBytes32(_LISTING_TYPEHASH);
        console.logBytes32(structHash);
        console.logBytes32(messageHash);

        address seller = listing.seller;
        address buyer = msg.sender;

        require(!canceled[bytes32(_signature)], "This order has been canceled");
        require(messageHash.recover(_signature) == seller, "Invalid signature");
        require(
            erc20.balanceOf(msg.sender) >= listing.price,
            "Insufficient balance"
        );

        nft.safeTransferFrom(seller, buyer, listing.tokenId);
        erc20.safeTransferFrom(buyer, seller, listing.price);

        listing.isSold = true;

        emit Bought(_tokenId, listing.price, listing.seller, msg.sender);
    }

    function cancel(uint256 _tokenId, bytes calldata _signature) external {
        Listing storage listing = listings[_tokenId];
        require(listing.isSold == false, "This NFT has already been sold");
        require(listing.price > 0, "This NFT is not for sale");

        bytes32 structHash = keccak256(
            abi.encode(
                _LISTING_TYPEHASH,
                listing.tokenId,
                listing.price,
                listing.seller
            )
        );
        bytes32 messageHash = _hashTypedDataV4(structHash);
        require(
            messageHash.recover(_signature) == msg.sender,
            "Invalid signature"
        );
        canceled[bytes32(_signature)] = true;
    }
}
