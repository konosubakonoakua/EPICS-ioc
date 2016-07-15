#!../../bin/windows-x64/CRYOVALVE-IOC-02

## You may have to change CRYOVALVE-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(CRYOVALVE)/IrisCryoValveSup"
epicsEnvSet "DEVICE" "L0"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/CRYOVALVE-IOC-02.dbd"
CRYOVALVE_IOC_02_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation
< $(IOCSTARTUP)/init.cmd

drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT)", 0, 0, 0, 0)
asynSetOption("$(DEVICE)", -1, "baud", "$(BAUD=19200)")
asynSetOption("$(DEVICE)", -1, "bits", "$(BITS=8)")
asynSetOption("$(DEVICE)", -1, "parity", "$(PARITY=none)")
asynSetOption("$(DEVICE)", -1, "stop", "$(STOP=1)")
asynOctetSetInputEos("$(DEVICE)", -1, "$(OEOS=\r)")
asynOctetSetOutputEos("$(DEVICE)", -1, "$(IEOS=\r)")

## Load record instances

##ISIS## Load common DB records
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/CRYOVALVE.db","P=$(MYPVPREFIX)$(IOCNAME):, port=$(DEVICE)")
#dbLoadRecords("db/xxx.db","user=iew83206Host")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=iew83206Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs
< $(IOCSTARTUP)/postiocinit.cmd
