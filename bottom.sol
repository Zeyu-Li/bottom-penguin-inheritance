pragma solidity ^0.4.0;

contract Inheritance {
    address creator;
    bool isPassOn;
    // total BPC to pass on
    uint totalBPC;

    constructor() public payable {
        creator = msg.sender;
        totalBPC = msg.value;
        isPassOn = false;
    }

    // all the wallets that will get money
    address[] wallets;
    mapping (address => uint) inheritance;

    modifier isCreator {
        require(msg.sender == creator);
        _;
    }

    modifier isPassedOn {
        require(isPassOn == true);
        _;
    }

    // for adding ppl to inheritance
    function init(address _wallet, uint _singleInheritance) public isCreator {
        wallets.push(_wallet);
        inheritance[_wallet] = _singleInheritance;
    }
    // fires when isPassedOn is true
    function fireInheritance() private isPassedOn {
        for (uint i = 0; i < wallets.length; i++) {
            wallets[i].transfer(inheritance[wallets[i]]);
        }
    }

    // passes on inheritance
    function passOn() public isCreator {
        isPassOn = true;
        fireInheritance();
    }

    // undo contract if owner wants to
    function discard() public isCreator {
        creator.transfer(totalBPC);
    }
}
