// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract TransactionContract {
    struct Transaction {
        string transactionCode;
        string campaignId;
        string fromToUserId;
        string orderType;
        string paymentStatus;
        string status;
        uint quantity;
        uint256 totalPrice;
        string paymentProof;
        string createdAt; // Change to string
    }

    mapping(string => Transaction) public transactions; // Deklarasi mapping
    string[] public transactionCodes; // Array untuk menyimpan kode transaksi

    event TransactionAdded(
        string transactionCode,
        string campaignId,
        string fromToUserId,
        string orderType,
        string paymentStatus,
        string status,
        uint quantity,
        uint256 totalPrice,
        string paymentProof, // Added paymentProof attribute to event
        string createdAt // Change to string
    );

    event StatusUpdated(string transactionCode, string newStatus);
    event PaymentStatusUpdated(string transactionCode, string newPaymentStatus);
    event PaymentProofUpdated(string transactionCode, string newPaymentProof);

    constructor() {
        // Buat konstruktor
    }

    function addTransaction(
        string memory _transactionCode,
        string memory _campaignId,
        string memory _fromToUserId,
        string memory _orderType,
        string memory _paymentStatus,
        string memory _status,
        uint _quantity,
        uint256 _totalPrice,
        string memory _createdAt // Change to string
    ) public {
        transactions[_transactionCode] = Transaction(
            _transactionCode,
            _campaignId,
            _fromToUserId,
            _orderType,
            _paymentStatus,
            _status,
            _quantity,
            _totalPrice,
            "null",
            _createdAt // Change to string
        );

        transactionCodes.push(_transactionCode); // Tambahkan kode transaksi ke dalam array

        emit TransactionAdded(
            _transactionCode,
            _campaignId,
            _fromToUserId,
            _orderType,
            _paymentStatus,
            _status,
            _quantity,
            _totalPrice,
            "null",
            _createdAt // Change to string
        );
    }

    function getAllTransactions() public view returns (Transaction[] memory) {
        Transaction[] memory allTransactions = new Transaction[](
            transactionCodes.length
        );
        for (uint i = 0; i < transactionCodes.length; i++) {
            allTransactions[i] = transactions[transactionCodes[i]];
        }
        return allTransactions;
    }

    function updateStatus(
        string memory _transactionCode,
        string memory _newStatus
    ) public {
        require(
            bytes(transactions[_transactionCode].transactionCode).length != 0,
            "Transaction does not exist"
        );
        transactions[_transactionCode].status = _newStatus;
        emit StatusUpdated(_transactionCode, _newStatus);
    }

    function updatePaymentStatus(
        string memory _transactionCode,
        string memory _newPaymentStatus
    ) public {
        require(
            bytes(transactions[_transactionCode].transactionCode).length != 0,
            "Transaction does not exist"
        );
        transactions[_transactionCode].paymentStatus = _newPaymentStatus;
        emit PaymentStatusUpdated(_transactionCode, _newPaymentStatus);
    }

    function updatePaymentProof(
        string memory _transactionCode,
        string memory _newPaymentProof
    ) public {
        require(
            bytes(transactions[_transactionCode].transactionCode).length != 0,
            "Transaction does not exist"
        );
        transactions[_transactionCode].paymentProof = _newPaymentProof;
        transactions[_transactionCode].paymentStatus = "paid"; // Update payment status to "paid"
        emit PaymentProofUpdated(_transactionCode, _newPaymentProof);
        emit PaymentStatusUpdated(_transactionCode, "paid");
    }

    function getTransactionByFromToUserId(
        string memory _fromToUserId
    ) public view returns (Transaction[] memory) {
        uint count = 0;
        for (uint i = 0; i < transactionCodes.length; i++) {
            if (
                keccak256(
                    abi.encodePacked(
                        transactions[transactionCodes[i]].fromToUserId
                    )
                ) == keccak256(abi.encodePacked(_fromToUserId))
            ) {
                count++;
            }
        }
        Transaction[] memory result = new Transaction[](count);
        uint index = 0;
        for (uint i = 0; i < transactionCodes.length; i++) {
            if (
                keccak256(
                    abi.encodePacked(
                        transactions[transactionCodes[i]].fromToUserId
                    )
                ) == keccak256(abi.encodePacked(_fromToUserId))
            ) {
                result[index] = transactions[transactionCodes[i]];
                index++;
            }
        }
        return result;
    }

    function getTransactionByCode(
        string memory _transactionCode
    ) public view returns (Transaction memory) {
        require(
            bytes(transactions[_transactionCode].transactionCode).length != 0,
            "Transaction does not exist"
        );
        return transactions[_transactionCode];
    }

    function getTransactionByCampaignId(
        string memory _campaignId
    ) public view returns (Transaction[] memory) {
        uint count = 0;
        for (uint i = 0; i < transactionCodes.length; i++) {
            if (
                keccak256(
                    abi.encodePacked(
                        transactions[transactionCodes[i]].campaignId
                    )
                ) == keccak256(abi.encodePacked(_campaignId))
            ) {
                count++;
            }
        }
        Transaction[] memory result = new Transaction[](count);
        uint index = 0;
        for (uint i = 0; i < transactionCodes.length; i++) {
            if (
                keccak256(
                    abi.encodePacked(
                        transactions[transactionCodes[i]].campaignId
                    )
                ) == keccak256(abi.encodePacked(_campaignId))
            ) {
                result[index] = transactions[transactionCodes[i]];
                index++;
            }
        }
        return result;
    }

    // Function to get the count of transactions
    function getCountTransaction() public view returns (uint) {
        return transactionCodes.length;
    }
}
