#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#
# Copyright 2008 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#
# ident	"%Z%%M%	%I%	%E% SMI"

# Single threaded asynchronous ($sync) append (4KB I/Os) on a file.
# Stops when 128MB ($bytes) has been written.

set $dir=/home/wenduo/unvmfs/tmp
set $bytes=128m
set $cached=false
set $filesize=0
set $iosize=4k
set $iters=1
set $nthreads=1
set $sync=false

define file name=bigfile1,path=$dir,size=$filesize,prealloc,cached=$cached

define process name=filewriter,instances=1
{
  thread name=fileappendthread,memsize=10m,instances=$nthreads
  {
    flowop appendfile name=append-file,filename=bigfile1,dsync=$sync,iosize=$iosize,iters=$iters
    flowop finishonbytes name=finish,value=$bytes
  }
}

run 60

echo  "FileMicro-WriteRand Version 2.1 personality successfully loaded"
usage "Usage: set \$dir=<dir>"
usage "       set \$bytes=<value>    defaults to $bytes"
usage "       set \$cached=<bool>    defaults to $cached"
usage "       set \$filesize=<size>  defaults to $filesize"
usage "       set \$iosize=<size>    defaults to $iosize"
usage "       set \$iters=<value>    defaults to $iters"
usage "       set \$nthreads=<value> defaults to $nthreads"
usage "       set \$sync=<bool>      defaults to $sync"
usage " "
usage "       run runtime (e.g. run 60)"
