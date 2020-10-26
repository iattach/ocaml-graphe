open Graph
open Printf

type path = string

(* Format of text files:
   % This is a comment

   % A node with its coordinates (which are not used).
   n 88.8 209.7
   n 408.9 183.0

   % The first node has id 0, the next is 1, and so on.

   % Edges: e source dest label
   e 3 1 11
   e 0 2 8

*)

let write_file path graph =

  (* Open a write-file. *)
  let ff = open_out path in

  (* Write in this file. *)
  fprintf ff "%% This is a graph.\n\n" ;

  (* Write all nodes (with fake coordinates) *)
  n_iter_sorted graph (fun id -> fprintf ff "n %.1f 1.0\n" (float_of_int id)) ;
  fprintf ff "\n" ;

  (* Write all arcs *)
  e_iter graph (fun id1 id2 lbl -> fprintf ff "e %d %d %s\n" id1 id2 lbl) ;

  fprintf ff "\n%% End of graph\n" ;

  close_out ff ;
  ()

(* Reads a line with a node. *)
let read_node id graph line =
  try Scanf.sscanf line "n %f %f" (fun _ _ -> new_node graph id)
  with e ->
    Printf.printf "Cannot read node in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"

(* Reads a line with an arc. *)
let read_arc graph line =
  try Scanf.sscanf line "e %d %d %s" (fun id1 id2 label -> new_arc graph id1 id2 label)
  with e ->
    Printf.printf "Cannot read arc in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"

(* Reads a comment or fail. *)
let read_comment graph line =
  try Scanf.sscanf line " %%" graph
  with _ ->
    Printf.printf "Unknown line:\n%s\n%!" line ;
    failwith "from_file"

let from_file path =

  let infile = open_in path in

  (* Read all lines until end of file. 
   * n is the current node counter. *)
  let rec loop n graph =
    try
      let line = input_line infile in

      (* Remove leading and trailing spaces. *)
      let line = String.trim line in

      let (n2, graph2) =
        (* Ignore empty lines *)
        if line = "" then (n, graph)

        (* The first character of a line determines its content : n or e. *)
        else match line.[0] with
          | 'n' -> (n+1, read_node n graph line)
          | 'e' -> (n, read_arc graph line)

          (* It should be a comment, otherwise we complain. *)
          | _ -> (n, read_comment graph line)
      in      
      loop n2 graph2

    with End_of_file -> graph (* Done *)
  in

  let final_graph = loop 0 empty_graph in

  close_in infile ;
  final_graph

(*below for me*)
(*let add_teminate_node acu id1 id2 lbl =  
  if acu.(id1) == 0  
  then acu.(id1) <- 1
  else if acu.(id1) == 2
       then acu.(id1) <- -1;
  if acu.(id2) == 0  
  then acu.(id2) <- 2
  else if acu.(id2) == 1
      then acu.(id2) <- -1;
  acu*)

let export path graph =

  (* Open a write-file. *)
  let ff = open_out (path) in

  (* Write in this file. *)
  fprintf ff "digraph finite_state_machine {\n" ;
  
  fprintf ff "rankdir=LR; \n" ;

  fprintf ff "size=\"6,3\" \n" ;

  (*fprintf ff "node [shape = doublecircle];" ;
  (* Write all teminate nodes *)
  let node_nbr = n_fold graph (fun node_nbr id -> node_nbr + 1 ) 0 in 

  let num = e_fold graph add_teminate_node (Array.make node_nbr 0) in 

  Array.iteri (fun index var -> if var != -1 then  fprintf ff "LR_%d " index) num;

  fprintf ff ";\n";*)

  fprintf ff "node [shape = circle];\n";
  (* Write all arcs *)
  e_iter graph (fun id1 id2 lbl -> fprintf ff "%d -> %d [ label = \"%s\" ];\n" id1 id2 lbl) ;

  fprintf ff "}\n" ;

  close_out ff ;
  ()

(*above for me*)
(*
*  digraph finite_state_machine {
*    rankdir=LR;
*    size="8,5"
*    node [shape = doublecircle]; LR_0 LR_3 LR_4 LR_8;
*    node [shape = circle];
*    LR_0 -> LR_2 [ label = "SS(B)" ];
*    LR_0 -> LR_1 [ label = "SS(S)" ];
*    LR_1 -> LR_3 [ label = "S($end)" ];
*    LR_2 -> LR_6 [ label = "SS(b)" ];
*    LR_2 -> LR_5 [ label = "SS(a)" ];
*    LR_2 -> LR_4 [ label = "S(A)" ];
*    LR_5 -> LR_7 [ label = "S(b)" ];
*    LR_5 -> LR_5 [ label = "S(a)" ];
*    LR_6 -> LR_6 [ label = "S(b)" ];
*    LR_6 -> LR_5 [ label = "S(a)" ];
*    LR_7 -> LR_8 [ label = "S(b)" ];
*    LR_7 -> LR_5 [ label = "S(a)" ];
    LR_8 -> LR_6 [ label = "S(b)" ];
    LR_8 -> LR_5 [ label = "S(a)" ];
  }
*)
(*
size : double|point
        Maximum width and height of drawing, in inches.

        If only a single number is given, this is used for both the width and the height.

        If defined and the drawing is larger than the given size, the drawing is uniformly scaled down so that it fits within the given size.

        If size ends in an exclamation point "!", then size is taken to be the desired minimum size. In this case, if both dimensions of the drawing are less than size, the drawing is scaled up uniformly until at least one dimension equals its dimension in size.

        There is some interaction between the size and ratio attributes.

        Valid for: Graphs.
*)