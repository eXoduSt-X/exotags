cmake_minimum_required(VERSION 3.14)

set(PROJECT_NAME "rust_lib_audiotags")
project(${PROJECT_NAME} LANGUAGES CXX)

include("../cargokit/cmake/cargokit.cmake")

# Parche: resolver symlink del plugin primero, luego navegar a rust/.
# En Flutter Windows, CMAKE_CURRENT_SOURCE_DIR puede ser un symlink
# (.plugin_symlinks/rust_lib_audiotags/windows), y los ../ contados
# desde ahí dan una ruta equivocada. REALPATH resuelve el symlink
# antes de navegar, así que ../../rust llega al paquete Rust correcto.
# Referencia: https://github.com/wang-bin/fvp/issues/367
get_filename_component(PLUGIN_SOURCE_DIR_REAL "${CMAKE_CURRENT_SOURCE_DIR}" REALPATH)
get_filename_component(RUST_MANIFEST_DIR "${PLUGIN_SOURCE_DIR_REAL}/../../rust" REALPATH)

apply_cargokit(${PROJECT_NAME} "${RUST_MANIFEST_DIR}" rust_lib_audiotags "")

set(rust_lib_audiotags_bundled_libraries
  "${${PROJECT_NAME}_cargokit_lib}"
  PARENT_SCOPE
)
