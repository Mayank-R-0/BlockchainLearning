// Defining solidity version to be used
pragma solidity >=0.5.0 <0.6.0;

// import other contract files into this
import "./zombiefactory.sol";

// Interface to connect to crypto kitties contract functions
contract KittyInterface {
    function getKitty(uint256 _id) external view returns(
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );
}

// Self made contract named zombie feeding inherits from zombie factory
// This contract will help in feeding the zombies some kitties and make them a fused zombie that contains characterstics of kitties and zombies
contract ZombieFeeding is ZombieFactory {

    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;          // crypto kitties contract address on the block chain
    KittyInterface kittyContract = KittyInterface(ckAddress);                // connecting to crypto kitties contract

    // function responsible to feed the zombies a kitty and make fused zombie 
    function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
        require(msg.sender == zombieToOwner[_zombieId]);                  // check only the owner can feed the zombie
        Zombie storage myZombie = zombies[_zombieId];                     // storing the zombie reference to update its properties
        _targetDna = _targetDna % dnaModulus;                             // limiting the kitty dna to be of 16 characters
        uint newDna = (myZombie.dna + _targetDna) / 2;                    // generating new dna based on the average of both zombei and kitty address
        if(keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))){           // check the fuse happen only with kitty
            newDna = newDna - newDna % 100 + 99;                                                     // adding 99 at the end of new dna to know its kitty fuse
        }
        _createZombie("NoName", newDna);                                   // call to create new zombie based on fusion
    }

    // function to feed the kitty to zombie
    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);            // the address of kitty stored in genes of the kitty
        feedAndMultiply(_zombieId, kittyDna, "kitty");                     // feeding kitty genes to the zombie and creating a fused zombie
    }

}