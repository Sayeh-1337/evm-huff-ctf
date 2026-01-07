#!/bin/bash

# Test script to verify Anvil connectivity

echo "🔍 Testing Anvil connectivity..."
echo ""

echo "1. Testing from host (localhost):"
cast chain-id --rpc-url http://localhost:8545 2>&1 || echo "   ❌ Cannot connect via localhost"

echo ""
echo "2. Testing from challenge container (service name):"
docker exec huff-ctf-challenge cast chain-id --rpc-url http://anvil:8545 2>&1 || echo "   ❌ Cannot connect via service name"

echo ""
echo "3. Checking Anvil container network:"
docker exec huff-ctf-anvil netstat -tlnp 2>/dev/null | grep 8545 || docker exec huff-ctf-anvil ss -tlnp 2>/dev/null | grep 8545 || echo "   Could not check listening ports"

echo ""
echo "4. Checking network connectivity:"
docker exec huff-ctf-challenge ping -c 1 anvil 2>&1 | head -2 || echo "   ❌ Cannot ping anvil service"

echo ""
echo "✅ Diagnostic complete"

