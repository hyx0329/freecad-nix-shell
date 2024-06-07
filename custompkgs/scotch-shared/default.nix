{
  lib,
  stdenv,
  fetchFromGitLab,
  bison,
  mpi,
  flex,
  zlib,
  cmake,
  gfortran9,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scotch-shared";
  version = "7.0.4";

  nativeBuildInputs = [ cmake gfortran9 ];
  buildInputs = [
    bison
    mpi
    flex
    zlib
  ];

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "scotch";
    repo = "scotch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uaox4Q9pTF1r2BZjvnU2LE6XkZw3x9mGSKLdRVUobGU=";
  };

  configurePhase = ''
    cmake -B build \
    -D CMAKE_INSTALL_PREFIX:PATH=$out/ \
    -D CMAKE_BUILD_TYPE:STRING=Release \
    -D BUILD_SHARED_LIBS:BOOL=ON \
    -D INSTALL_METIS_HEADERS:BOOL=OFF \
    -D COMMON_PTHREAD_FILE:BOOL=ON \
    -D SCOTCH_PTHREAD:BOOL=ON \
    -D SCOTCH_PTHREAD_MPI:BOOL=ON \
    -D COMMON_PTHREAD_AFFINITY_LINUX:BOOL=ON
    '';
  buildPhase = ''
    make -C build
    '';
  installPhase = ''
    cmake --install build
    '';

  meta = {
    description = "Graph and mesh/hypergraph partitioning, graph clustering, and sparse matrix ordering";
    longDescription = ''
      Scotch is a software package for graph and mesh/hypergraph partitioning, graph clustering,
      and sparse matrix ordering.
    '';
    homepage = "http://www.labri.fr/perso/pelegrin/scotch";
    license = lib.licenses.cecill-c;
    platforms = lib.platforms.linux;
  };
})