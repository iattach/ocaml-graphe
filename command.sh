#!/bin/bash

eval `opam config env`

export OCAMLRUNPARAM=b

make

if [ $# != 4 ]
then
    echo "Usage: 1:source 2:begin 3:end 4:output"
else 
    ./ftest.native $1 $2 $3 $4
    
    `dot -Tsvg $4.dot > $4.svg`
fi



