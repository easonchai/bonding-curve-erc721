const { expect } = require("chai");

describe("TokenContract", function () {
  let Token;
  let token;

  beforeEach(async function () {
    Token = await ethers.getContractFactory("DecentramallToken");
    token = await Token.deploy();

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
  it("Should return token address & details", async function () {
    let token = await agent.tokenAddress();
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