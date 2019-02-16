# Deploy hello contract and test it.
# Author: Kumo Lam(https://github.com/Kumo-YZX)
# History: Feb/16/2019 Created

echo "DepHello.sh: Deploy hello contract and test it."
echo "You should create [hello] contract account first."

#
cp -r hello ~/eos/contracts

cd ~/eos/contracts/hello

eosio-cpp -o hello.wasm hello.cpp --abigen

# To make sure that contract account is created.

cleos set contract hello ~/eos/contracts/hello \
-p hello@active

# read -p "Input the accoount you want to transfer to: " receiver

# cleos push action hello hi '[\"\"]'