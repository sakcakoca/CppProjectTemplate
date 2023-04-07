
# Find Google Test package
find_package(GTest REQUIRED COMPONENTS gtest gmock gtest_main gmock_main)

# Tests need to be added as executables first
set(TEST_EXECUTABLE_NAME "ProjectTemplateTester")
add_executable(${TEST_EXECUTABLE_NAME} ProjectTemplateTester.cpp)

# I'm using C++20 in the test
target_compile_features(${TEST_EXECUTABLE_NAME} PRIVATE cxx_std_20)


# Should be linked to the main library, as well as the GoogleTest testing library
target_link_libraries(${TEST_EXECUTABLE_NAME} PRIVATE projecttemplate_library GTest::gtest GTest::gtest_main)


# Discover tests for ctest
include(GoogleTest)
gtest_discover_tests(${TEST_EXECUTABLE_NAME})