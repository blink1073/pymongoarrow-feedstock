#!/bin/bash
set -eux

export MONGO_NO_COPY_LIBBSON=1
export LIBBSON_INSTALL_DIR="${PREFIX}"
export MONGO_CREATE_LIBARROW_SYMLINKS=0
export LDFLAGS="${LDFLAGS} -Wl,-rpath,${PREFIX}/lib"
export CMAKE_GENERATOR=Ninja

# find_program(cython) in CMakeLists.txt picks up the host-prefix cython
# script, whose shebang (padded for conda-build's later prefix replacement)
# exceeds Linux's shebang length limit and silently runs under the wrong
# interpreter. Shim it with a short script that invokes cython as a module
# instead, and put it first on PATH.
mkdir -p "${SRC_DIR}/_cmake_shims"
cat > "${SRC_DIR}/_cmake_shims/cython" <<SHIM
#!/bin/sh
exec "${PYTHON}" -m cython "\$@"
SHIM
chmod +x "${SRC_DIR}/_cmake_shims/cython"
export PATH="${SRC_DIR}/_cmake_shims:${PATH}"

"${PYTHON}" -m pip install . --no-deps --no-build-isolation -vvv
