file = open("../../simulation/modelsim/mem.dump")

for i in range(2):
    print(file.readline())
for i in range(31):
    s = file.readline()
    number = int("0b" + (s.split(" ")[1].split("\n")[0]), 2)
    print(f"{i} {hex(number)}")
file.close()
