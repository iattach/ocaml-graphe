open Graph
open Printf
open Tools
open Gpath

(* A path is a list of nodes. *)
let fold_fulkerson gr src dest= 
  (*let gr_init = gmap gr (fun flow -> 0) in*)
  (*Printf.printf "test\n";*)
  let gr_edge = ref gr in
  let find=ref true 
  in while !find do 
    (*find path *)
    match find_path !gr_edge [] src dest with
      | Some path ->
      show_path (find_path !gr_edge [] src dest);
      (*Printf.printf "test";*)
      (*calculate the min flow *)
        let (_,min)=List.fold_left (
          fun acu id1 -> 
            let (start,min)=acu in
            let flow = find_arc !gr_edge start id1 in
            match flow with 
              | Some f ->
                if min = 0 then (id1, f)
                else if (f < min) && ( f != 0 ) then (id1, f )
                else (id1, min) 
              | None -> (start, min )
          ) (List.hd path,0) path in
          (*Printf.printf "min : %d\n" min;*)
      (*reduce the min from the path*)  
        List.iteri  
        (fun index id1 ->
          (*Printf.printf "test1 min %d index %d %b \n" min index  ((min != 0) && (index != 0 ) );*)
          if ((min != 0) && (index != 0 ) )then 
          let acu=List.nth path (index-1) in
          let flow = find_arc !gr_edge acu id1 in
          match flow with 
            | Some f ->
                gr_edge:=add_arc !gr_edge acu id1 (-min);                 
                gr_edge:=add_arc !gr_edge id1 acu min;
            | None -> ();
          
        ) path;
        
      (*No path *)  
      | None -> find := false;
    
  done;
  !gr_edge