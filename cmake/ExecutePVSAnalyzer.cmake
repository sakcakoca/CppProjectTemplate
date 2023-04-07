function(runPVSAnalyzer)
    execute_process(COMMAND pvs-studio --version 
                    OUTPUT_VARIABLE PVS_VERSION_COMMAND_OUTPUT)
    message(STATUS "PVS version command output: ${PVS_VERSION_COMMAND_OUTPUT}")
    
    if(PVS_VERSION_COMMAND_OUTPUT STREQUAL "")
        message(WARNING "pvs-studio command not found.")
        return()
    endif()
    
    execute_process(COMMAND ${PVS_ANALYZER_EXECUTABLE} analyze -f ${COMPILE_COMMANDS_JSON_PATH} 
                    -l ${PVS_LICENSE_PATH} -o ${PVS_REPORT_LOG_PATH} 
                    -e ${PVS_EXCLUDE_DIRECTORY} -j2
                    OUTPUT_VARIABLE PVS_ANALYZE_COMMAND_OUTPUT)
    
    message(STATUS "${PVS_ANALYZE_COMMAND_OUTPUT}")
    
    execute_process(COMMAND ${PVS_LOG_CONVERTER_EXECUTABLE} -a GA:1,2 
                    -t json -o ${PVS_REPORT_JSON_PATH} ${PVS_REPORT_LOG_PATH}
                    OUTPUT_VARIABLE PVS_LOG_CONVERT_COMMAND_OUTPUT)
        
    message(STATUS "${PVS_LOG_CONVERT_COMMAND_OUTPUT}")
endfunction()

set(COMPILE_COMMANDS_JSON_PATH "${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json")
set(PVS_REPORT_LOG_PATH "${CMAKE_CURRENT_BINARY_DIR}/pvs_report.log")
set(PVS_REPORT_JSON_PATH "${CMAKE_CURRENT_BINARY_DIR}/pvs_report.json")
set(PVS_EXCLUDE_DIRECTORY "${PROJECT_SOURCE_DIR}/test")

if(WIN32)
    message(STATUS "Operating system detected as WIN32")
    set(PVS_LICENSE_PATH "$ENV{APPDATA}/PVS-Studio/Settings.xml")
    set(PVS_ANALYZER_EXECUTABLE "CompilerCommandsAnalyzer.exe")
    set(PVS_LOG_CONVERTER_EXECUTABLE "PlogConverter.exe")

    runPVSAnalyzer()
elseif(UNIX)
    message(STATUS "Operating system detected as UNIX")
    set(PVS_LICENSE_PATH "$ENV{HOME}/.config/PVS-Studio/PVS-Studio.lic")
    set(PVS_ANALYZER_EXECUTABLE "pvs-studio-analyzer")
    set(PVS_LOG_CONVERTER_EXECUTABLE "plog-converter")

    runPVSAnalyzer()
else()
    message(STATUS "Operating system is not WIN32 or UNIX")
endif()

