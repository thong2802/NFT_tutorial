const { ethers } = require('hardhat');

async function main() {
  //let accounts = await ethers.getSigners();

    const NFT = await ethers.getContractFactory("NFT");

    const nft = await NFT.deploy("Dev", "DT");

    await nft.deployed();

    console.log('NFT deployed to:', nft.address);

    await nft.mint("https://ipfs.io/ipfs/QmR88tCZK8HLw47LXkoXKE6uAeXCG7dMBnYPdo73hXLUJ3");

    console.log("nft successfully minted");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });