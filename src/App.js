import React, { useState, useEffect } from 'react';
import './App.css';
import Web3 from 'web3';
import contract from './Tickets.json';

const contractAddress = "0x8bc7beA247441974d52FA3A625816363ddbF2277";
const abi = contract.abi;

function App() {
	// const [minted, setMinted] = useState(false);
	// const [balance, setBalance] = useState(0);
  const [currentAccount, setCurrentAccount] = useState(null);

	// const mint = () => {
	// 	mintToken()
	// 		.then((tx) => {
	// 			console.log(tx);
	// 			setMinted(true);
	// 		})
	// 		.catch((err) => {
	// 			console.log(err);
	// 		});
	// };
/*
	const fetchBalance = () => {
		getOwnBalance()
			.then((balance) => {
				setBalance(balance);
			})
			.catch((err) => {
				console.log(err);
			});
	};
*/
  const checkWalletIsConnected = async () => { 
    const { ethereum } = window;

    if (!ethereum) {
      console.log("Please ensure you have MetaMask installed.");
      return;
    } else {
      console.log("Wallet exists!");
    }

    const accounts = await ethereum.request({ method: 'eth_accounts' });

    if (accounts.length !== 0) {
      const account = accounts[0];
      console.log("Found an authorized account: ", account);
      setCurrentAccount(account);
    } else {
      console.log("No authorized account found");
    }
  }

  const connectWalletHandler = async () => {
    const { ethereum } = window;

    if(!ethereum) {
      alert("Please install MetaMask.");
    }

    try {
      const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
      console.log("Found an address! Address: ", accounts[0]);
      setCurrentAccount(accounts[0]);
    } catch (err) {
      console.log(err);
    }
  }

  const mintNftHandler = async () => {
    try {
      const { ethereum } = window;

      if (typeof window.ethereum !== 'undefined') {
        const web3 = new Web3(Web3.givenProvider); 
        const signer = web3.eth.accounts.create();
        const ticketContract = new web3.eth.Contract(abi, contractAddress);

        console.log("Initialize payment");
        let ticketTxn = await ticketContract.methods.buyTickets(3);

        console.log("Minting...please wait");
        //await ticketTxn.wait();

        console.log(`Mined, see transaction: https://rinkeby.etherscan.io/tx/${ticketTxn.hash}`);
      } else {
        console.log("Ethereum object does not exist");
      }
    } catch (err) {
      console.log(err);
    }
  }

  const connectWalletButton = () => {
    return (
      <button onClick={connectWalletHandler} className='cta-button connect-wallet-button'>
        Connect Wallet
      </button>
    )
  }

  const buyTicketButton = () => {
    return (
      <button onClick={mintNftHandler} className='cta-button mint-nft-button'>
        Purchase Ticket
      </button>
    )
  }

  useEffect(() => {
    checkWalletIsConnected();
  }, [])

	return (
		<div className="main-app">
      <h1>Earners On Chain 1 Year Aniversary</h1>
			{currentAccount ? buyTicketButton() : connectWalletButton()}
		</div>
	);
}

export default App;