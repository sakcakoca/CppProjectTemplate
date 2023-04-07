#Check if conan major version is equal to 2. If not fail immediately.
execute_process(COMMAND conan --version OUTPUT_VARIABLE CONAN_VERSION_COMMAND_OUTPUT)
message(STATUS "Conan version command output: ${CONAN_VERSION_COMMAND_OUTPUT}") # CONAN_VERSION_COMMAND_OUTPUT should be equal something like "Conan version 2.0.1"

if(CONAN_VERSION_COMMAND_OUTPUT STREQUAL "")
    message(FATAL_ERROR "conan command not found. Please install conan2 via: pip install conan --upgrade")
else()
    string(REPLACE " " ";" CONAN_VERSION_COMMAND_OUTPUT_SPLITTED ${CONAN_VERSION_COMMAND_OUTPUT}) # Split version command output to list. e.g. ["Conan", "version", "2.0.1"]
    list(GET CONAN_VERSION_COMMAND_OUTPUT_SPLITTED 2 CONAN_FULL_VERSION) # 2. parameter of list is the conan version number. e.g. "2.0.1"
    message(STATUS "Conan version number: ${CONAN_FULL_VERSION}")

    string(REPLACE "." ";" CONAN_FULL_VERSION_SPLITTED ${CONAN_FULL_VERSION}) # Split version number e.g. ["2", "0", "1"]
    list(GET CONAN_FULL_VERSION_SPLITTED 0 CONAN_MAJOR_VERSION) # 0. parameter of list is the conan major version number. e.g. "2"
    message(STATUS "Conan major version number: ${CONAN_MAJOR_VERSION}")

    if(NOT CONAN_MAJOR_VERSION MATCHES "2")
        message(FATAL_ERROR "conan version is not matching conan 2. Please install conan2 via: pip install conan --upgrade")
    endif()
endif()

#Check if default profile is configured for conan. If not create a default profile.
execute_process(COMMAND conan profile path default OUTPUT_VARIABLE CONAN_DEFAULT_PROFILE_PATH)
message(STATUS "Conan default profile path: ${CONAN_DEFAULT_PROFILE_PATH}")

if(CONAN_DEFAULT_PROFILE_PATH STREQUAL "")
    message(STATUS "Default profile path could not found for conan. Running conan profile detect")
    execute_process(COMMAND conan profile detect --force)
endif()

#Install conan dependencies defined in conanfile.txt
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    execute_process(COMMAND conan install ${CMAKE_SOURCE_DIR}/conanfile.txt --output-folder=${CMAKE_SOURCE_DIR}/out/build --build=missing --settings:host build_type=Debug)
else()
    execute_process(COMMAND conan install ${CMAKE_SOURCE_DIR}/conanfile.txt --output-folder=${CMAKE_SOURCE_DIR}/out/build --build=missing --settings:host build_type=Release)
endif()