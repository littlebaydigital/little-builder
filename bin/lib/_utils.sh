#!/bin/bash

function die() {
	echo $1
	exit 1
}

function ensureVar() {
    local varName=$1
		local testVal=''
		eval 'testVal=$'$varName
    [[ -n "$testVal" ]] || die "$varName must be set"
}

function silently {
    $@ 2>&1 >/dev/null
}

function remote_exists {
    local remote_name=$1
    git remote -v | grep ${remote_name} 2>&1 >/dev/null
    return $?
}

function gem_exists {
    local gem_name=$1
    gem list | grep ${gem_name} 2>&1 >/dev/null
    return $?
}

function install_gem {
    local gem=$1
    gem_exists ${gem} || gem install ${gem} --no-rdoc --no-ri
}

function add_remote {
    local remote_name=$1
    local remote_url=$2
    git remote add ${remote_name} ${remote_url}
}

function command_exists() {
    command -v ${1} > /dev/null
    return $?
}
