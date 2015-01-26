OPAM_DEPENDS=
         
setup_linux () {
  case "$OCAML_VERSION,$OPAM_VERSION" in
  4.02.1,1.2.0) ppa=avsm/ocaml42+opam12 ;;
  4.02.1,1.1.0) ppa=avsm/ocaml42+opam11 ;;
  4.01.0,1.2.0) ppa=avsm/ocaml41+opam12 ;;
  4.01.0,1.1.0) ppa=avsm/ocaml41+opam11 ;;
  *) echo Unknown $OCAML_VERSION,$OPAM_VERSION; exit 1 ;;
  esac

  echo "yes" | sudo add-apt-repository ppa:$ppa
  sudo apt-get update -qq
  sudo apt-get install -qq ocaml ocaml-native-compilers camlp4-extra opam libelf-dev
  export OPAMYES=1
  # We could in theory tell opam to init with a particular version of ocaml,
  # but this is much slower than using the ppa
  opam init -a -y
  # TODO: Install js_of_ocaml and test the parser
  # opam install ${OPAM_DEPENDS}
  eval `opam config env`
}

setup_osx () {
  if [[ ${OCAML_VERSION} == 4.01.0 ]]; then
    brew install ocaml
  fi
  if [[ ${OPAM_VERSION} == 1.1.0 ]]; then
    brew install opam
  fi

  brew update

  if [[ ${OCAML_VERSION} == 4.02.1 ]]; then
    brew install ocaml
  fi
  if [[ ${OPAM_VERSION} == 1.2.0 ]]; then
    brew install opam
  fi
  # We could in theory tell opam to init with a particular version of ocaml,
  # but this is much slower than using the one installed by brew
  opam init -a -y
  # TODO: Install js_of_ocaml and test the parser
  # opam install ${OPAM_DEPENDS}
  eval `opam config env`
}

case $TRAVIS_OS_NAME in
  osx) setup_osx ;;
linux) setup_linux ;;
esac

make
make test
