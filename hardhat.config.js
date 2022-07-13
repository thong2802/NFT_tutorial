require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const privateKey = "d09ed99c11ad39c652e5ee1b057ab292d7321ba6b35b4e2276e7c91bb2727c71";
module.exports = {
  defaultNetwork: "matic",
  networks: {
    hardhat: {
    },
    matic: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [privateKey]
    }
  },
  solidity: {
    version: "0.8.2",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
}