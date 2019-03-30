{ pkgs ? import <nixpkgs> {} }:
with pkgs; mkShell {
    name = "Python";
    buildInputs = [
        (with ocaml-ng.ocamlPackages_4_07; [
            ocaml
            findlib
            ocp-indent
            utop
        ])
        (python37.withPackages(ps: with ps; [
            flake8
        ]))
        jq
    ];
    shellHook = ''
        if [ $(uname -s) = "Darwin" ]; then
            alias ls="ls --color=auto"
            alias ll="ls -al"
        fi
        alias flake8="flake8 --ignore 'E124,E128,E201,E203,E241,E402,W503'"
    '';
}
