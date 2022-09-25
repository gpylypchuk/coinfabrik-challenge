from web3.gas_strategies.rpc import rpc_gas_price_strategy
from flask import Flask, jsonify, request
from dotenv import load_dotenv
from web3 import Web3
import os, json

load_dotenv()

app = Flask(__name__)

CONTRACT = os.getenv('CONTRACT')
PROVIDER = os.getenv('URL_PROVIDER')
ROOT = os.getenv('DIR')

# Get Shares held by Address (GET)
@app.route('/pool/shares/<string:address>')
def getSharesHeld(address):
    w3 = Web3(Web3.HTTPProvider(PROVIDER))

    abi = json.load(open(ROOT + 'pool.json'))
    deployed_contract = w3.eth.contract(address=CONTRACT, abi=abi)

    result = jsonify({
        'Shares': deployed_contract.functions.share(address).call()
    })

    return result

# Deposit Ether in Pool (POST)
@app.route('/pool/deposit', methods=['POST'])
def deposit():
    w3 = Web3(Web3.HTTPProvider(PROVIDER))

    abi = json.load(open(ROOT + 'pool.json'))
    deployed_contract = w3.eth.contract(address=CONTRACT, abi=abi)

    data = {
        'public-key': request.json['public-key'],
        'private-key': request.json['private-key'],
        'amount': request.json['amount']
    }

    tx = deployed_contract.functions.deposit().buildTransaction({'nonce': w3.eth.getTransactionCount(data['public-key']), 'value': data['amount']})

    signed_tx = w3.eth.account.signTransaction(tx, private_key=data['private-key'])

    tx_hash = w3.eth.sendRawTransaction(signed_tx.rawTransaction)

    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)

    result = jsonify({
        'Transaction Hash': f'Transaction successful with hash: {tx_receipt.transactionHash.hex()}'
    })

    return result
    
# Local Node with Hardhat

# Get Balance of Address (GET)
@app.route('/pool/balance/<string:address>')
def getBalance(address):
    w3 = Web3(Web3.HTTPProvider('http://127.0.0.1:8545'))

    balance = w3.fromWei(w3.eth.get_balance(address), 'ether')

    result = jsonify({
        'Balance': f'{balance} Ethers'
    })

    return result

# Transfer Balance between Addresses (POST)
@app.route('/pool/transfer/', methods=['POST'])
def transferBalance():
    w3 = Web3(Web3.HTTPProvider('http://127.0.0.1:8545'))
    w3.eth.set_gas_price_strategy(rpc_gas_price_strategy)

    data = {
        'from-public-key': request.json['from-public-key'],
        'from-private-key': request.json['from-private-key'],
        'to-public-key': request.json['to-public-key'],
        'amount': request.json['amount']
    }

    tx_create = w3.eth.account.sign_transaction(
        {
            "nonce": w3.eth.get_transaction_count(data['from-public-key']),
            "gasPrice": w3.eth.generate_gas_price(),
            "gas": 21000,
            "to": data['to-public-key'],
            "value": w3.toWei(data['amount'], "ether"),
        },
        data['from-private-key'],
    )

    tx_hash = w3.eth.send_raw_transaction(tx_create.rawTransaction)
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)

    result = jsonify({
        'Transaction Hash': f'Transaction successful with hash: {tx_receipt.transactionHash.hex()}'
    })

    return result

if __name__ == '__main__':
    app.run(debug=True, port=4000)