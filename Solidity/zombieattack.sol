// Defining solidity version to be used
pragma solidity >=0.5.0 <0.6.0;

// import zombiehelper.sol for inheriting this contract from zombie helper
import "./zombiehelper.sol";

// Self made contract named zombieattack to handle zombie combats
contract ZombieAttack is ZombieHelper {
  uint randNonce = 0;                       // to get count of random generated numbers
  uint attackVictoryProbability = 70;       // win probability above this win below this loss

  // function generating random number between 0-99 because of _modulus
  function randMod(uint _modulus) internal returns(uint){
    randNonce++;                            // increamenting the ranNonce to pass new key everytime for new random number
    return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
  }

  // function to calculate win loss or do attack
  function attack (uint _zombieId, uint _targetId) external ownerOf(_zombieId){
    Zombie storage myZombie = zombies[_zombieId];                                   // storing reference to my zombie
    Zombie storage enemyZombie = zombie[_targetId];                                 // storing reference to enemy zombie
    uint rand = randMod(100);                                                       // generating a random attack amount
    if(rand <= attackVictoryProbability) {                                          // checking if we win/loss
      myZombie.winCount++;                                                          // incrementing my win count cause i win
      myZombie.level++;                                                             // incrementing my level cause i win 
      enemyZombie.lossCount++;                                                      // incrementing enemy's loss count cause they loss
      feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");                        // create a new zombie based on the attack
    }
    else {
      myZombie.lossCount++;                                                         // incrementing my loss count cause i loss
      enemyZombie.winCount++;                                                       // incrementing enemy win count cause they won
      _triggerCooldown(myZombie);                                                   // trigger cooldown even if i loss
    }
  }
}