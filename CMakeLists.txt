cmake_minimum_required(VERSION 3.7.2)

# Include our common helpers
list(
    APPEND
        CMAKE_MODULE_PATH
        ${CMAKE_CURRENT_LIST_DIR}/kernel
        ${CMAKE_CURRENT_LIST_DIR}/tools/cmake-tool/helpers/
        ${CMAKE_CURRENT_LIST_DIR}/tools/elfloader-tool/
)

find_package(seL4 REQUIRED)
sel4_configure_platform_settings()

project(zig_sel4 NONE)

include(settings.cmake)

add_subdirectory(kernel)
add_subdirectory(kernel/libsel4)
add_subdirectory(tools/elfloader-tool)
add_subdirectory(util_libs)
add_subdirectory(zig_rootserver)
