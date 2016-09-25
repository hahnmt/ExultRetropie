#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="exult"
rp_module_desc="Exult - Ultima 7 engine"
rp_module_section="exp"

function depends_exult() {
    getDepends automake libsdl2-dev autoconf libtool zlib1g-dev libvorbis0a libvorbisenc2 libvorbisfile3 libvorbis-dev 	
	#libsdl1.2-dev timidity 
}

function sources_exult() {
    gitPullOrClone "$md_build" https://github.com/exult/exult.git
}

function build_exult() {
    ./autogen.sh
	#default raspberry pi 3 buildflags cause a crash in game, force RPI2 build settings
	./configure CFLAGS="-O2 -mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard" CXXFLAGS="-O2 -mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard" --prefix="$md_inst" --with-sdl=sdl2

	make
    md_ret_require="$md_build/exult"
}

function install_exult() {
    make install
}

function configure_exult() {
    mkRomDir "ports/exult"
	mkRomDir "ports/exult/data"
	mkRomDir "ports/exult/data/blackgate"
    mkRomDir "ports/exult/data/serpentisle"
	#move the main data directory
	moveConfigDir "$md_inst/share/exult" "/home/pi/RetroPie/roms/ports/exult/data"
	
	#move all configs
	moveConfigDir "$home/.exult" "$md_conf_root/exult/configdir"
	moveConfigFile "$home/.exult.cfg" "$md_conf_root/exult/exult.cfg"
	
    addPort "$md_id" "exult" "Exult ultima 7" "$md_inst/bin/exult"

	#TODO
	#automate digital audio install/configuration?
	#move Saves?   mkRomDir "ports/exult/saves"
    #create Exult default configuration
    #chown $user:$user "$md_conf_root/exult/exult.cfg"
}
