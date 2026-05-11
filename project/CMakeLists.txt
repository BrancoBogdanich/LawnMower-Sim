cmake_minimum_required(VERSION 3.22)

project(LawnMowerSim
    VERSION 0.1.0
    LANGUAGES CXX
)

# O3DE toolchain sets this
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${LY_ROOT_FOLDER}/cmake")

ly_add_target(
    NAME LawnMowerSim.GameLauncher APPLICATION
    NAMESPACE Gem
    FILES_CMAKE
        lawnmowersim_files.cmake
    INCLUDE_DIRECTORIES
        PUBLIC
            Source
    BUILD_DEPENDENCIES
        PRIVATE
            AZ::AzGameFramework
            Gem::ROS2
)

ly_set_gem_variant_to_load(TARGETS LawnMowerSim.GameLauncher VARIANTS Clients)
