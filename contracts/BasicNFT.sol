// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract BasicNFT is ERC721 {
    error BasicNft__TokenUriNotFound();
    error ERC721Metadata__URI_QueryFor_NonExistentToken();
    error Max__Level__Reached();

    string public constant SVG_PART_ONE =
        '<svg fill="#000000" height="200px" width="200px" version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 57 57" xml:space="preserve"> ';
    string public constant SVG_PART_TWO =
        '<g id="SVGRepo_bgCarrier" stroke-width="0"></g> <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g> <g id="SVGRepo_iconCarrier"> <path d="M57,0h-8.837L18.171,29.992l-4.076-4.076l-1.345-4.034c-0.22-0.663-0.857-1.065-1.55-0.98 c-0.693,0.085-1.214,0.63-1.268,1.327l-0.572,7.438l5.982,5.982L4.992,46H2.274C1.02,46,0,47.02,0,48.274v6.452 C0,55.98,1.02,57,2.274,57h6.452C9.98,57,11,55.98,11,54.726v-3.421l10-10l6.021,6.021l6.866-1.145 c0.685-0.113,1.182-0.677,1.21-1.37c0.028-0.693-0.422-1.295-1.096-1.464l-3.297-0.824l-4.043-4.043L57,8.489V0z M9,54.726 C9,54.877,8.877,55,8.726,55H2.274C2.123,55,2,54.877,2,54.726v-6.452C2,48.123,2.123,48,2.274,48h0.718h5.734 C8.877,48,9,48.123,9,48.274v5.031V54.726z M11,48.477v-0.203C11,47.02,9.98,46,8.726,46H7.82l8.938-8.938l1.417,1.417l1.411,1.411 L11,48.477z M30.942,44.645l-3.235,0.54l-5.293-5.293l0,0l-2.833-2.833l-8.155-8.155l0.292-3.796l0.63,1.89l4.41,4.41l0,0 l4.225,4.225l8.699,8.699L30.942,44.645z M25.247,37.066l-2.822-2.822l-2.839-2.839L48.991,2h4.243L23.829,31.406 c-0.391,0.391-0.391,1.023,0,1.414c0.195,0.195,0.451,0.293,0.707,0.293s0.512-0.098,0.707-0.293L55,3.062v4.592L25.247,37.066z"> </path> </g> </svg>';

    string private bgColor;
    uint8 public playerLevel;

    mapping(uint256 tokenId => string tokenUri) private s_tokenIdToUri;
    uint256 private s_tokenCounter;

    constructor() ERC721("Flaming Sword", "FLMSWD") {
        s_tokenCounter = 0;
        bgColor = "white";
        playerLevel = 1;
    }

    function getSVG() public view returns (string memory) {
        string memory bgColorValue;
        if (playerLevel == 1) {
            bgColorValue = "white";
        } else if (playerLevel == 2) {
            bgColorValue = "yellow";
        } else if (playerLevel == 3) {
            bgColorValue = "red";
        }

        return
            string.concat(
                SVG_PART_ONE,
                '<rect width="100%" height="100%" fill="',
                bgColorValue,
                '"/>',
                SVG_PART_TWO
            );
    }

    function changeBgColor(string memory newColor) public {
        bgColor = newColor;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function mintNft() public {
        // how would you require payment for this NFT?
        uint256 tokenCounter = s_tokenCounter;
        _safeMint(msg.sender, tokenCounter);
        s_tokenCounter = s_tokenCounter + 1;
    }

    function levelUp() public {
        require(playerLevel < 3, "Max__Level__Reached");
        playerLevel++;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        if (ownerOf(tokenId) == address(0)) {
            revert ERC721Metadata__URI_QueryFor_NonExistentToken();
        }
        string memory imageURI = getSVG();

        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"a fallen sword"',
                                '", "description":"An NFT that reflects the level of the player, 100% on Chain!", ',
                                '"attributes": [{"trait_type": "sharpiness", "value": 100}], "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
