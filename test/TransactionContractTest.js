const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("TransactionContract", function () {
  let TransactionContract, transactionContract, owner, addr1, addr2;

  beforeEach(async function () {
    TransactionContract = await ethers.getContractFactory(
      "TransactionContract"
    );
    [owner, addr1, addr2] = await ethers.getSigners();
    transactionContract = await TransactionContract.deploy();
    await transactionContract.deployed();
  });

  it("harus dapat menambahkan transaksi", async function () {
    await transactionContract
      .addTransaction(
        "tx123",
        "campaign1",
        "user1",
        "order",
        "pending",
        "new",
        10,
        ethers.utils.parseEther("1"),
        "2023-07-23"
      )
      .then((tx) => tx.wait());

    const transaction = await transactionContract.getTransactionByCode("tx123");
    expect(transaction.transactionCode).to.equal("tx123");
    expect(transaction.campaignId).to.equal("campaign1");
    expect(transaction.fromToUserId).to.equal("user1");
    expect(transaction.orderType).to.equal("order");
    expect(transaction.paymentStatus).to.equal("pending");
    expect(transaction.status).to.equal("new");
    expect(transaction.quantity.eq(ethers.BigNumber.from(10))).to.be.true;
    expect(transaction.totalPrice.eq(ethers.utils.parseEther("1"))).to.be.true;
    expect(transaction.createdAt).to.equal("2023-07-23");
  });

  it("harus dapat memperbarui status transaksi", async function () {
    await transactionContract
      .addTransaction(
        "tx123",
        "campaign1",
        "user1",
        "order",
        "pending",
        "new",
        10,
        ethers.utils.parseEther("1"),
        "2023-07-23"
      )
      .then((tx) => tx.wait());

    await transactionContract
      .updateStatus("tx123", "completed")
      .then((tx) => tx.wait());

    const transaction = await transactionContract.getTransactionByCode("tx123");
    expect(transaction.status).to.equal("completed");
  });

  it("harus dapat memperbarui status pembayaran transaksi", async function () {
    await transactionContract
      .addTransaction(
        "tx123",
        "campaign1",
        "user1",
        "order",
        "pending",
        "new",
        10,
        ethers.utils.parseEther("1"),
        "2023-07-23"
      )
      .then((tx) => tx.wait());

    await transactionContract
      .updatePaymentStatus("tx123", "paid")
      .then((tx) => tx.wait());

    const transaction = await transactionContract.getTransactionByCode("tx123");
    expect(transaction.paymentStatus).to.equal("paid");
  });

  it("harus dapat memperbarui bukti pembayaran transaksi", async function () {
    await transactionContract
      .addTransaction(
        "tx123",
        "campaign1",
        "user1",
        "order",
        "pending",
        "new",
        10,
        ethers.utils.parseEther("1"),
        "2023-07-23"
      )
      .then((tx) => tx.wait());

    await transactionContract
      .updatePaymentProof("tx123", "proof123")
      .then((tx) => tx.wait());

    const transaction = await transactionContract.getTransactionByCode("tx123");
    expect(transaction.paymentProof).to.equal("proof123");
    expect(transaction.paymentStatus).to.equal("paid");
  });

  it("harus dapat mendapatkan transaksi berdasarkan fromToUserId", async function () {
    await transactionContract
      .addTransaction(
        "tx123",
        "campaign1",
        "user1",
        "order",
        "pending",
        "new",
        10,
        ethers.utils.parseEther("1"),
        "2023-07-23"
      )
      .then((tx) => tx.wait());

    await transactionContract
      .addTransaction(
        "tx124",
        "campaign1",
        "user1",
        "order",
        "pending",
        "new",
        5,
        ethers.utils.parseEther("0.5"),
        "2023-07-24"
      )
      .then((tx) => tx.wait());

    const transactions = await transactionContract.getTransactionByFromToUserId(
      "user1"
    );
    expect(transactions.length).to.equal(2);
    expect(transactions[0].transactionCode).to.equal("tx123");
    expect(transactions[1].transactionCode).to.equal("tx124");
  });

  it("harus dapat mendapatkan transaksi berdasarkan campaignId", async function () {
    await transactionContract
      .addTransaction(
        "tx123",
        "campaign1",
        "user1",
        "order",
        "pending",
        "new",
        10,
        ethers.utils.parseEther("1"),
        "2023-07-23"
      )
      .then((tx) => tx.wait());

    await transactionContract
      .addTransaction(
        "tx125",
        "campaign2",
        "user2",
        "order",
        "pending",
        "new",
        15,
        ethers.utils.parseEther("1.5"),
        "2023-07-25"
      )
      .then((tx) => tx.wait());

    const transactions = await transactionContract.getTransactionByCampaignId(
      "campaign1"
    );
    expect(transactions.length).to.equal(1);
    expect(transactions[0].transactionCode).to.equal("tx123");
  });

  it("harus dapat mendapatkan jumlah transaksi", async function () {
    await transactionContract
      .addTransaction(
        "tx123",
        "campaign1",
        "user1",
        "order",
        "pending",
        "new",
        10,
        ethers.utils.parseEther("1"),
        "2023-07-23"
      )
      .then((tx) => tx.wait());

    await transactionContract
      .addTransaction(
        "tx126",
        "campaign3",
        "user3",
        "order",
        "pending",
        "new",
        20,
        ethers.utils.parseEther("2"),
        "2023-07-26"
      )
      .then((tx) => tx.wait());

    const count = await transactionContract.getCountTransaction();
    expect(count.eq(ethers.BigNumber.from(2))).to.be.true;
  });
});
