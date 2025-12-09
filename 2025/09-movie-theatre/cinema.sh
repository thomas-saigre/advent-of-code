#/bin/sh

# FILENAME=example.txt
FILENAME=input.txt

declare -a tiles_x
declare -a tiles_y

idx=0
while read -r input; do
    # echo $i
    IFS=',' read -r x y <<< "$input"
    tiles_x[$idx]=$x
    tiles_y[$idx]=$y
    idx=$((idx + 1))
done < $FILENAME

nb_tiles=${#tiles_x[@]}
max_area=0
for idx in $(seq 0 $(($nb_tiles-1)))
do
    for jdx in $(seq $(($idx+1)) $(($nb_tiles-1)))
    do
        # echo "Comparing ${idx} and ${jdx}"
        x_i=${tiles_x[$idx]}
        y_i=${tiles_y[$idx]}
        x_j=${tiles_x[$jdx]}
        y_j=${tiles_y[$jdx]}
        max_x=$(( x_i > x_j ? x_i : x_j ))
        min_x=$(( x_i < x_j ? x_i : x_j ))
        max_y=$(( y_i > y_j ? y_i : y_j ))
        min_y=$(( y_i < y_j ? y_i : y_j ))
        # echo "    max_x: ${max_x}, min_x: ${min_x} - max_y: ${max_y}, min_y: ${min_y}"
        length_x=$((${max_x}-${min_x}+1))
        length_y=$((${max_y}-${min_y}+1))
        area=$(($length_x*$length_y))
        # echo "    ${length_x} ${length_y} ${area#-}"
        max_area=$(( $area > $max_area ? $area : $max_area ))
    done
done

echo "Part I: ${max_area}"