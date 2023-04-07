message(STATUS "Compiler: ${CMAKE_CXX_COMPILER_ID}.  Build Type: ${CMAKE_BUILD_TYPE}. Simulate ID: ${CMAKE_CXX_SIMULATE_ID}")
#message(STATUS "Module_Paths: ${CMAKE_MODULE_PATH}")

# Set a default build type if none was specified
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to 'RelWithDebInfo' as none was specified.")
  set(CMAKE_BUILD_TYPE
      RelWithDebInfo
      CACHE STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui, ccmake
  set_property(
    CACHE CMAKE_BUILD_TYPE
    PROPERTY STRINGS
             "Debug"
             "Release"
             "MinSizeRel"
             "RelWithDebInfo")
endif()


if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
  add_compile_options(-fcolor-diagnostics)
  add_compile_options(-Wno-c++98-compat)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  add_compile_options(-fdiagnostics-color=always)
else()
  message(STATUS "No colored compiler diagnostic set for '${CMAKE_CXX_COMPILER_ID}' compiler.")
endif()


if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  add_compile_options(/Zc:__cplusplus)
endif()