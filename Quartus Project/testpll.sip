set_global_assignment -entity "testpll" -library "lib_testpll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "testpll" -library "lib_testpll" -name IP_TOOL_VERSION "23.1"
set_global_assignment -entity "testpll" -library "lib_testpll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_testpll" -name SPD_FILE [file join $::quartus(sip_path) "testpll.spd"]

set_global_assignment -library "lib_testpll" -name MISC_FILE [file join $::quartus(sip_path) "testpll_sim/testpll.vo"]
