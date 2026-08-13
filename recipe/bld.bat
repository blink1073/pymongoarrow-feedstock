set "MONGO_NO_COPY_LIBBSON=1"
set "LIBBSON_INSTALL_DIR=%LIBRARY_PREFIX%"
set "MONGO_CREATE_LIBARROW_SYMLINKS=0"

%PYTHON% -m pip install . --no-deps --no-build-isolation -vvv
if errorlevel 1 exit 1
