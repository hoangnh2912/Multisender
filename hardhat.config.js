require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");

const RINKEBY_PRIVATE_KEY =
  "cd33bd88107336c284fff53d164e52dcdae1f8f17ce0ac4133e2fca133d8c101";
module.exports = {
  solidity: "0.8.1",
  networks: {
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/afa9553623db44b388348836b654f819`,
      accounts: [`${RINKEBY_PRIVATE_KEY}`],
    },
  },
  etherscan: {
    apiKey: `2ST54JNJTBR3CANFFTQA5RNEXKF65NN39E`,
  },
};
