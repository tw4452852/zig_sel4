cmake_minimum_required(VERSION 3.7.2)

find_package(Git QUIET)
if(GIT_FOUND AND EXISTS "${CMAKE_CURRENT_LIST_DIR}/.git")
# Update submodules as needed
    option(GIT_SUBMODULE "Check submodules during build" ON)
    if(GIT_SUBMODULE)
        message(STATUS "Submodule update")
        execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive
                        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                        RESULT_VARIABLE GIT_SUBMOD_RESULT)
        if(NOT GIT_SUBMOD_RESULT EQUAL "0")
            message(FATAL_ERROR "git submodule update --init --recursive failed with ${GIT_SUBMOD_RESULT}, please checkout submodules")
        endif()
    endif()
endif()

if(NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/kernel/CMakeLists.txt")
    message(FATAL_ERROR "The submodules were not downloaded! GIT_SUBMODULE was turned off or failed. Please update submodules and try again.")
endif()

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
