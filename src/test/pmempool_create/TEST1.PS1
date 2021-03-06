# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2016-2018, Intel Corporation
#
#
# pmempool_create/TEST1 -- test for creating pmemblk pool with btt layout
#

. ..\unittest\unittest.ps1

require_test_type medium

require_fs_type any
setup

$POOL="$DIR\file.pool"

# PMEMBLK with layout
expect_normal_exit $PMEMPOOL create -w blk 512 $POOL
check_file $POOL
check_signature PMEMBLK $POOL
check_arena $POOL

pass
