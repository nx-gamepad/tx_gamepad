cmake_minimum_required(VERSION 3.10)

set(EPHEMERAL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/ephemeral")

include(FetchContent)

set(STEAMWORKS_SDK_VERSION "sdk_158")

FetchContent_Declare(
  steamworks_sdk
  URL https://partner.steamgames.com/downloads/steamworks_${STEAMWORKS_SDK_VERSION}.zip
  DOWNLOAD_NO_EXTRACT TRUE
)

FetchContent_GetProperties(steamworks_sdk)
if(NOT steamworks_sdk_POPULATED)
  FetchContent_Populate(steamworks_sdk)
endif()

set(STEAMWORKS_BUILD_DIR "${PROJECT_BUILD_DIR}steamworks")

file(MAKE_DIRECTORY "${STEAMWORKS_BUILD_DIR}")

set(STEAMWORKS_SDK_BUILD_DIR "${STEAMWORKS_BUILD_DIR}/${STEAMWORKS_SDK_VERSION}")

function(copy_steamworks_library)
  file(MAKE_DIRECTORY "${EPHEMERAL_DIR}/steam")
  
  file(GLOB HEADER_FILES "${STEAMWORKS_SDK_BUILD_DIR}/public/steam/*.h")

  foreach(HEADER_FILE ${HEADER_FILES})
    file(COPY "${HEADER_FILE}" DESTINATION "${EPHEMERAL_DIR}/steam")
  endforeach()

  file(COPY "${STEAMWORKS_SDK_BUILD_DIR}/redistributable_bin/linux64/libsteam_api.so" DESTINATION "${EPHEMERAL_DIR}")
endfunction()

if(NOT EXISTS ${STEAMWORKS_SDK_BUILD_DIR})
  execute_process(
    COMMAND unzip -q ${steamworks_sdk_SOURCE_DIR}/steamworks_sdk_159.zip
    WORKING_DIRECTORY ${STEAMWORKS_BUILD_DIR}
  )

  file(RENAME ${STEAMWORKS_BUILD_DIR}/sdk ${STEAMWORKS_SDK_BUILD_DIR})

  copy_steamworks_library()
endif()

if(NOT EXISTS "${EPHEMERAL_DIR}")
  copy_steamworks_library()
endif()

set(STEAMWORKS_LIBRARY "${EPHEMERAL_DIR}/libsteam_api.so")
set(STEAMWORKS_LIBRARY "${STEAMWORKS_LIBRARY}" PARENT_SCOPE)

add_library(steamworks INTERFACE)
target_include_directories(steamworks INTERFACE
  "${EPHEMERAL_DIR}"
)
target_link_libraries(steamworks INTERFACE "${STEAMWORKS_LIBRARY}")
