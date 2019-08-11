# Copyright (c) 2019 University of Oxford
# Distributed under the OSI-approved MIT License.  See accompanying
# file LICENSE or https://opensource.org/licenses/MIT for details.

#[=======================================================================[.rst:
FindRAT
-------

Finds the RAT library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``RAT::RAT``
  The RAT library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``RAT_FOUND``
  True if the system has the RAT library.
``RAT_VERSION``
  The version of the RAT library which was found.
``RAT_INCLUDE_DIRS``
  Include directories needed to use RAT.
``RAT_LIBRARIES``
  Libraries needed to link to RAT.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``RAT_INCLUDE_DIR``
  The directory containing ``local_g4compat.hh``.
``RAT_LIBRARY``
  The path to the RAT library.

#]=======================================================================]

set(ENV_RAT_ROOT $ENV{RATROOT})
if (NOT ENV_RAT_ROOT)
    message(SEND_ERROR "No environment variable for RATROOT was set.")
endif ()

find_path(
        RAT_INCLUDE_DIR
        NAMES local_g4compat.hh
        PATHS ${ENV_RAT_ROOT}/include
)

if (BUILD_SHARED_LIBS)
    set(RAT_LIB_NAME libRATEvent_Linux.so)
else ()
    set(RAT_LIB_NAME librat_Linux.a)
endif ()

find_library(
        RAT_LIBRARY
        NAMES ${RAT_LIB_NAME}
        PATHS ${ENV_RAT_ROOT}/lib
)

string(REGEX MATCH [=[rat\-(.+)$]=] RAT_VERSION ${ENV_RAT_ROOT})
set(RAT_VERSION ${CMAKE_MATCH_1})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
        RAT
        FOUND_VAR RAT_FOUND
        REQUIRED_VARS RAT_LIBRARY RAT_INCLUDE_DIR
        VERSION_VAR RAT_VERSION
)

if (RAT_FOUND)
    set(RAT_LIBRARIES ${RAT_LIBRARY})
    set(RAT_INCLUDE_DIRS ${RAT_INCLUDE_DIR})
    set(RAT_DEFINITIONS $ENV{RAT_CFLAGS})
endif ()

if (RAT_FOUND AND NOT TARGET RAT::RAT)
    add_library(RAT::RAT UNKNOWN IMPORTED)
    set_target_properties(
            RAT::RAT PROPERTIES
            IMPORTED_LOCATION "${RAT_LIBRARY}"
            INTERFACE_COMPILE_OPTIONS "$ENV{RAT_CFLAGS}"
            INTERFACE_INCLUDE_DIRECTORIES "${RAT_INCLUDE_DIR}"
    )
endif ()

mark_as_advanced(
        RAT_INCLUDE_DIR
        RAT_LIBRARY
)


