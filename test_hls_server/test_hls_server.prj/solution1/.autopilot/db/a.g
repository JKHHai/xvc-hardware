#!/bin/sh
lli=${LLVMINTERP-lli}
exec $lli \
    /home/justin/jhai/paulchowresearch2020/xvc/test_hls_server/test_hls_server.prj/solution1/.autopilot/db/a.g.bc ${1+"$@"}
