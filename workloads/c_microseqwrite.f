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

set $dir=/mnt/pmem0_wenduo/tmp
set $nfiles=100
set $cached=false
set $iosize=4k
set $iters=1
set $nthreads=1
set $sync=true
set $bytes=1g

define randvar name=$dirwidth,type=gamma,min=1,round=1,mean=512
define randvar name=$filesize,type=gamma,min=4k,round=4k,mean=64k

define fileset name=bigfileset,path=$dir,size=$filesize,entries=$nfiles,dirwidth=$dirwidth,prealloc

define process name=filewriter,instances=1
{
  thread name=filewriterthread,memsize=0m,instances=$nthreads
  {
    flowop write name=write-file,dsync=$sync,filename=bigfileset,iosize=$iosize,iters=$iters
    flowop finishonbytes name=finish,value=$bytes
  }
}

run 60

echo  "FileMicro-SeqWrite Version 2.2 personality successfully loaded"
usage "Usage: set \$dir=<dir>"
usage "       set \$cached=<bool>    defaults to $cached"
usage "       set \$count=<value>    defaults to $count"
usage "       set \$iosize=<size>    defaults to $iosize"
usage "       set \$nthreads=<value> defaults to $nthreads"
usage "       set \$sync=<bool>      defaults to $sync"
usage " "
usage "       run runtime (e.g. run 60)"
