const { expect } = require("chai");

describe("TokenContract", function () {
  let TokenContract, tokenContract, owner;

  beforeEach(async function () {
    TokenContract = await ethers.getContractFactory("TokenContract");
    [owner] = await ethers.getSigners();
    tokenContract = await TokenContract.deploy();
    await tokenContract.deployed();
  });

  it("Harus dapat deploy contract TokenContract", async function () {
    expect(tokenContract.address).to.be.a("string");
    expect(tokenContract.address).to.have.lengthOf(42);
    expect(tokenContract.address).to.match(/^0x[a-fA-F0-9]{40}$/);
  });

  it("Harus dapat menambahkan token baru", async function () {
    const tx = await tokenContract
      .addToken("campaign1", "tx123", "token1", "active", "user1")
      .then((tx) => tx.wait());

    const tokens = await tokenContract.getAllTokens();
    expect(tokens.length).to.equal(1);
    expect(tokens[0].campaignId).to.equal("campaign1");
    expect(tokens[0].transactionCode).to.equal("tx123");
    expect(tokens[0].token).to.equal("token1");
    expect(tokens[0].status).to.equal("active");
    expect(tokens[0].soldTo).to.equal("user1");
  });

  it("Harus dapat mengambil token berdasarkan campaignId", async function () {
    await tokenContract
      .addToken("campaign1", "tx123", "token1", "active", "user1")
      .then((tx) => tx.wait());
    await tokenContract
      .addToken("campaign1", "tx124", "token2", "inactive", "user2")
      .then((tx) => tx.wait());
    await tokenContract
      .addToken("campaign2", "tx125", "token3", "active", "user3")
      .then((tx) => tx.wait());

    const tokens = await tokenContract.getTokensByCampaignId("campaign1");
    expect(tokens.length).to.equal(2);
    expect(tokens[0].transactionCode).to.equal("tx123");
    expect(tokens[1].transactionCode).to.equal("tx124");
  });

  it("Harus dapat mengambil token berdasarkan CampaignId dan SoldTo", async function () {
    await tokenContract
      .addToken("campaign1", "tx123", "token1", "active", "user1")
      .then((tx) => tx.wait());
    await tokenContract
      .addToken("campaign1", "tx124", "token2", "inactive", "user1")
      .then((tx) => tx.wait());
    await tokenContract
      .addToken("campaign1", "tx125", "token3", "active", "user2")
      .then((tx) => tx.wait());

    const tokens = await tokenContract.getTokensByCampaignIdAndSoldTo(
      "campaign1",
      "user1"
    );

    expect(tokens.length).to.equal(2);
    expect(tokens[0].transactionCode).to.equal("tx123");
    expect(tokens[1].transactionCode).to.equal("tx124");
  });

  it("Harus dapat mengambil token yang sudah terjual berdasarkan campaignId", async function () {
    await tokenContract
      .addToken("campaign1", "tx123", "token1", "sold", "user1")
      .then((tx) => tx.wait());
    await tokenContract
      .addToken("campaign1", "tx124", "token2", "active", "user2")
      .then((tx) => tx.wait());

    const tokens = await tokenContract.getSoldTokensByCampaignId(
      "campaign1",
      "user1"
    );
    expect(tokens.length).to.equal(1);
    expect(tokens[0].transactionCode).to.equal("tx123");
  });

  it("Harus dapat mengambil token berdasarkan soldTo", async function () {
    await tokenContract
      .addToken("campaign1", "tx123", "token1", "active", "user1")
      .then((tx) => tx.wait());
    await tokenContract
      .addToken("campaign1", "tx124", "token2", "sold", "user1")
      .then((tx) => tx.wait());
    await tokenContract
      .addToken("campaign1", "tx125", "token3", "inactive", "user2")
      .then((tx) => tx.wait());

    const tokens = await tokenContract.getTokensBySoldTo("user1");
    expect(tokens.length).to.equal(2);
    expect(tokens[0].transactionCode).to.equal("tx123");
    expect(tokens[1].transactionCode).to.equal("tx124");
  });

  it("Harus dapat mengambil token berdasarkan transactionCode", async function () {
    await tokenContract
      .addToken("campaign1", "tx123", "token1", "active", "user1")
      .then((tx) => tx.wait());
    await tokenContract
      .addToken("campaign1", "tx124", "token2", "inactive", "user2")
      .then((tx) => tx.wait());

    const tokens = await tokenContract.getTokensByTransactionCode("tx123");
    expect(tokens.length).to.equal(1);
    expect(tokens[0].transactionCode).to.equal("tx123");
  });

  it("Harus dapat mengubah status berdasarkan transactionCode", async function () {
    await tokenContract
      .addToken("campaign1", "tx123", "token1", "active", "user1")
      .then((tx) => tx.wait());
    const tx = await tokenContract
      .changeStatusByTransactionCode("tx123", "sold")
      .then((tx) => tx.wait());

    const tokens = await tokenContract.getTokensByTransactionCode("tx123");
    expect(tokens.length).to.equal(1);
    expect(tokens[0].status).to.equal("sold");
  });

  it("Harus dapat menghapus token berdasarkan transactionCode", async function () {
    await tokenContract
      .addToken("campaign1", "tx123", "token1", "active", "user1")
      .then((tx) => tx.wait());
    await tokenContract
      .addToken("campaign1", "tx124", "token2", "inactive", "user2")
      .then((tx) => tx.wait());
    const tx = await tokenContract
      .deleteTokenByTransactionCode("tx123", 1)
      .then((tx) => tx.wait());

    const tokens = await tokenContract.getAllTokens();
    expect(tokens.length).to.equal(1);
    expect(tokens[0].transactionCode).to.equal("tx124");
  });

  it("Harus dapat menghapus token berdasarkan campaignId dan soldTo", async function () {
    await tokenContract
      .addToken("campaign1", "tx123", "token1", "active", "user1")
      .then((tx) => tx.wait());
    await tokenContract
      .addToken("campaign1", "tx124", "token2", "inactive", "user1")
      .then((tx) => tx.wait());
    await tokenContract
      .addToken("campaign1", "tx125", "token3", "active", "user2")
      .then((tx) => tx.wait());
    const tx = await tokenContract
      .deleteTokenByCampaignIdAndSoldTo("campaign1", "user1", 1)
      .then((tx) => tx.wait());

    const tokens = await tokenContract.getAllTokens();
    expect(tokens.length).to.equal(2);
    expect(tokens[0].transactionCode).to.not.equal("tx123");
  });

  it("Harus dapat menghapus token berdasarkan campaignId", async function () {
    await tokenContract
      .addToken("campaign1", "tx123", "token1", "active", "user1")
      .then((tx) => tx.wait());
    await tokenContract
      .addToken("campaign1", "tx124", "token2", "inactive", "user1")
      .then((tx) => tx.wait());
    await tokenContract
      .addToken("campaign2", "tx125", "token3", "active", "user2")
      .then((tx) => tx.wait());
    const deletedTokens = await tokenContract
      .deleteTokenByCampaignId("campaign1")
      .then((tx) => tx.wait());

    const tokens = await tokenContract.getAllTokens();
    expect(tokens.length).to.equal(1);
    expect(tokens[0].transactionCode).to.equal("tx125");
  });
});
