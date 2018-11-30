#!/usr/bin/env bash

DIR_CONTAINS_THIS_SCRIPT=$(dirname $(readlink -f $0))

if [ "x${NDK_ROOT}" = "x" ]; then
    echo "NDK_ROOT not set"
    exit 1
elif [ ! -f ${NDK_ROOT}/build/core/main.mk ]; then
    echo "NDK_ROOT is incorrect, please have a check"
    exit 1
fi

make NDK_ROOT=${NDK_ROOT} -C ${DIR_CONTAINS_THIS_SCRIPT}/build libbase.cr.so
cp  ${DIR_CONTAINS_THIS_SCRIPT}/build/out/Debug/lib.target/libbase.cr.so ${DIR_CONTAINS_THIS_SCRIPT}/libbase.so
