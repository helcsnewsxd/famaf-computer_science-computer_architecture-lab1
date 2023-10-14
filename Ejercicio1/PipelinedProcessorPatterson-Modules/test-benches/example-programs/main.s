    .text
    .org 0x0000

    zero .req xzr
    one .req x1
    mvMem .req x8

    posMem .req x0
    var .req x2
    var2 .req x3

    limitVal .req x30
    it .req x29

    fstReg .req x16
    sndReg .req x17

problem_2a:
    add var, zero, zero
    add posMem, zero, zero

    add it, zero, limitVal
    problem_2a_while:
        cbz it, problem_2a_end_while

        stur var, [posMem, #0]
        add var, var, one
        add posMem, posMem, mvMem

        sub it, it, one
        cbz zero, problem_2a_while
    problem_2a_end_while:

problem_2b:
    add var, zero, zero
    add var2, zero, zero
    add posMem, zero, zero

    add it, zero, limitVal
    problem_2b_while:
        cbz it, problem_2b_end_while

        ldur var, [posMem, #0]
        add var2, var2, var
        add posMem, posMem, mvMem

        sub it, it, one
        cbz zero, problem_2b_while
    problem_2b_end_while:

    stur var2, [posMem, #0]

problem_2c:
    add var, zero, zero
    add posMem, zero, zero

    add it, zero, fstReg
    problem_2c_while:
        cbz it, problem_2c_end_while

        add var, var, sndReg

        sub it, it, one
        cbz zero, problem_2c_while
    problem_2c_end_while:

    stur var, [posMem, #0]

    .unreq zero
    .unreq one
    .unreq mvMem
    .unreq posMem
    .unreq var
    .unreq var2
    .unreq limitVal
    .unreq it
    .unreq fstReg
    .unreq sndReg
