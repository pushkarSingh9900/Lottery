// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    address public manager;
    address payable[] public players;
    address payable public winner;

    constructor() {
        manager = msg.sender;
    }

    function participate() public payable {
        require(msg.value == 1 ether, "Please pay 1 ether");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public {
        require(players.length >= 3, "Not enough players");

        uint index = random() % players.length;
        winner = players[index]; 
        winner.transfer(getBalance());
        players = new address payable[](0);
    }
}
