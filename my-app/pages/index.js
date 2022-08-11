import { BigNumber, providers, utils } from "ethers";
import { useEffect, useRef, useState } from 'react';
import Web3Modal from "web3modal";

export default function Home() {
  const [walletConnected, setWalletConnected] = useState(false);
  const web3ModalRef = useRef();

  const connectWallet = async () => {
    try {
      await getProviderOrSigner();
      setWalletConnected(true);
    } catch (err) {
      console.error(err);
    }
  }

  const getProviderOrSigner = async (needSigner = false) => {
    const provider = await web3ModalRef.current.connect();
    const web3Provider = new providers.Web3Provider(provider);

    const {chainId} = await web3Provider.getNetwork();
    if(chainId !== 4) {
      window.alert("Change network to rinkeby");
      throw new Error("Change the network to rinkeby");
    }

    if(needSigner) {
      const signer  = web3Provider.getSigner();
      return signer;
    }
    return web3Provider;
  };

  
  useEffect(() => {
    if(!walletConnected) {
      web3ModalRef.current = new Web3Modal({
        network: "rinkeby",
        providerOptions: {},
        disableInjectedProvider: false,
      });
      connectWallet();
      // getAmounts();
    }
  }, []);



  return (
    <div>Feroihgu</div>

  )
}
