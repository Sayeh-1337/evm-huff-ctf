# 🔧 Docker Commands Reference

## Prerequisites

Make sure the containers are running:
```bash
cd docker/
docker-compose up -d
```

Check container status:
```bash
docker ps
```

## Get Contract Information

### Get Bytecode
```bash
# Simple - works on all platforms
docker exec huff-ctf-challenge cat /app/BYTECODE.txt
```

### Get Contract Address
```bash
docker exec huff-ctf-challenge cat /app/CONTRACT_ADDRESS.txt
```

## Disassemble Bytecode

### Linux/macOS
```bash
docker exec huff-ctf-challenge bash -c "cast disassemble \$(cat /app/BYTECODE.txt)"
```

### Windows PowerShell
```powershell
# Method 1: Use bash -c (recommended)
docker exec huff-ctf-challenge bash -c "cast disassemble \$(cat /app/BYTECODE.txt)"

# Method 2: Get bytecode first, then disassemble
$bytecode = docker exec huff-ctf-challenge cat /app/BYTECODE.txt
docker exec huff-ctf-challenge cast disassemble $bytecode
```

### Windows CMD
```cmd
docker exec huff-ctf-challenge bash -c "cast disassemble $(cat /app/BYTECODE.txt)"
```

## Query Contract from Address

### Linux/macOS
```bash
docker exec huff-ctf-challenge bash -c "cast code \$(cat /app/CONTRACT_ADDRESS.txt) --rpc-url http://anvil:8545"
```

### Windows PowerShell
```powershell
docker exec huff-ctf-challenge bash -c "cast code \$(cat /app/CONTRACT_ADDRESS.txt) --rpc-url http://anvil:8545"
```

## Access Container Shell

```bash
docker exec -it huff-ctf-challenge /bin/bash
```

Once inside, you can run commands directly:
```bash
cat /app/BYTECODE.txt
cast disassemble $(cat /app/BYTECODE.txt)
cast code $(cat /app/CONTRACT_ADDRESS.txt) --rpc-url http://anvil:8545
```

## Check Container Logs

```bash
# Check if contract was deployed
docker logs huff-ctf-challenge

# Check Anvil logs
docker logs huff-ctf-anvil
```

## Restart Services

```bash
docker-compose restart
```

## Stop Services

```bash
docker-compose down
```

