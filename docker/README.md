# 🐳 HUFF-CTF Docker Setup

This Docker setup automatically deploys the contract and provides the bytecode.

## 🚀 Quick Start

### For Participants

1. **Start the Docker environment:**
   ```bash
   cd docker/
   docker-compose up -d
   ```

2. **Get the contract information:**
   ```bash
   docker exec -it huff-ctf-challenge cat /app/BYTECODE.txt
   docker exec -it huff-ctf-challenge cat /app/CONTRACT_ADDRESS.txt
   ```

3. **Access the container:**
   ```bash
   docker exec -it huff-ctf-challenge /bin/bash
   ```

### What You Get

- ✅ **Anvil** - Local blockchain running on port 8545
- ✅ **Deployed Contract** - Contract automatically deployed
- ✅ **Contract Address** - Saved in `/app/CONTRACT_ADDRESS.txt`
- ✅ **Contract Bytecode** - Saved in `/app/BYTECODE.txt`
- ✅ **All Tools** - Foundry, Huff compiler, Python

## 📋 Files in Container

- `/app/BYTECODE.txt` - Contract bytecode (hex string)
- `/app/CONTRACT_ADDRESS.txt` - Deployed contract address
- `/app/challenge/` - Challenge files
- `/app/README.md` - Challenge description

## 🔧 Commands

### Get Bytecode
```bash
# Read saved file (works on all platforms)
docker exec huff-ctf-challenge cat /app/BYTECODE.txt
```

### Disassemble Bytecode

**Linux/macOS:**
```bash
docker exec huff-ctf-challenge bash -c "cast disassemble \$(cat /app/BYTECODE.txt)"
```

**Windows PowerShell:**
```powershell
# Method 1: Use single quotes (recommended)
docker exec huff-ctf-challenge bash -c 'cast disassemble $(cat /app/BYTECODE.txt)'

# Method 2: Access container shell (easiest)
docker exec -it huff-ctf-challenge /bin/bash
# Then inside: cast disassemble $(cat /app/BYTECODE.txt)
```

**Or get bytecode first, then disassemble:**
```bash
# Step 1: Get bytecode
docker exec huff-ctf-challenge cat /app/BYTECODE.txt

# Step 2: Copy the output and use it
docker exec huff-ctf-challenge cast disassemble <PASTE_BYTECODE_HERE>
```

**Windows users:** See `WINDOWS_COMMANDS.md` for PowerShell-specific examples.

### Access Container
```bash
docker exec -it huff-ctf-challenge /bin/bash
```

## 🛑 Stop

```bash
docker-compose down
```

## 🔍 Troubleshooting

**Anvil not ready?**
```bash
# Check if Anvil is running
docker ps | grep anvil

# Check Anvil logs
docker logs huff-ctf-anvil

# Rebuild and restart (if entrypoint was updated)
docker compose down
docker compose build --no-cache huff-ctf-challenge
docker compose up -d

# Or restart services
docker compose restart
```

**Contract not deployed?**
```bash
# Check logs
docker logs huff-ctf-challenge

# Re-run entrypoint
docker exec -it huff-ctf-challenge /app/docker/entrypoint.sh
```

