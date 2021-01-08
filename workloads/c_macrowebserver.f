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
# Copyright 2007 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#

set $dir=/mnt/pmem0_wenduo/tmp
set $nfiles=100
set $nthreads=50
set $sync=true
set $riters=1
set $witers=1
set $riosize=256k
set $wiosize=16k
set $cached=false

define randvar name=$dirwidth,type=gamma,min=1,round=1,mean=512
define randvar name=$filesize,type=gamma,min=256k,round=256k,mean=512k

#define file name=bigfile1,path=$dir,size=$filesize,prealloc,cached=$cached
define fileset name=bigfileset,path=$dir,size=$filesize,entries=$nfiles,dirwidth=$dirwidth,prealloc

define process name=webserver,instances=1
{
  thread name=webserverthread,memsize=0m,instances=$nthreads
  {  
    flowop openfile name=openreadfile1,filesetname=bigfileset,fd=1
    flowop readwholefile name=readwhole-file1,filesetname=bigfileset,iosize=$riosize,iters=$riters,fd=1
    flowop closefile name=closereadfile1,filesetname=bigfileset,fd=1

    flowop openfile name=openreadfile2,filesetname=bigfileset,fd=2
    flowop readwholefile name=readwhole-file2,filesetname=bigfileset,iosize=$riosize,iters=$riters,fd=2
    flowop closefile name=closereadfile2,filesetname=bigfileset,fd=2

    flowop openfile name=openreadfile3,filesetname=bigfileset,fd=3
    flowop readwholefile name=readwhole-file3,filesetname=bigfileset,iosize=$riosize,iters=$riters,fd=3
    flowop closefile name=closereadfile3,filesetname=bigfileset,fd=3

    flowop openfile name=openreadfile4,filesetname=bigfileset,fd=4
    flowop readwholefile name=readwhole-file4,filesetname=bigfileset,iosize=$riosize,iters=$riters,fd=4
    flowop closefile name=closereadfile4,filesetname=bigfileset,fd=4

    flowop openfile name=openreadfile5,filesetname=bigfileset,fd=5
    flowop readwholefile name=readwhole-file5,filesetname=bigfileset,iosize=$riosize,iters=$riters,fd=5
    flowop closefile name=closereadfile5,filesetname=bigfileset,fd=5

    flowop openfile name=openreadfile6,filesetname=bigfileset,fd=6
    flowop readwholefile name=readwhole-file6,filesetname=bigfileset,iosize=$riosize,iters=$riters,fd=6
    flowop closefile name=closereadfile6,filesetname=bigfileset,fd=6

    flowop openfile name=openreadfile7,filesetname=bigfileset,fd=7
    flowop readwholefile name=readwhole-file7,filesetname=bigfileset,iosize=$riosize,iters=$riters,fd=7
    flowop closefile name=closereadfile7,filesetname=bigfileset,fd=7

    flowop openfile name=openreadfile8,filesetname=bigfileset,fd=8
    flowop readwholefile name=readwhole-file8,filesetname=bigfileset,iosize=$riosize,iters=$riters,fd=8
    flowop closefile name=closereadfile8,filesetname=bigfileset,fd=8

    flowop openfile name=openreadfile9,filesetname=bigfileset,fd=9
    flowop readwholefile name=readwhole-file9,filesetname=bigfileset,iosize=$riosize,iters=$riters,fd=9
    flowop closefile name=closereadfile9,filesetname=bigfileset,fd=9

    flowop openfile name=openreadfile10,filesetname=bigfileset,fd=10
    flowop readwholefile name=readwhole-file10,filesetname=bigfileset,iosize=$riosize,iters=$riters,fd=10
    flowop closefile name=closereadfile10,filesetname=bigfileset,fd=10
    
    flowop write name=write-file,filesetname=bigfileset,random,dsync=$sync,iosize=$wiosize,iters=$witers
  }
}

run 60

echo  "Web-server Version 3.0 personality successfully loaded"
usage "Usage: set \$dir=<dir>"
usage "       set \$meanfilesize=<size>   defaults to $meanfilesize"
usage "       set \$nfiles=<value>    defaults to $nfiles"
usage "       set \$meandirwidth=<value>  defaults to $meandirwidth"
usage "       set \$nthreads=<value>  defaults to $nthreads"
usage "       set \$iosize=<size>     defaults to $iosize"
usage "       run runtime (e.g. run 60)"
