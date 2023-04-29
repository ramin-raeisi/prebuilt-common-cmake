macro(verify_and_fetch_prebuilt_dependency dependency_name)
  set(options)
  set(oneValueArgs BASE_URL)
  set(multiValueArgs)
  cmake_parse_arguments(ARGUMENT "${options}" "${oneValueArgs}" "${multiValueArgs}")

  if (NOT ARGUMENT_BASE_URL)
    set(ARGUMENT_BASE_URL "https://github.com/ramin-raeisi/prebuilt-${dependency_name}.git")
  else()
    set(ARGUMENT_BASE_URL "${ARGUMENT_BASE_URL}${dependency_name}.git")
  endif()

  set(EXTERNALS_DIR ${CMAKE_SOURCE_DIR}/externals)
  if(NOT EXISTS ${EXTERNALS_DIR})
    file(MAKE_DIRECTORY ${EXTERNALS_DIR})
  endif()

  set(OUTPUT)
  if(NOT EXISTS ${EXTERNALS_DIR}/${dependency_name})
    message(STATUS "Fetching ${dependency_name}...")
    execute_process(
        COMMAND cmd /c "git clone --depth 1 ${ARGUMENT_BASE_URL} externals/${dependency_name}"
		WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
		OUTPUT_QUIET
		ERROR_QUIET
      )
  else()
    message(STATUS "Resetting HEAD of ${dependency_name}...")
    execute_process(
        COMMAND cmd /c "git reset HEAD --hard"
		WORKING_DIRECTORY ${EXTERNALS_DIR}/${dependency_name}
		OUTPUT_QUIET
		ERROR_QUIET
      )
  endif()
  include(${EXTERNALS_DIR}/${dependency_name}/${dependency_name}.cmake)
endmacro()