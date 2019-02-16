# Create Walltes & Accounts for development
# Author: Kumo Lam
# History: Feb/16/2019 Updated
# Mark: Add some reminders.

echo "CreAcc.sh: Create Wallets and Accounts"

read -p "Do you want to create a new wallet?(Y/N): " new_wallet_flag
read -p "Name of the wallet(required in each mode): " wallet_name

# Create wallet
# Need to set a automatic creaction for wallet&account folder.
if [ "$new_wallet_flag" = "Y" -o "$new_wallet_flag" = "y" ]; then
    touch ~/eos/wallet/"${wallet_name}.wallet.key"

    cleos wallet create --name "$wallet_name" --to-console | \
    tail -n 1 | cut -c 2-54 1>> ~/eos/wallet/"${wallet_name}.wallet.key"

    wallet_key=`cat ~/eos/wallet/${wallet_name}.wallet.key`
    echo "Wallet key(saved): ${wallet_key}"

    #Open and unlock the wallet
    cleos wallet open --name "$wallet_name"
    cleos wallet unlock --name "$wallet_name" --password "$wallet_key"

    # Import development key when a new wallet is created.
    develop_key=`cat ~/eos/account/development.account.key`
    cleos wallet import --name "$wallet_name" \
    --private-key "$develop_key"
else
    echo "Do not create wallet"
    wallet_key=`cat ~/eos/wallet/${wallet_name}.wallet.key`

    cleos wallet open --name "$wallet_name"
    cleos wallet unlock --name "$wallet_name" --password "$wallet_key"
fi

# Create accounts
# Need to add more actions.
while [ 0 -eq 0 ]
do
    read -p "Name of the account(end to exit):" account_name
    if [ "$account_name" = "end" ]; then
        break
    fi

    read -p "Is this account a contract account(Y/N): " con_acc_flag

    touch ~/eos/account/"${account_name}.account.ownkey"
    touch ~/eos/account/"${account_name}.account.actkey"
    cleos wallet create_key --name "$wallet_name" | \
    cut -c 48-100 1>> ~/eos/account/"${account_name}.account.ownkey"
    cleos wallet create_key --name "$wallet_name" | \
    cut -c 48-100 1>> ~/eos/account/"${account_name}.account.actkey"

    account_ownerkey=`cat ~/eos/account/${account_name}.account.ownkey`
    account_activekey=`cat ~/eos/account/${account_name}.account.actkey`

    echo "Account Name: ${account_name}"
    echo "Owner Key: ${account_ownerkey}"
    echo "Active Key: ${account_activekey}"

    if [ "$con_acc_flag" = "Y" -o "$con_acc_flag" = "y" ]; then
        cleos create account eosio "$account_name" \
        "$account_ownerkey" "$account_activekey" -p eosio@active && \
        echo "Succeed to create account ${account_name}" || \
        echo "Failed to create account ${account_name}"
    else
        cleos create account eosio "$account_name" \
        "$account_ownerkey" "$account_activekey" && \
        echo "Succeed to create account ${account_name}" || \
        echo "Failed to create account ${account_name}"
    fi
done
