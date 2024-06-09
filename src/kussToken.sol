// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DocumentToken is ERC20 {
    mapping(address => uint256) public rewards;
    mapping(uint256 => Document) public documents;
    uint256 public nextDocumentId = 0;

    struct Document {
        uint256	id; 
        string	title; // string형식의 문서 이름 ex) (과목명)_(발행년도)_(제공자 이름)_(버전)
        uint256	tokenCost; // 1개 또는 2개
		bool	isPending;
		address	contributor;
    }

    constructor() ERC20("KUSSToken", "KTN") {
        _mint(msg.sender, 1000000 * (10 ** uint256(decimals())));
    }

    function registerUser(address user) public {
        require(balanceOf(user) == 0, "User already registered.");
        _mint(user, 10);
    }

    function uploadDocument(string memory title, uint256 tokenCost) public {
        documents[nextDocumentId++] = Document(nextDocumentId, title, tokenCost, true, msg.sender);
    }

	function uploadVerifiedDocument(Document pendingDocument) public onlyOwner {
		pendingDocument.isPending = false;
		_mint(pendingDocument.contributor, 4);
	}

    function viewDocument(uint256 documentId) public {
        require(balanceOf(msg.sender) >= documents[documentId].tokenCost, "Insufficient tokens.");
        _burn(msg.sender, documents[documentId].tokenCost);
    }

	function setPrice(bool documentType, uint256 newPrice) public onlyOwner {
		uint256 existingPrice;
		if (documentType == true) { // 시험지의 경우.
			for(uint256 i = 0; i < len(documents); i++) {
				documents[i].tokenCost = newPrice;
			}
		}
		else { // 과제의 경우. -> if문 구현해야함.
			for(uint256 i = 0; i < len(documents); i++) {
				documents[i].tokenCost = newPrice;
			}
		}

	}
}
