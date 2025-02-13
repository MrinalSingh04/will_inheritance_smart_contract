# Decentralized Will & Inheritance System

## 📌 Project Overview

The **Decentralized Will & Inheritance System** is a smart contract that automates the distribution of assets upon the owner's inactivity for a predefined period. This removes the need for intermediaries like lawyers and ensures a **trustless, secure, and automated** inheritance process.

## 🎯 Features

- **Decentralized Will Creation** – Define beneficiaries and their asset allocation.
- **Proof-of-Life Mechanism** – Owner must check in periodically to confirm activity.
- **Automated Fund Distribution** – If the owner is inactive beyond the threshold, assets are transferred to beneficiaries.
- **Tamper-Proof & Trustless** – Once executed, the will cannot be altered.
- **ETH Deposits** – The contract holds and distributes Ether upon execution.

## 🛠 Tech Stack

- **Solidity** – Smart contract development.
- **Ethereum Blockchain** – Secure execution of inheritance logic.
- **Ethers.js** – Frontend integration (optional).
- **Chainlink Keepers** (Optional) – Automate inactivity checks.

## 🚀 How It Works

### 1️⃣ Deploy the Contract

- Set the `_inactivityThreshold` in seconds (e.g., 6 months = `15552000` seconds).

### 2️⃣ Deposit Funds

- Send ETH to the contract address to be distributed later.

### 3️⃣ Define Beneficiaries

- Call `updateWill(address[], uint256[])` with:
  - A list of beneficiary addresses.
  - Corresponding percentage shares (must total 100%).

### 4️⃣ Owner Must Check-In

- The owner must call `confirmActivity()` before the inactivity threshold expires to reset the timer.

### 5️⃣ If the Owner Becomes Inactive

- Any user can call `distributeFunds()`, which:
  - Divides and transfers ETH to beneficiaries.
  - Marks the will as executed.

## 📜 Smart Contract Functions

### **👤 Owner Functions**

- `updateWill(address[], uint256[])` – Define or update beneficiaries and allocation.
- `confirmActivity()` – Updates the last check-in timestamp.

### **⏳ Inactivity Handling**

- `distributeFunds()` – Checks if the owner is inactive and distributes assets.
- `receive()` – Allows the contract to receive ETH deposits.

## Here’s the text-based flowchart for your Decentralized Will & Inheritance System:

            +----------------------+
            |  Owner Deploys Contract  |
            |  (Sets Beneficiaries)   |
            +----------------------+
                      |
                      v
            +----------------------+
            |  Owner Calls confirmActivity()  |
            |  (To Confirm They Are Active)  |
            +----------------------+
                      |
                      v
            +----------------------+
            |  Timer Starts        |
            |  (Based on inactivity threshold) |
            +----------------------+
                      |
          +----------+----------+
          |                     |
          v                     v
  +----------------+      +----------------+
  | Owner Calls    | Yes  | Timer Expires  |
  | confirmActivity() | --> | (Owner Inactive) |
  +----------------+      +----------------+
                                    |
                                    v
                          +----------------------+
                          | Any User Calls       |
                          | distributeFunds()    |
                          +----------------------+
                                    |
                                    v
                          +----------------------+
                          | Smart Contract       |
                          | Transfers Assets     |
                          +----------------------+
                                    |
                                    v
                          +----------------------+
                          | Beneficiaries Can    |
                          | Withdraw Their Share |
                          +----------------------+
How It Works?
1️⃣ Owner deploys contract and registers beneficiaries.
2️⃣ Owner must check in periodically by calling confirmActivity().
3️⃣ If owner is inactive beyond the threshold, the timer expires.
4️⃣ Any user can trigger distributeFunds(), executing the will.
5️⃣ Smart contract automatically transfers assets to beneficiaries.
6️⃣ Beneficiaries can withdraw their inheritance.

## 🔐 Security Considerations

- **Owner must check in periodically** to prevent unintended fund distribution.
- **Total percentage must be 100%** when setting beneficiaries.
- **Funds are locked until execution** – No early withdrawals.

## 📦 Deployment & Testing

1. Deploy the contract via **Remix, Hardhat, or Foundry**.
2. Fund the contract with ETH.
3. Set beneficiaries and percentages.
4. Call `confirmActivity()` periodically.
5. Test `distributeFunds()` by simulating inactivity.

## 📜 License

This project is released under the **MIT License**.

## 🤝 Contributing

Pull requests and suggestions are welcome! Feel free to improve or extend functionality.
