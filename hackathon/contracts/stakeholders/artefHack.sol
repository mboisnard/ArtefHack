pragma solidity ^0.4.4;

import '../stakeholders/publisher.sol';
import '../storage/catalogue.sol';
import '../utils/roles.sol';
import '../utils/utils.sol';


contract ArtefHack is Role {
	Balances private balances;
	address public artefhack;

	Catalogue public catalogue;
  Publisher public publisher;

	struct UserResult {
		uint catalogueId;
		bytes32 content;
		bool message;
		bool score;
		uint pref;
	}

	struct Content {
		uint id;
		bytes32 content;
		uint pref;
	}

	bytes32 firstContent;
	mapping(address => UserResult[]) results;
	mapping(address => uint) lastCatalogueId;
	mapping(uint => Content) contents;
	uint contentsLength;
	mapping(address => uint) lastPref;

	function ArtefHack(address _balances, address _publisher, address _roles, address _catalogue) Role(_roles) public {
	    balances = Balances(_balances);
	    publisher = Publisher(_publisher);
	    catalogue = Catalogue(_catalogue);
	}
	
	function publish(uint catalogueId) public returns (bytes32) {
		uint preference;
		bytes32 content;
		(content, preference) = publisher.buyContent(artefhack, catalogueId);
		return content;
	}

	function setArtefHack(address _artefhack) public isRole("Admin") {
		artefhack = _artefhack;
	}

	function visit() public isRole("User") returns (bytes32, bool) {
	
		// Première visite
		uint catalogueId;
		uint preference;
		bool message;

		if (results[msg.sender].length == 0) {
			preference = 90;
		} else {
			
			UserResult[] userResults = results[msg.sender];
			UserResult lastResult = userResults[userResults.length - 1];
			
			if (lastResult.score) {
				preference = lastResult.pref - 1;
			} else {
				if (lastResult.pref > 20) {
					preference = lastResult.pref - 20;
				}	else {
					preference = lastResult.pref + 20;
				}
			}
		}

		uint prefCount = catalogue.getByPrefCount(preference);
		bool switched = false;

		while (prefCount == 0) {
			if (preference < 100 && !switched) {
				preference++;
			} else {
				preference--;
				switched = true;
			}
			
			prefCount = catalogue.getByPrefCount(preference);
		}

		catalogueId = catalogue.getByPrefAt(preference, 0);

		if (contents[catalogueId].content == "") {
			if (balances.getBalance(artefhack) < 50) {
				
				for (uint i = 0; i < contentsLength; i++) {
					if (contents[i].pref < preference + 5 && contents[i].pref > preference - 5) {
						catalogueId = contents[i].id;
						break;
					}
				}
			} else {
				contents[catalogueId].content = publish(catalogueId);
				contents[catalogueId].pref = preference;
				contentsLength++;
				contents[catalogueId].id = catalogueId;
			}
		}

		lastPref[msg.sender] = preference;
		lastCatalogueId[msg.sender] = catalogueId;
		message = false;

		return(contents[catalogueId].content, message);
	}

	function eval(bytes32 content, bool message, bool score) public isRole("User") {
		results[msg.sender].push(UserResult(lastCatalogueId[msg.sender], content, message, score, lastPref[msg.sender]));
	}
}
