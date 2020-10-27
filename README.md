Project OCaml
==== 
Brief introduction
---
Base project for Ocaml project on Ford-Fulkerson. This project contains some simple configuration files to facilitate editing Ocaml in VSCode.

To use, you should install the *OCaml* extension in VSCode. Other extensions might work as well but make sure there is only one installed.
Then open VSCode in the root directory of this repository.

Features :
 - full compilation as VSCode build task (Ctrl+Shift+b)
 - highlights of compilation errors as you type
 - code completion
 - automatic indentation on file save


A makefile also provides basic automation :
 - `make` to compile. This creates an ftest.native executable
 - `make format` to indent the entire project

Usage
---
* Should do `make` firstly, after execute the code below , then if you want to get svg , please do this `dot -Tsvg outfile.dot > outfile.svg` where `outfile` should be the name of the file output and it cand be changed
    > Direct `./ftest.native infile source:int sink:int outfile`

* Shell code below which is contained in the ./command.sh. Remember to do `chmod +x command.sh` so that the command can be executed 
    > `./command.sh infile source:int sink:int outfile`
