#!/bin/bash

# Quick script to get bytecode from deployed contract

CONTRACT_ADDRESS=$(cat /app/CONTRACT_ADDRESS.txt 2>/dev/null)

if [ -z "$CONTRACT_ADDRESS" ]; then
    echo "❌ Contract address not found. Run the entrypoint script first."
    exit 1
fi

echo "📦 Getting bytecode from contract: $CONTRACT_ADDRESS"
echo ""

BYTECODE=$(cast code "$CONTRACT_ADDRESS" --rpc-url http://anvil:8545)

if [ -z "$BYTECODE" ]; then
    echo "❌ Could not retrieve bytecode"
    exit 1
fi

echo "✅ Bytecode:"
echo "$BYTECODE"
echo ""
echo "💡 To disassemble:"
echo "   cast disassemble $BYTECODE"

