echo -n "Part I : "
paste -s input.txt | bc

echo -n "Part II: "
declare -A seen
n=0
while :
do
    while read -r i; do
        n=$((n + i))
        if [[ ${seen[$n]} ]]; then
            echo "$n"
            break 2
        fi
        seen[$n]=1
    done < input.txt
done