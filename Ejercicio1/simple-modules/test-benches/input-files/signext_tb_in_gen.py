from random import getrandbits, randint


def setCntBits(number, cntBits):
    return number & ((1 << cntBits) - 1)


def gen(test_number, negative):
    # LDUR, STUR
    if test_number == 0b111_1100_0010 or test_number == 0b111_1100_0000:
        imm = (negative << 8) + getrandbits(8)
        a = (test_number << 21) + (imm << 12) + getrandbits(12)
        y = imm
        if negative:
            y += ((1 << 55) - 1) << 9
    # CBZ
    elif (test_number >> 3) == 0b101_1010_0:
        test_number >>= 3
        imm = (negative << 18) + getrandbits(18)
        a = (test_number << 24) + (imm << 5) + getrandbits(5)
        y = imm
        if negative:
            y += ((1 << 45) - 1) << 19
    # Not implemented instructions
    else:
        a = (test_number << 21) + getrandbits(21)
        y = 0

    a = setCntBits(a, 32)
    y = setCntBits(y, 64)

    print(f"{a} {y}")


print("// a, y_expected")
cnt_tests = (
    1 << 11
)  # to test all possible opcodes with negative and positive immediates
for i in range(cnt_tests):
    for j in range(2):
        gen(i, j)
