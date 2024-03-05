epicsEnvSet "STREAM_PROTOCOL_PATH" "$(LNDYISW)/data"
epicsEnvSet "DEVICE" "L0"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

epicsEnvSet("HOST", "130.246.49.89")

## uncomment for debug messages
#devSnmpSetParam("DebugLevel", 10)

## need to set snmp version before we load records
devSnmpSetSnmpVersion("$(HOST)", "SNMP_VERSION_1")

## add an extra directory to load MIB files from
epicsEnvSet("MIBDIRS", "+$(LNDYISW)/mibs")

## Load our record instances
dbLoadRecords("$(LNDYISW)/db/lndyisw.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),HOST=$(HOST)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=vux62295"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
