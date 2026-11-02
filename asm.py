import sys

opcodes = {
	'NOP': 0x0,
	'ADD': 0x1,
	'SUB': 0x2,
	'AND': 0x3,
	'OR': 0x4,
	'ALUX': 0x5,
	'ADDI': 0x6,
	'LDI': 0x7,
	'LUI': 0x8,
	'LD': 0x9,
	'ST': 0xA,
	'BZ': 0xB,
	'BNZ': 0xC,
	'JMP': 0xD,
	'JAL': 0xE,
	'HLT': 0xF
}

def parse_reg(reg_str):
	return int(reg_str.strip('Rr'))

def assemble(input_file, output_file):
	with open(input_file, 'r') as f:
		lines = f.readlines()
	
	hex_lines = []
	for line in lines:
		line = line.strip()
		if not line:
			continue
		parts = line.replace(',', '').split()
		mnemonic = parts[0].upper()
		op = opcodes[mnemonic]
		
		if mnemonic in ['ADD', 'SUB', 'AND', 'OR', 'ALUX']:
			rd = parse_reg(parts[1])
			rs = parse_reg(parts[2])
			rt = parse_reg(parts[3])
			val = (op << 12) | (rd << 8) | (rs << 4) | rt
		elif mnemonic in ['ADDI', 'LDI', 'LUI', 'LD', 'ST', 'BZ', 'BNZ', 'JMP', 'JAL']:
			rd = parse_reg(parts[1])
			rs = parse_reg(parts[2])
			imm = int(parts[3], 0) & 0xF
			val = (op << 12) | (rd << 8) | (rs << 4) | imm
		elif mnemonic in ['HLT', 'NOP']:
			val = (op << 12)
		else:
			raise ValueError(f"Unknown instruction: {mnemonic}")
		
		hex_lines.append(f"{val:04X}\n")
		
	with open(output_file, 'w') as f:
		f.writelines(hex_lines)

if __name__ == '__main__':
	assemble('program.asm', 'program.hex')
