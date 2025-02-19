cmake_minimum_required(VERSION 3.27)

project(zig_rootserver)

set(SOURCES
  src/main.zig
  src/start.S
  build.zig
)

set(libsel4_opts
  "$<LIST:TRANSFORM,$<TARGET_PROPERTY:sel4,BINARY_DIR>,PREPEND,-Dlibrary=>"
  "$<LIST:TRANSFORM,$<TARGET_PROPERTY:sel4,INTERFACE_INCLUDE_DIRECTORIES>,PREPEND,-Dinclude=>"
  "$<LIST:TRANSFORM,$<TARGET_PROPERTY:sel4_autoconf,INTERFACE_INCLUDE_DIRECTORIES>,PREPEND,-Dinclude=>"
)

set(ZIG_BUILD_OPTIONS
  --prefix "${PROJECT_BINARY_DIR}"
  -Dtarget=${KernelSel4Arch}-freestanding-none
  "${libsel4_opts}"
)

add_custom_command(
  OUTPUT "${PROJECT_BINARY_DIR}/bin/zig_rootserver"
  COMMAND zig build "${ZIG_BUILD_OPTIONS}"
  COMMENT STATUS "Building zig rootserver"
  WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
  DEPENDS ${SOURCES} sel4
  COMMAND_EXPAND_LISTS
  VERBATIM
)

add_custom_target(rootserver
  COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_BINARY_DIR}/bin/zig_rootserver" "${PROJECT_BINARY_DIR}/rootserver"
  DEPENDS "${PROJECT_BINARY_DIR}/bin/zig_rootserver"
)

include(rootserver)
DeclareRootserver(rootserver)
include(simulation)
GenerateSimulateScript()
