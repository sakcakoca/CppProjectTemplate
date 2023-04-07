# Works with 3.20
cmake_minimum_required(VERSION 3.20)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Set standard project settings
include(cmake/StandardProjectSettings.cmake)
include(cmake/PreventInSourceBuilds.cmake)

#Execute conan install
include(cmake/ExecuteConanInstall.cmake)

# Project name and a few useful settings. Other commands can pick up the results
project(
  ProjectTemplate
  VERSION 0.1
  DESCRIPTION "ProjectTemplate project with CMake"
  LANGUAGES CXX)
  
# Only do these if this is the main project, and not if it is included through add_subdirectory
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)

  # Optionally set things like CMAKE_CXX_STANDARD, CMAKE_POSITION_INDEPENDENT_CODE here
  set(CMAKE_CXX_STANDARD 20)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)

  #Set compiler warnings
  add_library(project_warnings INTERFACE)
  include(cmake/CompilerWarnings.cmake)
  set_project_warnings(project_warnings)

  #Set ansi standard. Needed for clang tidy
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D__STRICT_ANSI__")
  
  # Let's ensure -std=c++xx instead of -std=g++xx
  set(CMAKE_CXX_EXTENSIONS OFF)

  # Let's nicely support folders in IDEs
  set_property(GLOBAL PROPERTY USE_FOLDERS ON)

  # Testing only available if this is the main app
  # Note this needs to be done in the main CMakeLists
  # since it calls enable_testing, which must be in the
  # main CMakeLists.
  include(CTest)

  # Docs only available if this is the main app
  find_package(Doxygen)
  if(Doxygen_FOUND)
    add_subdirectory(docs)
  else()
    message(STATUS "Doxygen not found, not building docs")
  endif()

  #Create a pvs analyzer project so it can create static analysis report
  include(cmake/FindPVSExecutable.cmake)
  find_PVS_executable(PVS_FOUND)
  if(PVS_FOUND)
    add_subdirectory(pvs)
  else()
    message(STATUS "PVS Studio executable not found, not building PVS target")
  endif()
  
endif()

# Add coverage report generator flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage")

# The compiled library code is here
add_subdirectory(src)

# The executable code is here
add_subdirectory(apps)

# Testing only available if this is the main app
# Emergency override STRING_CALCULATOR_BUILD_TESTING provided as well
if((CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME OR STRING_CALCULATOR_BUILD_TESTING)
   AND BUILD_TESTING)
  add_subdirectory(test)
endif()