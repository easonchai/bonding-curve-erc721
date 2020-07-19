const { expect } = require("chai");

describe("TokenContract", function () {
  let Token;
  let token;
  let addr1 = "0xc783df8a850f42e7F7e57013759C285caa701eB6";

  beforeEach(async function () {
    Token = await ethers.getContractFactory("DecentramallToken");
    token = await Token.deploy();

    await token.deployed();
  });
  it("Should return the name and symbol of ERC721 Token", async function () {

    expect(await token.name()).to.equal("Decentramall Space Token");
    expect(await token.symbol()).to.equal("SPACE");
  });
  it("Should resolve a created token with ID 123 at index 0", async function () {
    console.log("TokenID: " + await token.getTokenId())
    await token.mint(addr1);
    expect(await token.tokenOfOwnerByIndex(addr1, 0)).to.equal(123);
  });
  it("Should have 1 token in existence", async function () {
    await token.mint(addr1);
    expect(await token.totalSupply()).to.equal(1);
  });
});
