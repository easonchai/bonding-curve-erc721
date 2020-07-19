const { expect } = require("chai");

describe("TokenContract", function () {
  let Token;
  let token;
  let addr1 = "0xc783df8a850f42e7F7e57013759C285caa701eB6";
  let addr2 = "0xeAD9C93b79Ae7C1591b1FB5323BD777E86e150d4";

  beforeEach(async function () {
    Token = await ethers.getContractFactory("DecentramallToken");
    token = await Token.deploy(addr1);

    await token.deployed();
  });
  it("Should return the name and symbol of ERC721 Token", async function () {

    expect(await token.name()).to.equal("Decentramall Space Token");
    expect(await token.symbol()).to.equal("SPACE");
  });
  // it("Should allow me to change the limit ", async function () {
  //   await token.changeLimit(1500);
  //   expect(await token.getLimit()).to.equal(1500);
  // });
  // it("Should block others from changing", async function () {
  //   const [owner, addr1] = await ethers.getSigners();
  //   await expect(await token.connect(addr1).changeLimit(1500)).to.be.revertedWith("Not an admin!");
  // });
});

describe("EstateAgent", function () {
  let Agent;
  let agent;

  beforeEach(async function () {
    Agent = await ethers.getContractFactory("EstateAgent");
    agent = await Agent.deploy(100, 5);

    await agent.deployed();
  });
  it("Should return correct price of 6", async function () {
    expect(await agent.price(agent.token.totalSupply() + 1)).to.equal(6);
  });
  // it("Should allow me to change the limit ", async function () {
  //   await token.changeLimit(1500);
  //   expect(await token.getLimit()).to.equal(1500);
  // });
  // it("Should block others from changing", async function () {
  //   const [owner, addr1] = await ethers.getSigners();
  //   await expect(await token.connect(addr1).changeLimit(1500)).to.be.revertedWith("Not an admin!");
  // });
});