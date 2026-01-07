#!/bin/bash

# Diagnostic script to check Anvil connectivity

echo "🔍 Checking Anvil connectivity..."
echo ""

echo "1. Checking if Anvil container is running:"
docker ps | grep anvil || echo "   ❌ Anvil container not found"

echo ""
echo "2. Checking Anvil logs:"
docker logs --tail 10 huff-ctf-anvil 2>&1 | head -5

echo ""
echo "3. Testing connection from challenge container:"
docker exec huff-ctf-challenge cast chain-id --rpc-url http://anvil:8545 2>&1 || echo "   ❌ Cannot connect to Anvil"

echo ""
echo "4. Network information:"
docker network inspect huff-ctf-network --format '{{range .Containers}}{{.Name}} {{end}}' 2>&1

echo ""
echo "✅ Diagnostic complete"


