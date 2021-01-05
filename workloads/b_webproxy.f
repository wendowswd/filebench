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

set $dir=/mnt/pmem0_wenduo/tmp
set $nfiles=100
set $nthreads=50
set $sync=true
set $riters=5
set $witers=1
set $riosize=8k
set $wiosize=16k
set $cached=false

define randvar name=$dirwidth,type=gamma,min=128,round=1,mean=512
define randvar name=$filesize,type=gamma,min=16k,round=16k,mean=32k

#define file name=bigfile1,path=$dir,size=$filesize,prealloc,cached=$cached
define fileset name=bigfileset,path=$dir,size=$filesize,entries=$nfiles,dirwidth=$dirwidth,prealloc

define process name=webproxy,instances=1
{
  thread name=webproxythread,memsize=10m,instances=$nthreads
  {
    flowop openfile name=openfile1,filesetname=bigfileset,fd=1
    flowop read name=readfile1,filesetname=bigfileset,fd=1,random,iosize=$riosize,iters=$riters
    flowop write name=writefile1,filesetname=bigfileset,fd=1,random,dsync=$sync,iosize=$wiosize,iters=$witers
    flowop fsync name=fsyncfile1,filesetname=bigfileset,fd=1
    flowop closefile name=closefile1,filesetname=bigfileset,fd=1

    flowop read name=read-file,filesetname=bigfileset,random,iosize=$riosize,iters=$riters

    flowop openfile name=openfile2,filesetname=bigfileset,fd=2
    flowop read name=readfile2,filesetname=bigfileset,fd=2,random,iosize=$riosize,iters=$riters
    flowop write name=writefile2,filesetname=bigfileset,fd=2,random,dsync=$sync,iosize=$wiosize,iters=$witers
    flowop fsync name=fsyncfile2,filesetname=bigfileset,fd=2
    flowop closefile name=closefile2,filesetname=bigfileset,fd=2
    
    flowop write name=write-file,filesetname=bigfileset,random,dsync=$sync,iosize=$wiosize,iters=$witers

    flowop openfile name=openfile3,filesetname=bigfileset,fd=3
    flowop read name=readfile3,filesetname=bigfileset,fd=3,random,iosize=$riosize,iters=$riters
    flowop write name=writefile3,filesetname=bigfileset,fd=3,random,dsync=$sync,iosize=$wiosize,iters=$witers
    flowop fsync name=fsyncfile3,filesetname=bigfileset,fd=3
    flowop closefile name=closefile3,filesetname=bigfileset,fd=3
  }
}

run 60

echo  "Web proxy-server Version 3.0 personality successfully loaded"
usage "Usage: set \$dir=<dir>"
usage "       set \$meanfilesize=<size>    defaults to $meanfilesize"
usage "       set \$nfiles=<value>     defaults to $nfiles"
usage "       set \$nthreads=<value>   defaults to $nthreads"
usage "       set \$meaniosize=<value> defaults to $meaniosize"
usage "       set \$iosize=<size>  defaults to $iosize"
usage "       set \$meandirwidth=<size> defaults to $meandirwidth"
usage "       run runtime (e.g. run 60)"
