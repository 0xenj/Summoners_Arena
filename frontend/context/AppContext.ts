import { ethers } from "ethers";
import React, { createContext, useEffect, useState, ReactNode } from "react";
import {
    tokenAbi,
    myTokenContractAddress,
    faucetAbi,
    faucetContractAddress,
} from "../utils/constants";

interface IAppContext {
  account: string;
  connectWallet: () => Promise<void>;
  balance: number;
  transfer: (address: string, amount: string) => void;
  approve: (address: string, amount: string) => Promise<void>;
  requestTokens: () => Promise<void>;
  nextBuyTime: number;
  message: { title: string; description: string };
}

export const AppContext = createContext<IAppContext | null>(null);

declare let window: {
  ethereum: any;
};

const POSSIBLE_ERRORS = [
  "ERC20: insufficient allowance",
  "Your next request time is not reached yet",
  "ERC20: transfer amount exceeds balance",
  "requestTokens(): Failed to Transfer",
];

const createContract = (address: string, contractName?: string) => {
  console.log(address);
  const provider = new ethers.providers.JsonRpcProvider();
  const signer = provider.getSigner(address);
  let contract;
  if (contractName === "coin")
    contract = new ethers.Contract(myTokenContractAddress, tokenAbi, signer);
  else
    contract = new ethers.Contract(faucetContractAddress, faucetAbi, signer);
  console.log(contract);
  return contract;
};

interface AppProviderProps {
  children: ReactNode;
}

const AppProvider: React.FC<AppProviderProps> = ({ children }) => {
  const [account, setAccount] = useState<string>("");
  // ... rest of your state declarations

  // ... rest of your functions with added type annotations

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
