#!/bin/bash

function ensure_package() {
    local package_name=$1
    echo "Ensuring package $package_name is installed..."
    if which yum ; then
        sudo yum install --assumeyes $package_name
    elif which apt-get ; then
        sudo apt-get install -y $package_name
    elif  which brew ; then
        brew install $package_name
    else
        echo "Package $package_name FAILURE"
        die "Don't know how to install package $package_name on your OS"
    fi
    echo "Package $package_name OK"
}
