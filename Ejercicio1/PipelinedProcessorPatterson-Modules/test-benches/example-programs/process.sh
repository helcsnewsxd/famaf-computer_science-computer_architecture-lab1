make

echo

LONG=$(cat main.list | grep -oP '\t[0-9a-f]{8}' | wc -l)

TOTAL=64
CNT=1

echo -n "logic [N-1 : 0] ROM[0 : 63] = '{"

cat main.list | grep -oP '\t[0-9a-f]{8}' | while true; do
    while read -r line; do
        if [ $CNT -eq $TOTAL ]; then
            echo -n "32'h$line"
            CNT=$((CNT+1))
        else
            echo -n "32'h$line,"
            CNT=$((CNT+1))
        fi
    done

    for i in $(seq $CNT $TOTAL); do
        if [ $i -eq $TOTAL ]; then
            echo -n "32'h00000000"
        else
            echo -n "32'h00000000,"
        fi
    done

    break
done

echo "};"

echo

make clean