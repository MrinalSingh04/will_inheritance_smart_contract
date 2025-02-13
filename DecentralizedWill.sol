// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title DecentralizedWill
 * @dev A smart contract to automate inheritance distribution when the owner becomes inactive.
 */
contract DecentralizedWill {
    address public owner; // Address of the will creator (owner of assets)
    uint256 public lastCheckIn; // Timestamp of the owner's last activity
    uint256 public inactivityThreshold; // Time limit (in seconds) before inheritance is triggered

    struct Beneficiary {
        address payable wallet; // Address of the beneficiary
        uint256 percentage; // Percentage of total assets they should receive
        bool hasClaimed; // Whether the beneficiary has already claimed their share
    }

    Beneficiary[] public beneficiaries; // List of all beneficiaries
    bool public willExecuted; // Flag to track if the will has already been executed

    event WillUpdated();
    event CheckIn(address indexed owner, uint256 timestamp);
    event FundsDistributed(uint256 totalAmount);
    event BeneficiaryClaimed(address indexed beneficiary, uint256 amount);

    // Restricts function access to only the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    // Ensures the contract executes only if the owner is inactive beyond the threshold
    modifier onlyIfInactive() {
        require(
            block.timestamp > lastCheckIn + inactivityThreshold,
            "Owner is still active"
        );
        require(!willExecuted, "Will already executed");
        _;
    }

    /**
     * @dev Constructor sets the owner and inactivity threshold.
     * @param _inactivityThreshold Time in seconds after which inheritance is triggered if the owner is inactive.
     */
    constructor(uint256 _inactivityThreshold) payable {
        owner = msg.sender;
        lastCheckIn = block.timestamp; // Initialize with deployment time
        inactivityThreshold = _inactivityThreshold;
    }

    /**
     * @dev Allows the owner to set or update their beneficiaries.
     * @param _beneficiaries List of beneficiary addresses.
     * @param _percentages Corresponding percentages of assets to be allocated to each beneficiary.
     */
    function updateWill(
        address payable[] memory _beneficiaries,
        uint256[] memory _percentages
    ) external onlyOwner {
        require(
            _beneficiaries.length == _percentages.length,
            "Mismatched arrays"
        );
        require(_beneficiaries.length > 0, "At least one beneficiary required");

        delete beneficiaries; // Clear previous beneficiary list
        uint256 totalPercentage = 0;

        // Loop through each beneficiary to store their details
        for (uint256 i = 0; i < _beneficiaries.length; i++) {
            beneficiaries.push(
                Beneficiary({
                    wallet: _beneficiaries[i],
                    percentage: _percentages[i],
                    hasClaimed: false
                })
            );
            totalPercentage += _percentages[i]; // Sum up percentages
        }

        require(totalPercentage == 100, "Total percentage must be 100%"); // Ensure valid percentage distribution
        emit WillUpdated();
    }

    /**
     * @dev Owner must periodically call this function to confirm they are still active.
     */
    function confirmActivity() external onlyOwner {
        lastCheckIn = block.timestamp; // Update the last check-in time
        emit CheckIn(msg.sender, lastCheckIn);
    }

    /**
     * @dev Distributes the funds to beneficiaries if the owner is inactive.
     * Can be called by anyone once the inactivity threshold is reached.
     */
    function distributeFunds() external onlyIfInactive {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No funds to distribute");

        willExecuted = true; // Mark will as executed
        emit FundsDistributed(contractBalance);

        // Loop through each beneficiary and transfer their share
        for (uint256 i = 0; i < beneficiaries.length; i++) {
            uint256 amount = (contractBalance * beneficiaries[i].percentage) /
                100;
            beneficiaries[i].wallet.transfer(amount);
            beneficiaries[i].hasClaimed = true;
            emit BeneficiaryClaimed(beneficiaries[i].wallet, amount);
        }
    }

    /**
     * @dev Allows the contract to receive ETH deposits.
     */
    receive() external payable {}
}
