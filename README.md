[![Build Status](https://travis-ci.org/Bitsino/BitsinoDice.svg?branch=master)](https://travis-ci.org/Bitsino/BitsinoDice)

## Bitcoin Dice Gambling Site


![](http://i.imgur.com/BY4bmB3.png)

## Provably Fair

Bitcoinary implements a provably fair gaming engine. Provably fair works by publishing the hash of a secret before a game. At the end of the day, the secret is released and can be compared to the result. Publishing the hash of the secret prevents the operator from changing the secret and by extension, the result of the game.

## Installation

Live demonstration https://bitsinodice.com

Bitcoinary is designed to install easily into the cloud using Heroku. You can also install to your own server.

Click the link below to install the software directly to Heroku.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/onchain/bitcoinary)

## Security

### BitsinoDice does not require you to install bitcoind

Bitcoinary uses the chain.com API to get balance information and to scan for incoming Bitcoins. As no private keys are kept on the site we remove some major security issues.

### Cold storage and multi signature funds.

The site works off a Bitcoin master public key. Bitcoinary can then generate as many bitcoin public keys as it needs. ONCHAIN.IO which is the cold storage provider sweeps and incoming bitcoins daily into a bitcoin transaction. You can then safely sign this transaction to send the funds into cold storage.

There are no private keys on ONCHAIN.IO or Bitcoinary.

Bitcoinary makes a daily payout request to ONCHAIN.IO. Basically for users who are winners they can select to withdraw funds. Bitcoinary sends a payout request to ONCHAIN.IO which is turned into a bitcoin transaction paying the users.

You get a notification from ONCHAIN.IO and can decide wether or not to sign this transaction.

