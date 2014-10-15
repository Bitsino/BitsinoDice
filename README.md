## Bitcoin Dice Gambling Site

![](http://i.imgur.com/8hU1K2e.png)

## Installation

Bitcoinary is designed to install easily into the cloud using Heroku. You can also install to your own server.

## Security

### Bitcoinary does not require you to install bitcoind

Bitcoinary uses the chain.com API to get balance information and to scan for incoming Bitcoins. As no private keys are kept on the site we remove some major security issues.

### Cold storage and multi signature funds.

The site works off a Bitcoin master public key. Bitcoinary can then generate as many bitcoin public keys as it needs. ONCHAIN.IO which is the cold storage provider sweeps and incoming bitcoins daily into a bitcoin transaction. You can then safely sign this transaction to send the funds into cold storage.

There are no private keys on ONCHAIN.IO or Bitcoinary.

Bitcoinary makes a daily payout request to ONCHAIN.IO. Basically for users who are winners they can select to withdraw funds. Bitcoimnary sends a payout request to ONCHAIN.IO which is turned into a bitcoin transaction paying the users.

You get a notification from ONCAHIN.IO and can decide wether or not to sign this transaction.

