#!/bin/bash

function pg_db_exists() {
    local db=$1
    psql -l | grep ${db} --silent
    return $?
}

function create_pg_db() {
    echo "Trying to create database ${1}"
    createdb ${1} || die "failed to create database ${1}"
}

function create_pg_user() {
    echo "Trying to create user ${1}"
    silently createuser $1 --createdb
}

function pg_schema_grants() {
    local db_name=$1
    local user_name=$2
    local schema_name=$3

    echo "Trying to grant ${user_name} of db ${db_name} permissions to schema ${schema_name}"

    cat <<EOF | psql ${db_name}
    grant all privileges on database "${db_name}" to ${user_name};
    create schema ${schema_name} authorization ${user_name};
    grant all privileges on schema "${schema_name}" to ${user_name};
    \q
EOF
}

function setup_pg_db() {
    local db_name=$1
    local user_name=$2
    local schema_name=$3

    if command_exists 'createdb'; then
        pg_db_exists ${db_name} || create_pg_db ${db_name}
    fi

    if command_exists 'createuser'; then
        create_pg_user ${user_name}
    fi

    pg_schema_grants ${db_name} ${user_name} ${schema_name}
}
