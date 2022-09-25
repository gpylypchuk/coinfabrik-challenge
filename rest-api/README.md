# REST API ✨

### This is a Rest-API for ETHPool contract
> The API only contains requirements sent by Coinfabrik

## How to Run

> Be sure you have a self-custodial wallet (e.g [Metamask](https://metamask.io/)) and a RPC endpoint (e.g [Infura](https://infura.io/))

1. Create a virtual environment and activate it (e.g in Windows is `virtualenv venv` and then `source ./env/Scripts/activate`)
2. Install dependencies: `pip install flask web3 dotenv`
4. Fill the environment variables like `.env.example` (create a `.env` file)
3. Run the API with `py ./src/app.py`

## Body Example (POST)

> To interact with the API you can use [Postman](https://www.postman.com/), [Insomnia](https://insomnia.rest/) or a library like [Axios](https://axios-http.com/docs/intro) in Javascript/Typescript. 

#### Deposit Ether

```
{
  "public-key": "0xC77cFd0BD7841F4b76D6e9A154A879a1154d5C1B",
  "private-key': "afdfd9c3d2095ef696594f6cedcae59e72dcd697e2a7521b1578140422a4f890",
  "amount": 1
}
```
