// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract MultiSender {
    function sendMultiETH(
        address payable[] memory listReceivers,
        uint256[] memory listAmounts
    ) public payable {
        uint256 totalReceivers = listReceivers.length;
        uint256 totalAmounts;
        for (uint256 i = 0; i < totalReceivers; i++) {
            totalAmounts += listAmounts[i];
        }
        require(msg.sender.balance >= totalAmounts, "Total balance not enough");
        require(msg.value == totalAmounts, "Value not enough");
        for (uint256 i = 0; i < totalReceivers; i++) {
            (bool success, bytes memory data) = listReceivers[i].call{
                value: listAmounts[i]
            }("");
            delete data;
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
        address addressERC721,
        address[] memory listReceivers,
        uint256[] memory listTokenId
    ) public returns (bool) {
        require(listReceivers.length == listTokenId.length, "Not same length");

        uint256 totalReceivers = listReceivers.length;
        IERC721 erc721 = IERC721(addressERC721);

        for (uint256 i = 0; i < totalReceivers; i++) {
            require(
                erc721.ownerOf(listTokenId[i]) == msg.sender,
                "Token not owned by sender"
            );
        }

        for (uint256 i = 0; i < totalReceivers; i++) {
            require(
                erc721.getApproved(listTokenId[i]) == address(this),
                "Not approved"
            );
            erc721.transferFrom(msg.sender, listReceivers[i], listTokenId[i]);
        }
        return true;
    }

    function sendMultiERC20(
        address addressERC20,
        address[] memory listReceivers,
        uint256 amount
    ) public returns (bool) {
        uint256 totalReceivers = listReceivers.length;
        IERC20 erc20 = IERC20(addressERC20);
        require(
            erc20.balanceOf(msg.sender) >= totalReceivers * amount,
            "Total balance not enough"
        );

        uint256 allowance = erc20.allowance(msg.sender, address(this));
        require(
            allowance >= totalReceivers * amount,
            "Check the token allowance"
        );
        for (uint256 i = 0; i < totalReceivers; i++) {
            erc20.transferFrom(msg.sender, listReceivers[i], amount);
        }
        return true;
    }
}
