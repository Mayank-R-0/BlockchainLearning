// Defining solidity version to be used
pragma solidity >=0.5.0 <0.6.0;

// Importing ownable.sol to setup ownership of contract
import "./ownable.sol";

// Self made contract named zombie factory
contract ZombieFactory is Ownable{

    // Variable Declaration
    uint dnaDigits = 16;              // defining the number of digits a dna should be of
    uint dnaModulus = 10**dnaDigits;  // storing dna digits
    uint cooldownTime = 1 days;

    // Event Declaration
    event NewZombie(uint zombieId, string name, uint dna);      // Event dispatcher to inform the UI about the contract update

    // Structure Declaration    
    struct Zombie {  // Storing zombies data
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
    }

    // Zombie array to store all zombies created
    Zombie[] public zombies;

    // Mapping Declaration
    mapping (uint => address) public zombieToOwner;    // store information about which zombie is assigned to which owner
    mapping (address => uint) ownerZombieCount;        // store information of how many zombies a single account address holds

    // Function will created a new zombie based on name and dna
    function _createZombie(string memory _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime))) - 1;                  // Adding newly created zombie to the list of zombies 
        // msg.sender contains blockchain address that calls this contract method
        zombieToOwner[id] = msg.sender;                                   // Assigning zombie to particular blockchain address that has called this function
        ownerZombieCount[msg.sender]++;                                   // Incrementing count of zombies with this address
        emit NewZombie(id, _name, _dna);                                  // Informing the outside world/UI about contract update
    }

    // Function will generate a 16 digit random DNA for the zombie
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));              // Generating a 256 bytes 16 digit random number based on passed zombie name
        return rand % dnaModulus;                                         
    }

    // Public function to call to create the zombie should be called from the outside code (JS, C#, C++)
    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);                       // need to check that a single account can only create one zombie at start
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);        
    }

}