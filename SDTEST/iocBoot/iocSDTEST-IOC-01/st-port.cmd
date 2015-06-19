## set PN before calling
## if PN=1 the defines asyn port SD1 and uses macros such as PORT1, PORT1_PARITY to configure 

# this defines macros we can use for conditional loading later
stringiftest("PORT", "$(PORT$(PN)=)")

# create a real serial port, unless in simulation mode then crreate an unconnected asyn port 
$(IFPORT)$(IFSIM)    drvAsynSerialPortConfigure ("SD$(PN)", "NUL", 0, 1)

#$(IFPORT)$(IFNOTSIM)drvAsynIPPortConfigure("SD$(PN)","$(PORT$(PN)=)",0,0,0) 

# defaults should be reflected in config.xml
$(IFPORT)$(IFNOTSIM) drvAsynSerialPortConfigure ("SD$(PN)", "$(PORT$(PN)=)")
$(IFPORT)$(IFNOTSIM) asynSetOption ("SD$(PN)", 0, "baud", "$(BAUD$(PN)=9600)")
$(IFPORT)$(IFNOTSIM) asynSetOption ("SD$(PN)", 0, "bits", "$(BITS$(PN)=8)")
$(IFPORT)$(IFNOTSIM) asynSetOption ("SD$(PN)", 0, "parity", "$(PARITY$(PN)=none)")
$(IFPORT)$(IFNOTSIM) asynSetOption ("SD$(PN)", 0, "stop", "$(STOP$(PN)=1)")
$(IFPORT)$(IFNOTSIM) asynSetOption ("SD$(PN)", 0, "clocal", "$(CLOCAL$(PN)=Y)") # if N, output flow control using DSR signal
$(IFPORT)$(IFNOTSIM) asynSetOption ("SD$(PN)", 0, "crtscts", "$(CRTSCTS$(PN)=N)") # if Y, use hardware flow control (RTS/CTS)
$(IFPORT)$(IFNOTSIM) asynSetOption ("SD$(PN)", 0, "ixon", "$(IXON$(PN)=N)") # if Y, use software flow control for output
$(IFPORT)$(IFNOTSIM) asynSetOption ("SD$(PN)", 0, "ixoff", "$(IXOFF$(PN)=N)") # if Y, use software flow control for input
$(IFPORT)$(IFNOTSIM) asynOctetSetOutputEos("SD$(PN)",0,"$(OEOS$(PN)=\\r\\n)")
$(IFPORT)$(IFNOTSIM) asynOctetSetInputEos("SD$(PN)",0,"$(IEOS$(PN)=\\r\\n)")

stringiftest("TRACEMASK", "$(TRACEMASK$(PN)=)")
$(IFPORT)$(IFTRACEMASK) asynSetTraceMask("SD$(PN)",0,"$(TRACEMASK$(PN)=)")

stringiftest("TRACEIOMASK", "$(TRACEIOMASK$(PN)=)")
$(IFPORT)$(IFTRACEIOMASK) asynSetTraceIOMask("SD$(PN)",0,"$(TRACEIOMASK$(PN)=)")

## Load record instances for connected port
$(IFPORT) dbLoadRecords("$(TOP)/db/SDTEST-IOC-01.db","P=$(MYPVPREFIX),Q=$(IOCNAME):P$(PN):,PORT=SD$(PN),DEV=$(PORT$(PN)=),NAME=$(PORT$(PN)_NAME=),DISABLE=$(DISABLE),SIM=$(SIMULATE),SCAN=.5 second,SETOUT1=1PA,GETOUT=1TP,GETIN=1TP%f,SETFMT=%f,SETREPLY=%*s")

$(IFPORT) dbLoadRecords("$(ASYN)/db/asynRecord.db","P=$(MYPVPREFIX),R=$(IOCNAME):P$(PN):ASYNREC,PORT=SD$(PN),ADDR=0,OMAX=80,IMAX=80")

#
