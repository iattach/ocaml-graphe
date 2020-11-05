open Graph
open Printf
open Tools

(* A path is a list of nodes. *)
type path = id list

(* find_path gr forbidden id1 id2 
 *   returns None if no path can be found.
 *   returns Some p if a path p from id1 to id2 has been found. 
 *
 *  forbidden is a list of forbidden nodes (they have already been visited)
 *)

let find_path gr forbidden id1 id2 = 
  let rec find_id2 (forbidden,find) = fun src dest-> 
    match find_arc gr src dest with
    | Some lbl -> 
              if (lbl != 0) then
              (src::dest::[], true)
              else (src::[], false )
    | None -> 
              let out = out_arcs gr src in
              List.fold_left (
                fun acu (id,_)-> 
                  (*Printf.printf "map id %id" id;*)
                  match find_arc gr src id with
                  | Some flow -> 
                    if (flow != 0) &&  not (List.mem id forbidden) then 
                      let (path_find,fin)=find_id2 (src::forbidden,find) id dest in
                      let (path_now,status)=acu in
                      if fin && not(status) then 
                      (src::path_find,fin) 
                      else acu
                    else acu
                  | None -> raise Not_found
              ) ([],false) out
  in
  let (path,find)=find_id2 ([],false) id1 id2 in
  if find then Some path else None

let show_path path = 
  match path with
  | Some path -> Printf.printf "path = [";
            List.iter (fun id -> Printf.printf "%d -> " id) path ; 
                  Printf.printf "End]\n";
  | None -> Printf.printf "No path found\n"
  
