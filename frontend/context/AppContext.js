import { ethers } from "ethers";
import React, { createContext, useEffect, useState } from "react";
import {
  tokenAbi,
  myTokenContractAddress,
  faucetAbi,
  faucetContractAddress,
} from "../utils/constants.js";

export const AppContext = createContext();

const { ethereum } = typeof window !== "undefined" ? window : {};
const POSSIBLE_ERRORS = [
  "ERC20: insufficient allowance",
  "Your next request time is not reached yet",
  "ERC20: transfer amount exceeds balance",
  "requestTokens(): Failed to Transfer",
];

const createContract = (address, contractName) => {
  console.log(address);
  const provider = new ethers.BrowserProvider(window.ethereum);
  const signer = provider.getSigner(address);
  let contract;
  if (contractName == "coin")
    contract = new Contract(myTokenContractAddress, tokenAbi, signer);
  else contract = new Contract(faucetContractAddress, faucetAbi, signer);
  console.log(contract);
  return contract;
};

const AppProvider = ({ children }) => {
  const [account, setAccount] = useState("");
  const [refresh, setRefresh] = useState(0);
  const [message, setMessage] = useState("");
  const [balance, setBalance] = useState(0);
  const [nextBuyTime, setNextBuyTime] = useState(0);
  const [tokenContract, setTokenContract] = useState();
  const [faucetContract, setFaucetContract] = useState();

  const checkErrors = (err) => {
    const error = POSSIBLE_ERRORS.find((e) => err.includes(e));
    console.log(error);
    if (error) {
      setMessage({
        title: "error",
        description: error,
      });
    }
  };

  const checkEthereumExists = () => {
    if (!ethereum) {
      return false;
    }
    return true;
  };
  const getConnectedAccounts = async () => {
    try {
      const accounts = await ethereum.request(
        {
          method: "eth_accounts",
        },
        []
      );
      setAccount(accounts[0]);
    } catch (err) {
      setMessage({ title: "error", description: err.message.split("(")[0] });
    }
  };
  const connectWallet = async () => {
    if (checkEthereumExists()) {
      try {
        const accounts = await ethereum.request(
          {
            method: "eth_requestAccounts",
          },
          []
        );
        console.log(accounts);
        setAccount(accounts[0]);
      } catch (err) {
        setMessage({ title: "error", description: err.message.split("(")[0] });
      }
    }
  };

  const callContract = async (cb) => {
    if (checkEthereumExists() && account) {
      try {
        await cb();
      } catch (err) {
        console.log(err);
        checkErrors(err.message);
      }
    }
  };

  const getBalance = () => {
    callContract(async () => {
      console.log(account, tokenContract);
      let bal = await tokenContract.balanceOf(account);
      console.log(balance);
      setBalance(bal);
    });
  };

  const transfer = (address, amount) => {
    callContract(async () => {
      console.log(account, tokenContract, address, amount);
      let tx = await tokenContract.transfer(address, parseEther(amount));
      await tx.wait();
      setMessage({ title: "success", description: "Transferred Successfully" });
      setRefresh((prev) => prev + 1);
    });
  };
  const approve = async (address, amount) => {
    callContract(async () => {
      let tx = await tokenContract.approve(address, parseEther(amount));
      await tx.wait();
      setMessage({
        title: "success",
        description: "Approved tokens successfully",
      });
    });
  };

  const requestTokens = async () => {
    callContract(async () => {
      let tx = await faucetContract.requestTokens();
      await tx.wait();

      setMessage({
        title: "success",
        description: "Tokens Received successfully",
      });
      setRefresh((prev) => prev + 1);
    });
  };

  const getNextBuyTime = async () => {
    callContract(async () => {
      let nextBuyTime = await faucetContract.getNextBuyTime();
      setNextBuyTime(nextBuyTime.toNumber() * 1000);
    });
  };

  const loadContract = async () => {
    let cc = await createContract(account, "coin");
    let fc = await createContract(account);

    setTokenContract(cc);
    setFaucetContract(fc);
  };

  useEffect(() => {
    if (tokenContract) getBalance();
    if (faucetContract) getNextBuyTime();
  }, [refresh, tokenContract]);
  useEffect(() => {
    console.log(account);
    if (account) {
      loadContract();
    }
  }, [account]);

  useEffect(() => {
    if (checkEthereumExists()) {
      ethereum.on("accountsChanged", getConnectedAccounts);
      getConnectedAccounts();
    }
    return () => {
      if (checkEthereumExists()) {
        ethereum.removeListener("accountsChanged", getConnectedAccounts);
      }
    };
  }, []);
  return (
    <AppContext.Provider
      value={{
        account,
        connectWallet,
        balance,
        transfer,
        approve,
        requestTokens,
        nextBuyTime,
        message,
      }}
    >
      {children}
    </AppContext.Provider>
  );
};

export default AppProvider;
