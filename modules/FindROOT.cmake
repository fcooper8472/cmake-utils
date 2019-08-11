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

``ROOT:ROOT``
  The ROOT library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``ROOT_FOUND``
  True if the system has the ROOT library.
``ROOT_VERSION``
  The version of the ROOT library which was found.
``ROOT_INCLUDE_DIRS``
  Include directories needed to use ROOT.
``ROOT_LIBRARIES``
  Libraries needed to link to ROOT.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``ROOT_INCLUDE_DIR``
  The directory containing ``ZipLZMA.h``.
``ROOT_LIBRARY``
  The path to the ROOT library.

#]=======================================================================]

set(ENV_ROOT_ROOT $ENV{ROOTSYS})
if (NOT ENV_ROOT_ROOT)
    message(SEND_ERROR "No environment variable for ROOTSYS was set.")
endif ()

find_path(
        ROOT_INCLUDE_DIR
        NAMES ZipLZMA.h
        PATHS ${ENV_ROOT_ROOT}/include
)

find_library(
        ROOT_LIBRARY
        NAMES libRootAuth.so
        PATHS ${ENV_ROOT_ROOT}/lib
)

string(REGEX MATCH [=[root\-(.+)$]=] ROOT_VERSION ${ENV_ROOT_ROOT})
set(ROOT_VERSION ${CMAKE_MATCH_1})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
        ROOT
        FOUND_VAR ROOT_FOUND
        REQUIRED_VARS ROOT_LIBRARY ROOT_INCLUDE_DIR
        VERSION_VAR ROOT_VERSION
)

if (ROOT_FOUND)
    set(ROOT_LIBRARIES ${ROOT_LIBRARY})
    set(ROOT_INCLUDE_DIRS ${ROOT_INCLUDE_DIR})
    set(ROOT_DEFINITIONS $ENV{ROOT_CFLAGS})
endif ()

if (ROOT_FOUND AND NOT TARGET ROOT::ROOT)
    add_library(ROOT::ROOT UNKNOWN IMPORTED)
    set_target_properties(
            ROOT::ROOT PROPERTIES
            IMPORTED_LOCATION "${ROOT_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${ROOT_INCLUDE_DIR}"
    )
endif ()

mark_as_advanced(
        ROOT_INCLUDE_DIR
        ROOT_LIBRARY
)


