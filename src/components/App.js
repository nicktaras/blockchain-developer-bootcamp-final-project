import React, { Component } from 'react';
import Web3 from 'web3';
import BlindDate from '../abis/BlindDate.json';
import './App.css';

// App Demo:
// 1. Connect to Ganache (Done)
// 2. Create Profile button
// 3. Trigger Create Date function

class App extends Component {

  constructor(props) {
    super(props);
    this.state = {
      account: 'undefined',
      contract: null,
      profile: false,
      dates: []
    }
  }

  // load web3 on mount of react component
  async componentDidMount() {
    await this.loadWeb3()
  }

  // load data from blockchain related to users wallet address
  async loadWeb3() {
    if(window.ethereum) {
      window.web3 = new Web3(window.ethereum);
      await window.ethereum.enable();
      this.loadBlockChainData();
    } else if(window.web3) {
      window.web3 = new Web3(window.web3.currentProvider);
      this.loadBlockChainData();
    } else {
      window.alert('ethereum is not available.');
    }
  }

  async loadBlockChainData() {
    const web3 = window.web3;
    const accounts = await web3.eth.getAccounts();
    this.setState({ account: accounts[0]});
    console.log('acc', accounts);
    const networkId = 5777; // TODO await web3.eth.net.getId();
    const networkData = BlindDate.networks[networkId];
    if(networkData){
      const abi = BlindDate.abi;
      const address = networkData.address;
      const contract = new web3.eth.Contract(abi, address);
      this.setState({ contract });

      // get profile

      // function getProfile(address profileAddress) external view returns (Profile memory){
      // const request = this.state.contract.methods.getProfile(this.state.account);
      
      const profile = await contract.methods.getProfile(this.state.account).call();
      if(profile) {
        // add date info:
        const dates = await Promise.all(profile.dates.map((dateIndex) => {
          return contract.methods.getDate(Number(dateIndex)).call();
        }));
        this.setState({ profile, dates });
      }
    }
  }

  // send profile as param
  createProfile = () => {
    this.state.contract.methods.addProfile(
      'https://storage.opensea.io/files/0a6b745d1d8eb31917cd7b1ad368c457.svg',
      'junky222',
      1,
      1,
      'oz',
      1,
      [0, 1, 2, 3, 4] // BUG FIX ME - Must enforce number of values.
    )
    // this.state.contract.methods.addProfile(
    //   'https://pbs.twimg.com/profile_images/1452412851163852800/vPriFNyn_400x400.jpg',
    //   'punky222',
    //   1,
    //   1,
    //   'oz',
    //   1,
    //   [0, 1, 2, 3, 4] // BUG FIX ME - Must enforce number of values.
    // )
    .send({ from: this.state.account })
    .once('transactionHash', (hash) => { 
      console.log('hash', hash);
    })
    .once('receipt', (receipt) => { 
      console.log('receipt ', receipt);
    })
    .on('confirmation', (confNumber, receipt) => { 
      console.log('confirmation ', confNumber, receipt);
     })
    .on('error', (error) => { 
      console.log('err', error);
     })
    .then((profile) => {
      // this.setState({ profile: [...this.state.profile, profileFromParams] });
    });
  }
  
  addDate = (date, msg) => {
    this.state.contract.methods.addDate(
      date,
      msg
    )
    .send({ from: this.state.account })
    .once('transactionHash', (hash) => { 
      console.log('hash', hash);
    })
    .once('receipt', (receipt) => { 
      console.log('receipt ', receipt);
    })
    .on('confirmation', (confNumber, receipt) => { 
      console.log('confirmation ', confNumber, receipt);
     })
    .on('error', (error) => { 
      console.log('err', error);
     })
    .then(() => {
      this.setState({ dates: [...this.state.dates, { date, msg }] });
    });
  }

  datesMarkup = () => { 
    return this.state.dates.map((date, index) => {
      return `<button>date ${index}<button>`;
    });
  };

  render() {
    return (
      <div>
        <nav className="navbar navbar-dark bg-dark p-0 shadow">
          <div>
            <a
              className="navbar-brand col-sm-3 col-md-4 mr-0"
              href=""
              target="_blank"
              rel="noopener noreferrer"
            >
              Blind Date
            </a>
          </div>
        </nav>
        <div style={{ padding: '5px', margin: '20px', border: '1px solid black' }}>
          <button onClick={e => this.createProfile()}>Add Profile</button> <small>Adds mock profile to dapp</small>
        </div>
        { this.state.profile.active &&
          <div style={{ padding: '5px', margin: '20px', border: '1px solid black' }}>
            <img width="100px" src={ this.state.profile.nftImage }></img>
            <div style={{ padding: '5px', margin: '12px 0' }}>
              <p>Status: { this.state.profile.active ? 'active' : 'deactivated' }</p>
              <p>Name: { this.state.profile.name }</p>
              <p>Age Range: { this.state.profile.ageRange }</p>
              <p>Location: { this.state.profile.location }</p>
              <p>Preference: { this.state.profile.preference }</p>
              <p>sex: { this.state.profile.sex }</p>
              {/* <p>Values: { this.state.profile.values }</p> */}
              <div dangerouslySetInnerHTML={{__html: this.datesMarkup()}}></div>
            </div>
          </div> 
        }
        <div style={{ padding: '5px', margin: '20px', border: '1px solid black' }}>
          Find a date:
        </div>
        <div style={{ padding: '5px', margin: '20px', border: '1px solid black' }}>
          <button onClick={e => this.addDate('0xd0758718e62f9D8DC332a8AF5C23fC169afED027', 'Hi there good lookin...')}>Add Date</button> <small>Mock date</small>
        </div>
      </div>
    );
  }
}

export default App;
