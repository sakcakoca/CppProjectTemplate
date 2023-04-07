function(find_PVS_executable PVS_FOUND)
    
    set(${PVS_FOUND} FALSE PARENT_SCOPE)

    if (WIN32)
        set(PVS_EXECUTABLE "CompilerCommandsAnalyzer.exe")
        set(PVS_CONVERTER_EXECUTABLE "HtmlGenerator.exe")
    else()
        set(PVS_EXECUTABLE "pvs-studio-analyzer")
        set(PVS_CONVERTER_EXECUTABLE "plog-converter")
    endif()

    find_program(PVS_EXECUTABLE_FOUND ${PVS_EXECUTABLE})
    find_program(PVS_CONVERTER_EXECUTABLE_FOUND ${PVS_CONVERTER_EXECUTABLE})
    
    if(PVS_EXECUTABLE_FOUND AND PVS_CONVERTER_EXECUTABLE_FOUND)
        set(${PVS_FOUND} TRUE PARENT_SCOPE)
    endif()

endfunction(find_PVS_executable PVS_FOUND)
