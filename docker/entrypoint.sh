#!/bin/bash

# HUFF-CTF Docker Entrypoint
# Automatically deploys contract and displays bytecode

set -e

echo "🧩 HUFF-CTF Challenge Setup"
echo "==========================="
echo ""

# Wait for Anvil to be ready
echo "⏳ Waiting for Anvil to be ready..."
MAX_WAIT=60
WAIT_COUNT=0

while [ $WAIT_COUNT -lt $MAX_WAIT ]; do
    # Try connecting to Anvil
    CHAIN_ID=$(cast chain-id --rpc-url http://anvil:8545 2>&1)
    if [ $? -eq 0 ] && [ -n "$CHAIN_ID" ]; then
        echo "✅ Anvil is ready! (Chain ID: $CHAIN_ID)"
        break
    fi
    if [ $((WAIT_COUNT % 5)) -eq 0 ]; then
        echo "   Attempt $((WAIT_COUNT + 1))/$MAX_WAIT: Waiting for Anvil..."
        echo "   Connection test result: ${CHAIN_ID:-connection failed}"
    fi
    sleep 2
    WAIT_COUNT=$((WAIT_COUNT + 1))
done

# Final check
if ! cast chain-id --rpc-url http://anvil:8545 &>/dev/null 2>&1; then
    echo "❌ Error: Anvil is not accessible after $MAX_WAIT seconds"
    echo "💡 Troubleshooting:"
    echo "   1. Check if Anvil container is running: docker ps | grep anvil"
    echo "   2. Check Anvil logs: docker logs huff-ctf-anvil"
    echo "   3. Verify network: docker network inspect huff-ctf-network"
    echo "   4. Try connecting: cast chain-id --rpc-url http://anvil:8545"
    exit 1
fi

echo ""

# Change to challenge directory
cd /app/challenge

# Compile contract
echo "📦 Compiling contract..."

if ! command -v huffc &> /dev/null; then
    echo "❌ Error: huffc not found"
    echo "💡 The Huff compiler failed to install during Docker build"
    exit 1
fi

# Compile and extract bytecode (handle both with and without 0x prefix)
COMPILE_OUTPUT=$(huffc HuffmanFlag.huff --bytecode 2>&1)

# Try to extract bytecode with 0x prefix first
BYTECODE=$(echo "$COMPILE_OUTPUT" | grep -oE '0x[a-fA-F0-9]+' | tail -1)

# If no 0x prefix found, look for hex string without prefix
if [ -z "$BYTECODE" ]; then
    # Extract all hex strings (20+ chars) and take the longest one (should be bytecode)
    HEX_STRING=$(echo "$COMPILE_OUTPUT" | grep -oE '[a-fA-F0-9]{20,}' | awk '{print length, $0}' | sort -rn | head -1 | awk '{print $2}')
    if [ -n "$HEX_STRING" ]; then
        BYTECODE="0x$HEX_STRING"
    fi
fi

if [ -z "$BYTECODE" ] || [ "${BYTECODE#0x}" = "$BYTECODE" ]; then
    echo "❌ Error: Could not extract bytecode from compilation"
    echo "Compilation output:"
    echo "$COMPILE_OUTPUT"
    exit 1
fi

echo "✅ Contract compiled"
echo ""

# Deploy contract to Anvil
echo "🚀 Deploying contract to Anvil..."
DEPLOY_OUTPUT=$(cast send \
    --rpc-url http://anvil:8545 \
    --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
    --gas-limit 1000000 \
    --create "$BYTECODE" \
    2>&1)
DEPLOY_EXIT=$?

if [ $DEPLOY_EXIT -ne 0 ]; then
    echo "❌ Deployment failed (exit code: $DEPLOY_EXIT):"
    echo "$DEPLOY_OUTPUT"
    exit 1
fi

# Extract contract address
CONTRACT_ADDRESS=$(echo "$DEPLOY_OUTPUT" | grep -oE 'contractAddress: 0x[a-fA-F0-9]{40}' | grep -oE '0x[a-fA-F0-9]{40}' || \
                   echo "$DEPLOY_OUTPUT" | grep -oE '0x[a-fA-F0-9]{40}' | head -1)

if [ -z "$CONTRACT_ADDRESS" ]; then
    echo "⚠️  Warning: Could not extract contract address from output"
    echo "Deploy output:"
    echo "$DEPLOY_OUTPUT"
    CONTRACT_ADDRESS="UNKNOWN"
else
    echo "✅ Contract deployed successfully!"
fi

echo ""
echo "============================================================"
echo "📋 CHALLENGE INFORMATION"
echo "============================================================"
echo ""
echo "📍 Contract Address: $CONTRACT_ADDRESS"
echo ""
echo "📦 Contract Bytecode:"
echo "$BYTECODE"
echo ""
echo "💡 To get bytecode from address, run:"
echo "   cast code $CONTRACT_ADDRESS --rpc-url http://anvil:8545"
echo ""
echo "🔍 To disassemble bytecode, run:"
echo "   cast disassemble $BYTECODE"
echo ""
echo "============================================================"
echo ""

# Save to files for easy access
echo "$CONTRACT_ADDRESS" > /app/CONTRACT_ADDRESS.txt
echo "$BYTECODE" > /app/BYTECODE.txt

echo "✅ Information saved to:"
echo "   /app/CONTRACT_ADDRESS.txt"
echo "   /app/BYTECODE.txt"
echo ""

# Keep container running
exec /bin/bash

