open Gfile
open Gpath
open Tools
open Galgo


let () =

  (* Check the number of command-line arguments *)
  if Array.length Sys.argv <> 5 then
    begin
      Printf.printf "\nUsage: %s infile source sink outfile\n\n%!" Sys.argv.(0) ;
      exit 0
    end ;


  (* Arguments are : infile(1) source-id(2) sink-id(3) outfile(4) *)

  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(4)
  and outfiledot = Sys.argv.(4)^".dot";
  (* These command-line arguments are not used for the moment. *)
  and _source = int_of_string Sys.argv.(2)
  and _sink = int_of_string Sys.argv.(3)
  in

  
  (* Open file *)
  
  let graph = from_file infile in

  let graph_int = gmap graph int_of_string in

  (* Get path *)
  (*let path=find_path graph_int [] _source _sink in

  show_path path;*)
    
  (*algo*)
  let graph_algo=fold_fulkerson graph_int _source _sink in
  let graph_algo_string = gmap graph_algo string_of_int in

  (* Rewrite the graph that has been read. *)
  let () = write_file outfile graph in

  (* export to svg *)
  let () = export (outfile^"_original.dot") graph in
  let () = export outfiledot graph_algo_string in

  
  ()

