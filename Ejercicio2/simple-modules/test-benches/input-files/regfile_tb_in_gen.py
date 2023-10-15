from random import getrandbits, randint


def setCntBits(number, cntBits):
    return number & ((1 << cntBits) - 1)


def printValues(we3, ra1, ra2, wa3, wd3, rd1_expected, rd2_expected):
    we3 = setCntBits(int(we3), 1)
    ra1 = setCntBits(ra1, 5)
    ra2 = setCntBits(ra2, 5)
    wa3 = setCntBits(wa3, 5)
    wd3 = setCntBits(wd3, 64)
    rd1_expected = setCntBits(rd1_expected, 64)
    rd2_expected = setCntBits(rd2_expected, 64)
    print(f"{we3} {ra1} {ra2} {wa3} {wd3} {rd1_expected} {rd2_expected}")


def createTestCase(we3, ra1, ra2, wa3, wd3):
    if we3 and wa3 != 31:
        reg[wa3] = wd3
    printValues(we3, ra1, ra2, wa3, wd3, reg[ra1], reg[ra2])


print("// we3, ra1, ra2, wa3, wd3, rd1_expected, rd2_expected")
reg = []
for i in range(32):
    reg.append(i % 31)

# Check initialization
for i in range(32):
    createTestCase(0, i, i, 0, 0)

# Check writing
for i in range(32):
    createTestCase(1, randint(0, 31), i, i, getrandbits(64))
