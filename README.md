# 🧩 HUFF-CTF: Reverse the Compression

### Category
* **EVM / Huff Language**
* **Cryptography / Compression**
* **Reverse Engineering**

### Difficulty
**Hard** (500 points)

### Estimated Solve Time
90-150 minutes

---

## 📜 Challenge

You've intercepted a contract's bytecode. The flag is hidden within, but it's been:
1. Encoded using variable-length compression
2. Encrypted with a symmetric cipher
3. Split into fragments
4. Protected by a gate with a flaw

---

## 🔐 The Protection Layer

The encryption key is stored in contract storage, guarded by a check.
But not all storage is created equal...

> "In the EVM, uninitialized storage reads return zero. 
>  A check that reads before writing might have unexpected behavior."

---

## 🧩 The Data Structure

The bytecode embeds:
- **Metadata**: Character frequencies (needed for decompression)
- **Payload**: Encrypted fragments (need decryption + combination)

Look for PUSH operations with structured data patterns.

---

## 🛠 Tools You'll Need

* **Foundry** (`cast` for disassembly and storage inspection)
* **Python** (for decoding algorithms)
* **Patience and curiosity**

---

## 📥 Getting Started

### Option 1: Docker (Recommended)

```bash
cd docker/
docker-compose up -d
```

This will automatically:
- Start a local blockchain (Anvil)
- Deploy the contract
- Provide you with the contract address and bytecode

**Get the bytecode:**
```bash
docker exec huff-ctf-challenge cat /app/BYTECODE.txt
docker exec huff-ctf-challenge cat /app/CONTRACT_ADDRESS.txt
```

**Access the container:**
```bash
docker exec -it huff-ctf-challenge /bin/bash
```

See `docker/README.md` for more details.

### Option 2: Manual Setup

#### Tools Needed

1. **Foundry**: [Install Foundry](https://book.getfoundry.sh/getting-started/installation)
2. **Python 3** (optional but recommended)
3. **EVM Disassembler** (optional): Tools like `evmdis` or online disassemblers

#### How to Get the Contract Bytecode

You will receive the contract bytecode in one of these ways:

**Option A: Direct Bytecode**
You'll receive a hex string of the deployed contract.

**Option B: Contract Address**
You'll receive a contract address. Get the bytecode using:
```bash
cast code <CONTRACT_ADDRESS> --rpc-url <RPC_URL>
```

**Option C: CTF Platform**
The bytecode will be provided through the CTF platform interface.

---

## 🔍 Analysis Steps

1. **Disassemble the bytecode** using:
   - `cast disassemble <BYTECODE>`
   - `evmdis` or other EVM disassemblers
   - Online tools like [evm.codes](https://www.evm.codes/)

2. **Inspect storage**:
   - Which slots are written to?
   - Which slots are read from?
   - What happens when you read an uninitialized slot?
   - Example: `cast storage <CONTRACT_ADDRESS> 0 --rpc-url <RPC>`

3. **Extract metadata**:
   - Look for PUSH operations with structured patterns
   - Some contain character data, others contain numeric data

4. **Extract payload**:
   - Find PUSH operations with encrypted fragments
   - Multiple fragments need to be combined

5. **Decrypt and decode**:
   - Recover the encryption key from storage
   - Decrypt each fragment separately
   - Convert decrypted bytes to bitstream
   - Combine fragments in order
   - Decompress using the frequency table

---

## 🚩 Flag Format

```
HUFF{DECODED_MESSAGE}
```

---

## 📋 What You'll Receive

* **Contract bytecode** - Hex string of the deployed contract
* **No frequency table** - You must extract it from bytecode
* **No source code** - You must reverse engineer from bytecode
* **Encrypted data** - Bitstream is XOR-encrypted and split into parts

---

## ✅ Submission

Submit the flag in the format: `HUFF{...}`

---

## 💡 Hints

<details>
<summary>🔍 Storage Analysis</summary>
Compare which storage slots are written to vs read from. 
What if a security check reads a slot that was never initialized?

<details>
<summary>💡 Spoiler: Storage Inspection</summary>
Start by checking the first few storage slots (0, 1, 2...).
Use: <code>cast storage &lt;CONTRACT_ADDRESS&gt; &lt;slot&gt; --rpc-url &lt;RPC&gt;</code>
</details>
</details>

<details>
<summary>🔐 Cipher Properties</summary>
XOR is its own inverse: `A XOR K XOR K = A`. 
The key length matches common word sizes.

<details>
<summary>💡 Spoiler: Bitstream Conversion</summary>
After XOR decryption, you'll have bytes that need to be converted to a bitstream.
Each byte becomes 8 bits in binary representation.
</details>
</details>

<details>
<summary>📊 Compression Algorithm</summary>
Huffman coding uses a binary tree. Higher frequency = shorter path. 
You need character frequencies to rebuild the tree.

<details>
<summary>💡 Spoiler: Frequency Table Format</summary>
The metadata contains character codes and their corresponding frequencies in a structured format.
Look for sequences that could represent ASCII characters followed by numeric values.
</details>
</details>

<details>
<summary>🧩 Data Extraction</summary>
PUSH opcodes (0x60-0x7f) embed data directly in bytecode. 
Some contain metadata, others contain encrypted fragments.

<details>
<summary>💡 Spoiler: Identifying Data Types</summary>
Metadata typically appears as longer hex strings with patterns (ASCII codes, sequential numbers).
Encrypted fragments are shorter and appear more random.
Look for multiple PUSH operations in sequence.
</details>
</details>

<details>
<summary>🔗 Fragment Combination</summary>
The message was split before encryption. 
You'll need to combine the decrypted fragments in order.

<details>
<summary>💡 Spoiler: Fragment Details</summary>
There are multiple fragments - look for multiple PUSH operations with similar patterns.
The total bitstream length can be determined from the fragments.
Combine them in the order they appear in the bytecode.
</details>
</details>

<details>
<summary>🌳 Tree Construction</summary>
Build a binary tree where characters with higher frequency are closer to the root. 
Use a priority queue (min-heap) to combine nodes.

<details>
<summary>💡 Spoiler: Tree Building Process</summary>
1. Create a leaf node for each character with its frequency
2. Use a min-heap to always combine the two lowest frequency nodes
3. Repeat until only one node remains (the root)
4. Traverse the tree to assign codes: left = 0, right = 1
</details>
</details>

---

## 📚 Resources

* [Huff Language Documentation](https://docs.huff.sh/)
* [Huffman Coding Explained](https://en.wikipedia.org/wiki/Huffman_coding)
* [EVM Opcodes](https://www.evm.codes/)
* [EVM Storage Layout](https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html)

---

## 🏆 Scoring

* **First Blood**: +50 bonus points
* **Solve Time Bonus**: Linear decay from 150 minutes to 0

---

**Good luck! 🚀**
