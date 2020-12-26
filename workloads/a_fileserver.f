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

set $dir=/home/wenduo/unvmfs/tmp
set $nfiles=10000
set $nthreads=50
set $sync=false
set $riters=1
set $witers=2
set $riosize=16k
set $wiosize=16k

define randvar name=$dirwidth,type=gamma,min=128,round=1,mean=512
define randvar name=$filesize,type=gamma,min=4k,round=4k,mean=128k

define fileset name=bigfileset,path=$dir,size=$filesize,entries=$nfiles,dirwidth=$dirwidth,prealloc

define process name=filereader,instances=1
{
  thread name=filereaderthread,memsize=10m,instances=$nthreads
  {
    flowop read name=read-file,filesetname=bigfileset,random,iosize=$riosize,iters=$riters
    flowop write name=write-file,filesetname=bigfileset,random,dsync=$sync,iosize=$wiosize,iters=$witers
  }
}

run 60

echo  "File-server Version 3.0 personality successfully loaded"
usage "Usage: set \$dir=<dir>"
usage "       set \$meanfilesize=<size>     defaults to $meanfilesize"
usage "       set \$nfiles=<value>      defaults to $nfiles"
usage "       set \$nthreads=<value>    defaults to $nthreads"
usage "       set \$meanappendsize=<value>  defaults to $meanappendsize"
usage "       set \$iosize=<size>  defaults to $iosize"
usage "       set \$meandirwidth=<size> defaults to $meandirwidth"
usage "       run runtime (e.g. run 60)"
