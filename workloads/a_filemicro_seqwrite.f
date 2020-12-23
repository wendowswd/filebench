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

# Single threaded asynchronous ($sync) sequential writes (4KB I/Os) to a file.
# Stops when 128MB ($bytes) has been written.

set $dir=/home/wenduo/unvmfs/tmp
set $bytes=128m
set $cached=false
set $filesize=0
set $iosize=4k
set $iters=1
set $nthreads=1
set $sync=false

define file name=bigfile,path=$dir,size=$filesize,prealloc,reuse,cached=$cached

define process name=filewriter,instances=1
{
  thread name=filewriterthread,memsize=10m,instances=$nthreads
  {
    flowop appendfile name=write-file,dsync=$sync,filename=bigfile,iosize=$iosize,iters=$iters
    flowop finishonbytes name=finish,value=$bytes
  }
}

echo  "FileMicro-SeqWrite Version 2.2 personality successfully loaded"
usage "Usage: set \$dir=<dir>"
usage "       set \$cached=<bool>    defaults to $cached"
usage "       set \$count=<value>    defaults to $count"
usage "       set \$iosize=<size>    defaults to $iosize"
usage "       set \$nthreads=<value> defaults to $nthreads"
usage "       set \$sync=<bool>      defaults to $sync"
usage " "
usage "       run runtime (e.g. run 60)"
