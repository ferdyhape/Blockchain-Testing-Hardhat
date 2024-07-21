// scripts/deploy.js
async function main() {
  // Get the ContractFactory and Signers
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  // Compile the contract and get the ContractFactory
  const TokenContract = await ethers.getContractFactory("TokenContract");

  // Deploy the contract
  const tokenContract = await TokenContract.deploy();

  console.log("TokenContract deployed to:", tokenContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
