# 🪟 Windows PowerShell Commands

## Quick Reference for Windows Users

### 1. Start Containers
```powershell
cd docker/
docker compose up -d
```

### 2. Check Container Status
```powershell
docker ps
```

If containers are not running, check logs:
```powershell
docker logs huff-ctf-challenge
docker logs huff-ctf-anvil
```

### 3. Get Bytecode (Simple Method)
```powershell
docker exec huff-ctf-challenge cat /app/BYTECODE.txt
```

### 4. Disassemble Bytecode

**Method 1: Access Container Shell (Easiest)**
```powershell
docker exec -it huff-ctf-challenge /bin/bash
```

Then inside the container:
```bash
cat /app/BYTECODE.txt
cast disassemble $(cat /app/BYTECODE.txt)
```

**Method 2: Two-Step Process**
```powershell
# Step 1: Get bytecode
$bytecode = docker exec huff-ctf-challenge cat /app/BYTECODE.txt

# Step 2: Disassemble (use single quotes to prevent PowerShell expansion)
docker exec huff-ctf-challenge bash -c 'cast disassemble $(cat /app/BYTECODE.txt)'
```

**Method 3: Direct Command with Proper Escaping**
```powershell
docker exec huff-ctf-challenge bash -c 'cast disassemble `$(cat /app/BYTECODE.txt)'
```

### 5. Get Contract Address
```powershell
docker exec huff-ctf-challenge cat /app/CONTRACT_ADDRESS.txt
```

### 6. Check if Contract is Deployed
```powershell
docker logs huff-ctf-challenge
```

### 7. Restart if Needed
```powershell
docker compose restart
```

## Troubleshooting

**Container not running?**
```powershell
# Check status
docker ps -a

# Start containers
docker compose up -d

# Check logs
docker logs huff-ctf-challenge
```

**Entrypoint failed?**
```powershell
# Re-run entrypoint manually
docker exec -it huff-ctf-challenge /app/docker/entrypoint.sh
```

**Best Practice: Use Container Shell**
Instead of complex escaping, just access the container:
```powershell
docker exec -it huff-ctf-challenge /bin/bash
```

Then all commands work normally inside the container!


