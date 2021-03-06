require("dotenv").config();
const HDWalletProvider = require('@truffle/hdwallet-provider');
const path = require("path");

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),

  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
    },

    rinkeby: {
      provider: () => new HDWalletProvider({
        mnemonic: process.env.MNEMONIC, 
        providerOrUrl: `https://rinkeby.infura.io/v3/1dcda525e1f447c080bf02091a54fa64`,
        numberOfAddresses: 1,
        shareNonce: true
      }),
      network_id: 4,       // Rinkeby's id
      // gas: 5500000,        // Rinkeby has a lower block limit than mainnet
      // confirmations: 2,    // # of confs to wait between deployments. (default: 0)
      // timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    },
    
    ropsten: {
      provider: () => new HDWalletProvider({
        mnemonic: process.env.MNEMONIC, 
        providerOrUrl: `https://ropsten.infura.io/${process.env.INFURA_API_KEY}`,
        numberOfAddresses: 1,
        shareNonce: true
      }),
      network_id: 3,       // Ropsten's id
      // gas: 5500000,        // Ropsten has a lower block limit than mainnet
      // confirmations: 2,    // # of confs to wait between deployments. (default: 0)
      // timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    }
  },

  compilers: {
    solc: {
      version: "pragma",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {          // See the solidity docs for advice about optimization and evmVersion
      //  optimizer: {
      //    enabled: false,
      //    runs: 200
      //  },
        evmVersion: "berlin"
      }
    }
  }
};
