const Web3 = require("web3");

const web3 = new Web3(
  "https://rinkeby.infura.io/v3/afa9553623db44b388348836b654f819"
);

const contractAddress = "0xFB0bE0679CD61d86589746ab3bec7CF2Cc11f97d";
const abi = require("./build/abi.json");
const contract = new web3.eth.Contract(abi, contractAddress);
const ownerAddress = "0x3C90D8be4573F0582a2613e5CeFE8727431dB2f2";

const privateKey =
  "cd33bd88107336c284fff53d164e52dcdae1f8f17ce0ac4133e2fca133d8c101";
web3.eth.accounts.wallet.add(privateKey);

const sendMultipleERC20 = async (addressERC20, listReceivers, amount) => {
  try {
    const contractERC20 = new web3.eth.Contract(
      require("./build/abiERC20.json"),
      addressERC20
    );

    const txApprove = await contractERC20.methods
      .approve(contractAddress, amount * listReceivers.length)
      .send({
        from: ownerAddress,
        gas: "1000000",
      });
    const tx = await contract.methods
      .sendMultiERC20(addressERC20, listReceivers, amount)
      .send({
        from: ownerAddress,
        gas: "1000000",
      });
    console.log("ERC20 ", tx.transactionHash);
  } catch (error) {
    console.log(error);
  }
};

const sendMultipleERC721 = async (
  addressERC721,
  listReceivers,
  listTokenId
) => {
  try {
    const contractERC721 = new web3.eth.Contract(
      require("./build/abiERC721.json"),
      addressERC721
    );

    for (let i = 0; i < listTokenId.length; i++) {
      const tokenId = listTokenId[i];
      const txApprove = await contractERC721.methods
        .approve(contractAddress, tokenId)
        .send({
          from: ownerAddress,
          gas: "1000000",
        });
      console.log("txApprove", txApprove.transactionHash);
    }

    const tx = await contract.methods
      .sendMultiERC721(addressERC721, listReceivers, listTokenId)
      .send({
        from: ownerAddress,
        gas: "1000000",
      });
    console.log("ERC721", tx.transactionHash);
  } catch (error) {
    console.log(error);
  }
};

const sendMultipleETH = async (listReceivers, listAmounts) => {
  try {
    const tx = await contract.methods
      .sendMultiETH(listReceivers, listAmounts)
      .send({
        from: ownerAddress,
        gas: "1000000",
        value: listAmounts.reduce((a, b) => parseInt(a) + parseInt(b), 0),
      });
    console.log("ETH ", tx.transactionHash);
  } catch (error) {
    console.log(error);
  }
};

// sendMultipleETH(
//   [
//     "0x627306090abaB3A6e1400e9345bC60c78a8BEf57",
//     "0x20e5f90F0013e59Aa3B0cfeC832815db187b05FA",
//   ],
//   [web3.utils.toWei("0.001", "ether"), web3.utils.toWei("0.003", "ether")]
// );

// sendMultipleERC721(
//   "0x1FD9b21091779533Afb8FEDC58Fd83a2a7F0a281",
//   [
//     "0x627306090abaB3A6e1400e9345bC60c78a8BEf57",
//     "0x20e5f90F0013e59Aa3B0cfeC832815db187b05FA",
//   ],
//   [8, 9]
// );

// sendMultipleERC20(
//   "0xfCAC96faCbFc94bf8A58616290D678e8100Ddc4d",
//   [
//     "0x627306090abaB3A6e1400e9345bC60c78a8BEf57",
//     "0x20e5f90F0013e59Aa3B0cfeC832815db187b05FA",
//   ],
//   1000000
// );
