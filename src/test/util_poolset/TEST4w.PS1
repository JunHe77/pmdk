# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2017-2019, Intel Corporation

#
# src/test/util_poolset/TEST4w -- unit test for util_pool_open()
#

. ..\unittest\unittest.ps1

require_test_type medium
require_fs_type non-pmem

setup

$Env:TEST_LOG_LEVEL = "4"
$Env:TEST_LOG_FILE = "test$Env:UNITTEST_NUM.log"

$MIN_POOL = 128 * 1024 * 1024 # 128MiB
$MIN_POOL_STR = ${MIN_POOL}.toString() + "B" # 128MiB
$RESVSIZE=4 * 1024 * 1024 * 1024 # 4GiB
$RESVSIZE_STR = ${RESVSIZE}.toString() + "B" # 4GiB

$REQUIRE_POOL = ${MIN_POOL} * 12
require_free_space "${REQUIRE_POOL}b"

create_poolset $DIR\testset1 `
	${RESVSIZE_STR}:$DIR\testdir11:d `
	O SINGLEHDR
create_poolset $DIR\testset2 `
	${RESVSIZE_STR}:$DIR\testdir21:d ${RESVSIZE_STR}:$DIR\testdir22:d `
	O SINGLEHDR
create_poolset $DIR\testset3 `
	${RESVSIZE_STR}:$DIR\testdir31:d R ${RESVSIZE_STR}:$DIR\testdir32:d `
	O SINGLEHDR
create_poolset $DIR\testset4 `
	${RESVSIZE_STR}:$DIR\testdir41:d ${RESVSIZE_STR}:$DIR\testdir42:d `
	R ${RESVSIZE_STR}:$DIR\testdir43:d ${RESVSIZE_STR}:$DIR\testdir44:d `
	O SINGLEHDR

# create pool sets
expect_normal_exit $Env:EXE_DIR\util_poolset$Env:EXESUFFIX c $MIN_POOL `
    $DIR\testset1 `
    $DIR\testset2 `
    $DIR\testset3 `
    $DIR\testset4

expect_normal_exit $Env:EXE_DIR\util_poolset$Env:EXESUFFIX o $MIN_POOL `
    $DIR\testset1 `
    $DIR\testset2 `
    $DIR\testset3 `
    $DIR\testset4

expect_normal_exit $Env:EXE_DIR\util_poolset$Env:EXESUFFIX e $MIN_POOL `
    $DIR\testset1 `
    $DIR\testset2 `
    $DIR\testset3 `
    $DIR\testset4

expect_normal_exit $Env:EXE_DIR\util_poolset$Env:EXESUFFIX e $MIN_POOL `
    $DIR\testset1 `
    $DIR\testset2 `
    $DIR\testset3 `
    $DIR\testset4

expect_normal_exit $Env:EXE_DIR\util_poolset$Env:EXESUFFIX e $MIN_POOL `
    $DIR\testset1 `
    $DIR\testset2 `
    $DIR\testset3 `
    $DIR\testset4

expect_normal_exit $Env:EXE_DIR\util_poolset$Env:EXESUFFIX o $MIN_POOL `
    $DIR\testset1 `
    $DIR\testset2 `
    $DIR\testset3 `
    $DIR\testset4

sls -Path $Env:TEST_LOG_FILE -Pattern "<1>" | `
    %{[string]$_ -replace '^.* len ',"" -replace '^.*][ ]*',''} `
    > grep$Env:UNITTEST_NUM.log

check

pass
