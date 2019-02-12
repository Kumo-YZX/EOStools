# Create keosd & nodeos Environment
# Author: Kumo Lam
# History: Feb/12/2019 Created

echo "CreEnv Script: to create keosd and nodeos environment on your device."

echo "Which Step(s) do you want to execute?"
read -p "Please input the Step parameter: " step_parameter
step_weight=128

echo "Step Parameter: ${step_parameter}; Step Weight:${step_weight}"

# Step 7
if [ $(($step_parameter/$step_weight)) -ne 0 ]; then
    echo "Step 7: Download the Source file"
    read -p "Which source do you want to use? Local/Online(L/O): " source_tag

    # source_name="eosio_1.5.0-1-ubuntu-18.04_amd64.deb"
    if [ "$source_tag" = "O" -o "$source_tag" = "o" ]; then
        source_location="https://github.com/eosio/eos/releases/download/v1.5.0/"
        echo "Download from Online source..."
    else
        read -p "Please input the location: " source_location
        echo "Download from Online source..."
    wget "${source_location}eosio_1.5.0-1-ubuntu-18.04_amd64.deb" \
    && echo "Source file downloaded" || echo "Unable to download Soruce file"
    fi
else
    echo "Step 7: Do not execute"
fi

step_parameter=$(($step_parameter%$step_weight))
step_weight=$(($step_weight/2))
echo "Step Parameter: ${step_parameter}; Step Weight:${step_weight}"

# Step 6
if [ $(($step_parameter/$step_weight)) -ne 0 ]; then
    echo "Step 6: Execute the installation"

    apt install ./eosio_1.5.0-1-ubuntu-18.04_amd64.deb \
    && echo "Installation completed" || "Failed to install"
else
    echo "Step 6: Do not execute"
fi

step_parameter=$(($step_parameter%$step_weight))
step_weight=$(($step_weight/2))
echo "Step Parameter: ${step_parameter}; Step Weight:${step_weight}"


# Step 5
if [ $(($step_parameter/$step_weight)) -ne 0 ]; then
    echo "Step 5: Create folders"

    mkdir ~/eos/contracts && mkdir ~/eos/log \
    && echo "Contract folder created successfully" || echo "Unable to create folder"
else
    echo "Step 5: Do not execute"
fi

step_parameter=$(($step_parameter%$step_weight))
step_weight=$(($step_weight/2))
echo "Step Parameter: ${step_parameter}; Step Weight:${step_weight}"

# Step 4
if [ $(($step_parameter/$step_weight)) -ne 0 ]; then
    echo "Step 4: Run keosd"

    keosd &
else
    echo "Step 4: Do not execute"
fi

step_parameter=$(($step_parameter%$step_weight))
step_weight=$(($step_weight/2))
echo "Step Parameter: ${step_parameter}; Step Weight:${step_weight}"

# Step 3
if [ $(($step_parameter/$step_weight)) -ne 0 ]; then
    echo "Step 3: Start nodeos"

    nodeos -e -p eosio --plugin eosio::producer_plugin \
    --plugin eosio::chain_api_plugin --plugin eosio::http_plugin \
    --plugin eosio::history_plugin --plugin eosio::history_api_plugin \
    --access-control-allow-origin='*' --contracts-console \
    --http-validate-host=false --verbose-http-errors \
    --filter-on='*' >> ~/eos/log/nodeos.log 2>&1 &

    echo "nodeos outputs:"
    tail -f 20 ~/eos/log/nodeos.log
else
    echo "Step 3: Do not execute"
fi

step_parameter=$(($step_parameter%$step_weight))
step_weight=$(($step_weight/2))
echo "Step Parameter: ${step_parameter}; Step Weight:${step_weight}"

# Step 2
if [ $(($step_parameter/$step_weight)) -ne 0 ]; then
    echo "Step 2: Download CDT Package"
    read -p "Which source do you want to use? Local/Online(L/O): " source_tag

    # eosio.cdt-1.4.1.x86_64.deb"
    if [ "$source_tag" = "O" -o "$source_tag" = "o" ]; then
        source_location="https://github.com/EOSIO/eosio.cdt/releases/download/v1.4.1/"
        echo "Download from Online source..."
    else
        read -p "Please input the location: " source_location
        echo "Download from Online source..."
    wget "${source_location}eosio_1.5.0-1-ubuntu-18.04_amd64.deb" \
    && echo "CDT Package downloaded" || echo "Unable to download CDT Package"
    fi
else
    echo "Step 2: Do not execute"
fi

step_parameter=$(($step_parameter%$step_weight))
step_weight=$(($step_weight/2))
echo "Step Parameter: ${step_parameter}; Step Weight:${step_weight}"

# Step 1
if [ $(($step_parameter/$step_weight)) -ne 0 ]; then
    echo "Step 1: Install eosio.cdt"
    apt install ./eosio.cdt-1.4.1.x86_64.deb \
    && echo "Installation completed" || "Failed to install"
else
    echo "Step 1: Do not execute"
fi

echo "Step Parameter: ${step_parameter}; Step Weight:${step_weight}"
