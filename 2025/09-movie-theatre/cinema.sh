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
total_comparisons=$((nb_tiles-1))

max_area=0
max_area_inside=0

for idx in $(seq 0 $(($nb_tiles-1)))
do
    for jdx in $(seq $(($idx+1)) $(($nb_tiles-1)))
    do
        # echo "========================="
        # echo "Checking ${idx} to ${jdx}"
        x_i=${tiles_x[$idx]}
        y_i=${tiles_y[$idx]}
        x_j=${tiles_x[$jdx]}
        y_j=${tiles_y[$jdx]}
        rect_right=$(( x_i > x_j ? x_i : x_j ))
        rect_left=$(( x_i < x_j ? x_i : x_j ))
        rect_top=$(( y_i > y_j ? y_i : y_j ))
        rect_bottom=$(( y_i < y_j ? y_i : y_j ))
        # echo "    rect_right: ${rect_right}, rect_left: ${rect_left} - rect_top: ${rect_top}, rect_bottom: ${rect_bottom}"
        length_x=$((${rect_right}-${rect_left}+1))
        length_y=$((${rect_top}-${rect_bottom}+1))
        area=$(($length_x*$length_y))
        # echo "    ${length_x} ${length_y} ${area#-}"
        max_area=$(( $area > $max_area ? $area : $max_area ))

        crossed=false
        for e in $(seq 0 $((nb_tiles-1)))
        do
            ep1=$(( ($e + 1) % $nb_tiles ))
            # echo "${e} to ${ep1}"
            e_x=${tiles_x[$e]}
            e_y=${tiles_y[$e]}
            ep1_x=${tiles_x[$ep1]}
            ep1_y=${tiles_y[$ep1]}
            edge_right=$(( e_x > ep1_x ? e_x : ep1_x ))
            edge_left=$(( e_x < ep1_x ? e_x : ep1_x ))
            edge_top=$(( e_y > ep1_y ? e_y : ep1_y ))
            edge_bottom=$(( e_y < ep1_y ? e_y : ep1_y ))

            # AABB
            if [ $rect_left -lt $edge_right ] && [ $edge_left -lt $rect_right ] && [ $rect_bottom -lt $edge_top ] && [ $edge_bottom -lt $rect_top ]
            then
                # echo "    Crossed line ${e}-${ep1}"
                crossed=true
                break
            fi
        done

        if [ "$crossed" = "false" ]
        then
            max_area_inside=$(( $area > $max_area_inside ? $area : $max_area_inside ))
            echo -ne "(${idx}-${jdx}/${total_comparisons})    Found inside (area = ${area}, max_area_inside is now ${max_area_inside})          \r"
        fi
    done
done
echo ""

echo "Part I : ${max_area}"
echo "Part II: ${max_area_inside}"

echo "Warning : there is a potential problem with part II, we detect if we cross the border, but we do not check if we are inside or outside."
echo "We just cross the finger so that there is no higher rectangle outside..."