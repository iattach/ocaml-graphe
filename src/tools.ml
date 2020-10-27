(* Yes, we have to repeat open Graph. *)
open Graph

(* assert false is of type ∀α.α, so the type-checker is happy. *)
let clone_nodes (gr:'a graph)= 
  let gr_clone=empty_graph in
  n_fold gr (fun gr_clone id -> new_node gr_clone id) gr_clone

let gmap gr f = 
  e_fold gr (fun gr_new id1 id2 lbl ->  new_arc gr_new id1 id2 (f lbl)) (clone_nodes gr)

let add_arc (g:int graph) id1 id2 n=
  match find_arc g id1 id2 with 
  | Some lbl -> new_arc g id1 id2 (lbl + n) 
  | None -> new_arc g id1 id2 n
  

  
