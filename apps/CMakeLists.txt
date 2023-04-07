find_package(FMT REQUIRED)

set(APP_EXECUTABLE_NAME "ProjectTemplateApp")

add_executable(${APP_EXECUTABLE_NAME} ProjectTemplateApp.cpp)

target_compile_features(${APP_EXECUTABLE_NAME} PRIVATE cxx_std_20)

target_link_libraries(${APP_EXECUTABLE_NAME} PRIVATE projecttemplate_library fmt::fmt)
