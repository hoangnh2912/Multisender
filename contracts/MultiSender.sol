// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract MultiSender {
    function sendMultiETH(
        address payable[] memory listReceivers,
        uint256[] memory listAmountsamountss
    ) public payable {
        uint256 totalReceivers = listReceivers.length;
        uint256 totalAmountsamountss;
        for (uint256 i = 0; i < totalReceivers; i++) {
            totalAmountsamountss += listAmountsamountss[i];
        }
        require(msg.value == totalAmountsamountss, "ETH Value not enough");
        require(
            msg.sender.balance >= totalAmountsamountss,
            "Total balance not enough"
        );
        for (uint256 i = 0; i < totalReceivers; i++) {
            (bool success, ) = listReceivers[i].call{
                value: listAmountsamountss[i]
            }("");
            require(
                success,
                string(
                    abi.encodePacked(
                        "Transaction ",
                        Strings.toString(i),
                        " failed"
                    )
                )
            );
        }
    }

    function sendMultiERC721(
        address[] memory addressERC721s,
        address[] memory listReceivers,
        uint256[] memory listTokenId
    ) public returns (bool) {
        require(listReceivers.length == listTokenId.length, "Not same length");

        for (uint256 i = 0; i < listReceivers.length; i++) {
            IERC721 erc721 = IERC721(addressERC721s[i]);
            require(
                erc721.ownerOf(listTokenId[i]) == msg.sender,
                "Token not owned by sender"
            );

            require(
                erc721.getApproved(listTokenId[i]) == address(this),
                "Not approved"
            );
            erc721.transferFrom(msg.sender, listReceivers[i], listTokenId[i]);
        }
        return true;
    }

    function sendMultiERC20(
        address[] memory addressERC20s,
        address[] memory listReceivers,
        uint256[] memory amounts
    ) public returns (bool) {
        require(listReceivers.length == amounts.length, "Not same length");

        for (uint256 i = 0; i < listReceivers.length; i++) {
            IERC20 erc20 = IERC20(addressERC20s[i]);
            require(
                erc20.balanceOf(msg.sender) >= amounts[i],
                "Balance not enough"
            );

            uint256 allowance = erc20.allowance(msg.sender, address(this));
            require(allowance >= amounts[i], "Check the token allowance");
            erc20.transferFrom(msg.sender, listReceivers[i], amounts[i]);
        }
        return true;
    }
}
