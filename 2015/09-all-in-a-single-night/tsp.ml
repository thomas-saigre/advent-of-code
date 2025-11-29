(* Note : I wrote this code for my TIPE when I was in Prépa, back in 2017,
   and despite some tiny fixes (and the second part of the day), I did not
   change it ! *)

(* ------------------------------------------------- *)
(* Algorithme niais  *)

(* Cet algorithme créé tous les chemin passant par toutes les villes et regarde lequel est le plus court *)

let ajouter_dans_tab v pos t =
	let n = Array.length t in
	Array.append (Array.append (Array.sub t 0 pos) ([|v|])) (Array.sub t pos (n-pos))


let rec tous_les_chemins n =
	if n = 0 then [|[||]|]
	else
		let t = tous_les_chemins (n-1) and
			s = ref [||] in
		let l = Array.length t in
		for i = 0 to (n-1) do
			for j = 0 to (l-1) do
				s := Array.append !s [|(ajouter_dans_tab (n-1) i t.(j))|]
			done
		done;
		!s



let longueur_chemin mat t =
	let n = Array.length t and
		c = ref 0 in
	for i = 0 to (n-2) do
		c := !c + mat.(t.(i)).(t.(i+1))
	done;
	!c



let dist = [|
	     (* Fa ; Tr ; Ta ; No ; Sn ; St ; Al ; Ar *)
(* Fa *) [| 0  ; 65 ; 129; 144; 71 ; 137; 3  ; 149|];
(* Tr *) [| 65 ; 0  ; 63 ; 4  ; 105; 125; 55 ; 14 |];
(* Ta *) [| 129; 63 ; 0  ; 68 ; 52 ; 65 ; 22 ; 143|];
(* No *) [| 144; 4  ; 68 ; 0  ; 8  ; 23 ; 136; 115|];
(* Sn *) [| 71 ; 105; 52 ; 8  ; 0  ; 101; 84 ; 96 |];
(* St *) [| 137; 125; 65 ; 23 ; 101; 0  ; 107; 14 |];
(* Al *) [| 3  ; 55 ; 22 ; 136; 84 ; 107; 0  ; 46 |];
(* Ar *) [| 149; 14 ; 143; 115; 96 ; 14 ; 46 ; 0  |];
|]




let tsp_niais ville =
	let nb = Array.length ville in
	let t = tous_les_chemins nb in
	let n = Array.length t in
	let m = ref (longueur_chemin ville t.(0)) and
		c = ref t.(0) in
	for i = 1 to (n-1) do
		let l = (longueur_chemin ville t.(i)) in
		if !m > l
			then (m := l;
				  c := t.(i))
	done;
	!m

let anti_tsp_niais ville =
	let nb = Array.length ville in
	let t = tous_les_chemins nb in
	let n = Array.length t in
	let m = ref (longueur_chemin ville t.(0)) and
		c = ref t.(0) in
	for i = 1 to (n-1) do
		let l = (longueur_chemin ville t.(i)) in
		if !m < l
			then (m := l;
				  c := t.(i))
	done;
	!m

let c = tous_les_chemins 8;;

(* let l = longueur_chemin dist c.(0);;
print_int l;;
print_endline "";; *)

let partI = tsp_niais dist;;
print_string "Part I: ";;
print_int partI;;
print_endline "";;

let partII = anti_tsp_niais dist;;
print_string "Part II: ";;
print_int partII;;
print_endline "";;
