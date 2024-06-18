// Defining solidity version to be used
pragma solidity >=0.5.0 <0.6.0;

// import zombiefeeding.sol for inheriting this contract from zombie feeding
import "./zombiefeeding.sol";

// Self made contract named zombiehelper for helping function
contract ZombieHelper is ZombieFeeding {

  // modifier method to check if zombie level is above that certain level
  modifier aboveLevel(uint _level, uint _zombieId){
    require(zombies[_zombieId].level >= _level);
    _;
  }

  // Giving user a chance to modify the name of thier zombie if its level is above 2
  function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
  }

  // Giving user a chance to modify the dna of thier zombie if its level is above 20
  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
  }

  // function to get the list of zombies owned by the user
  function getZombiesByOwner(address _owner) external view returns (uint[] memory) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);                 // initialize empty array
    uint counter = 0;                                                            // initialize a counter
    for (uint i = 0; i < zombies.length; i++) {                                  // for loop to get the zombies owned by user
      if(zombieToOwner[i] == _owner){                                            // check that zombie belongs to owner
        result[counter] = i;                                                     // adding that zombie to array
        counter++;                                                               // increamenting the counter
      }
    }
    return result;
  }

}