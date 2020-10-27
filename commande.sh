#!/bin/bash

eval `opam config env`

export OCAMLRUNPARAM=b

make
