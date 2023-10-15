from random import getrandbits, randint


def setCntBits(number, cntBits):
    return number & ((1 << cntBits) - 1)


def printValues(PCSrc_F, reset, PCBranch_F, imem_addr_F_expected):
    PCSrc_F = setCntBits(int(PCSrc_F), 1)
    reset = setCntBits(int(reset), 1)
    PCBranch_F = setCntBits(PCBranch_F, 64)
    imem_addr_F_expected = setCntBits(imem_addr_F_expected, 64)

    print(f"{PCSrc_F} {reset} {PCBranch_F} {imem_addr_F_expected}")


def createTestCase(PCSrc_F, reset, PCBranch_F):
    if reset:
        PC[0] = 0
    elif PCSrc_F:
        PC[0] = PCBranch_F

    imem_addr_F_expected = PC[0]

    printValues(PCSrc_F, reset, PCBranch_F, imem_addr_F_expected)

    PC[0] += 4


print("// PCSrc_F, reset, PCBranch_F, imem_addr_F_expected")
PC = [0]
for i in range(5):
    createTestCase(0, 1, getrandbits(64))
for i in range(30):
    createTestCase(0, 0, getrandbits(64))

createTestCase(1, 0, getrandbits(64))

for i in range(30):
    createTestCase(0, 0, getrandbits(64))

createTestCase(0, 1, getrandbits(64))
