# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Release")
  file(REMOVE_RECURSE
  "CMakeFiles\\Simulator_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\Simulator_autogen.dir\\ParseCache.txt"
  "Simulator_autogen"
  )
endif()
