// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract TokenContract {
    struct Token {
        string campaignId;
        string transactionCode;
        string token;
        string status;
        string soldTo;
        uint createdAt;
    }

    Token[] private tokens;

    event TokenAdded(
        string campaignId,
        string transactionCode,
        string token,
        string status,
        string soldTo
    );

    event TokenStatusChanged(
        string transactionCode,
        string oldStatus,
        string newStatus
    );

    event TokenDeleted(string transactionCode);

    // Function to add a token
    function addToken(
        string memory _campaignId,
        string memory _transactionCode,
        string memory _token,
        string memory _status,
        string memory _soldTo
    ) public {
        tokens.push(
            Token({
                campaignId: _campaignId,
                transactionCode: _transactionCode,
                token: _token,
                status: _status,
                soldTo: _soldTo,
                createdAt: block.timestamp
            })
        );

        emit TokenAdded(
            _campaignId,
            _transactionCode,
            _token,
            _status,
            _soldTo
        );
    }

    // Function to get all tokens
    function getAllTokens() public view returns (Token[] memory) {
        return tokens;
    }

    // Function to get tokens by campaignId
    function getTokensByCampaignId(
        string memory _campaignId
    ) public view returns (Token[] memory) {
        uint count = 0;
        for (uint i = 0; i < tokens.length; i++) {
            if (
                keccak256(abi.encodePacked(tokens[i].campaignId)) ==
                keccak256(abi.encodePacked(_campaignId))
            ) {
                count++;
            }
        }

        Token[] memory result = new Token[](count);
        uint index = 0;
        for (uint i = 0; i < tokens.length; i++) {
            if (
                keccak256(abi.encodePacked(tokens[i].campaignId)) ==
                keccak256(abi.encodePacked(_campaignId))
            ) {
                result[index] = tokens[i];
                index++;
            }
        }
        return result;
    }

    // Function to get tokens by campaignId and soldTo
    function getTokensByCampaignIdAndSoldTo(
        string memory _campaignId,
        string memory _userId
    ) public view returns (Token[] memory) {
        uint count = 0;
        for (uint i = 0; i < tokens.length; i++) {
            if (
                keccak256(abi.encodePacked(tokens[i].campaignId)) ==
                keccak256(abi.encodePacked(_campaignId)) &&
                keccak256(abi.encodePacked(tokens[i].soldTo)) ==
                keccak256(abi.encodePacked(_userId))
            ) {
                count++;
            }
        }

        Token[] memory result = new Token[](count);
        uint index = 0;
        for (uint i = 0; i < tokens.length; i++) {
            if (
                keccak256(abi.encodePacked(tokens[i].campaignId)) ==
                keccak256(abi.encodePacked(_campaignId)) &&
                keccak256(abi.encodePacked(tokens[i].soldTo)) ==
                keccak256(abi.encodePacked(_userId))
            ) {
                result[index] = tokens[i];
                index++;
            }
        }
        return result;
    }

    // Function to get sold tokens by campaignId
    function getSoldTokensByCampaignId(
        string memory _campaignId,
        string memory _userId
    ) public view returns (Token[] memory) {
        uint count = 0;
        for (uint i = 0; i < tokens.length; i++) {
            if (
                keccak256(abi.encodePacked(tokens[i].campaignId)) ==
                keccak256(abi.encodePacked(_campaignId)) &&
                keccak256(abi.encodePacked(tokens[i].soldTo)) ==
                keccak256(abi.encodePacked(_userId)) &&
                keccak256(abi.encodePacked(tokens[i].status)) ==
                keccak256(abi.encodePacked("sold"))
            ) {
                count++;
            }
        }

        Token[] memory result = new Token[](count);
        uint index = 0;
        for (uint i = 0; i < tokens.length; i++) {
            if (
                keccak256(abi.encodePacked(tokens[i].campaignId)) ==
                keccak256(abi.encodePacked(_campaignId)) &&
                keccak256(abi.encodePacked(tokens[i].soldTo)) ==
                keccak256(abi.encodePacked(_userId)) &&
                keccak256(abi.encodePacked(tokens[i].status)) ==
                keccak256(abi.encodePacked("sold"))
            ) {
                result[index] = tokens[i];
                index++;
            }
        }
        return result;
    }

    // Function to get tokens by soldTo
    function getTokensBySoldTo(
        string memory _userId
    ) public view returns (Token[] memory) {
        uint count = 0;
        for (uint i = 0; i < tokens.length; i++) {
            if (
                keccak256(abi.encodePacked(tokens[i].soldTo)) ==
                keccak256(abi.encodePacked(_userId))
            ) {
                count++;
            }
        }

        Token[] memory result = new Token[](count);
        uint index = 0;
        for (uint i = 0; i < tokens.length; i++) {
            if (
                keccak256(abi.encodePacked(tokens[i].soldTo)) ==
                keccak256(abi.encodePacked(_userId))
            ) {
                result[index] = tokens[i];
                index++;
            }
        }
        return result;
    }

    // Function to get tokens by transactionCode
    function getTokensByTransactionCode(
        string memory _transactionCode
    ) public view returns (Token[] memory) {
        uint count = 0;
        for (uint i = 0; i < tokens.length; i++) {
            if (
                keccak256(abi.encodePacked(tokens[i].transactionCode)) ==
                keccak256(abi.encodePacked(_transactionCode))
            ) {
                count++;
            }
        }

        Token[] memory result = new Token[](count);
        uint index = 0;
        for (uint i = 0; i < tokens.length; i++) {
            if (
                keccak256(abi.encodePacked(tokens[i].transactionCode)) ==
                keccak256(abi.encodePacked(_transactionCode))
            ) {
                result[index] = tokens[i];
                index++;
            }
        }
        return result;
    }

    // Function to change status by transactionCode
    function changeStatusByTransactionCode(
        string memory _transactionCode,
        string memory _newStatus
    ) public {
        for (uint i = 0; i < tokens.length; i++) {
            if (
                keccak256(abi.encodePacked(tokens[i].transactionCode)) ==
                keccak256(abi.encodePacked(_transactionCode))
            ) {
                string memory oldStatus = tokens[i].status;
                tokens[i].status = _newStatus;
                emit TokenStatusChanged(
                    _transactionCode,
                    oldStatus,
                    _newStatus
                );
            }
        }
    }

    // Function to delete token by transactionCode and quantity
    function deleteTokenByTransactionCode(
        string memory _transactionCode,
        uint _quantity
    ) public {
        uint deletedCount = 0;
        uint i = 0;
        while (i < tokens.length && deletedCount < _quantity) {
            if (
                keccak256(abi.encodePacked(tokens[i].transactionCode)) ==
                keccak256(abi.encodePacked(_transactionCode))
            ) {
                for (uint j = i; j < tokens.length - 1; j++) {
                    tokens[j] = tokens[j + 1];
                }
                tokens.pop();
                emit TokenDeleted(_transactionCode);
                deletedCount++;
            } else {
                i++;
            }
        }
    }

    // Function to delete token by campaignId, soldTo, and quantity
    function deleteTokenByCampaignIdAndSoldTo(
        string memory _campaignId,
        string memory _soldTo,
        uint _quantity
    ) public {
        uint deletedCount = 0;
        uint i = 0;
        while (i < tokens.length && deletedCount < _quantity) {
            if (
                keccak256(abi.encodePacked(tokens[i].campaignId)) ==
                keccak256(abi.encodePacked(_campaignId)) &&
                keccak256(abi.encodePacked(tokens[i].soldTo)) ==
                keccak256(abi.encodePacked(_soldTo))
            ) {
                emit TokenDeleted(tokens[i].transactionCode); // Emit event before deletion
                for (uint j = i; j < tokens.length - 1; j++) {
                    tokens[j] = tokens[j + 1];
                }
                tokens.pop();
                deletedCount++;
            } else {
                i++;
            }
        }
    }

    // Function to delete tokens by campaignId
    function deleteTokenByCampaignId(
        string memory _campaignId
    ) public returns (Token[] memory) {
        uint deletedCount = 0;
        uint i = 0;
        uint count = 0;

        // First pass to count the number of tokens to be deleted
        for (uint j = 0; j < tokens.length; j++) {
            if (
                keccak256(abi.encodePacked(tokens[j].campaignId)) ==
                keccak256(abi.encodePacked(_campaignId))
            ) {
                count++;
            }
        }

        // Create an array to store deleted tokens
        Token[] memory deletedTokens = new Token[](count);

        // Second pass to delete the tokens and store them in the array
        while (i < tokens.length) {
            if (
                keccak256(abi.encodePacked(tokens[i].campaignId)) ==
                keccak256(abi.encodePacked(_campaignId))
            ) {
                deletedTokens[deletedCount] = tokens[i];
                emit TokenDeleted(tokens[i].transactionCode); // Emit event before deletion
                for (uint j = i; j < tokens.length - 1; j++) {
                    tokens[j] = tokens[j + 1];
                }
                tokens.pop();
                deletedCount++;
            } else {
                i++;
            }
        }

        return deletedTokens;
    }
}
