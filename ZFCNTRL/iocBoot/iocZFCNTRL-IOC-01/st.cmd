#!../../bin/windows-x64/ZFCNTRL-IOC-01

## You may have to change ZFCNTRL-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/ZFCNTRL-IOC-01.dbd"
ZFCNTRL_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
epicsEnvSet("P", "$(MYPVPREFIX)$(IOCNAME):")

dbLoadRecords("$(TOP)/db/zfcntrl.db", "P=$(P),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),MAGNETOMETER_TRIGGER=$(MAGNETOMETER_TRIGGER=not_set),MAGNETOMETER_X=$(MAGNETOMETER_X=not_set),MAGNETOMETER_Y=$(MAGNETOMETER_Y=not_set),MAGNETOMETER_Z=$(MAGNETOMETER_Z=not_set),MAGNETOMETER_OVERLOAD=$(MAGNETOMETER_OVERLOAD=not_set),PSU_X=$(PSU_X=not_set),PSU_Y=$(PSU_Y=not_set),PSU_Z=$(PSU_Z=not_set),OUTPUT_X_MIN=$(OUTPUT_X_MIN=0),OUTPUT_X_MAX=$(OUTPUT_X_MAX=0),OUTPUT_Y_MIN=$(OUTPUT_Y_MIN=0),OUTPUT_Y_MAX=$(OUTPUT_Y_MAX=0),OUTPUT_Z_MIN=$(OUTPUT_Z_MIN=0),OUTPUT_Z_MAX=$(OUTPUT_Z_MAX=0)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

seq zero_field, "P=$(P)"
