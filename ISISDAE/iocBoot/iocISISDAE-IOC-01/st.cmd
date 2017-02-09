#!../../bin/windows-x64-debug/ISISDAE-IOC-01

## You may have to change ISISDAE-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 4096)

< envPaths
epicsEnvSet "WIRING_DIR" "$(ICPCONFIGROOT)/tables"
epicsEnvSet "WIRING_PATTERN" ".*wiring.*"
epicsEnvSet "DETECTOR_DIR" "$(ICPCONFIGROOT)/tables"
epicsEnvSet "DETECTOR_PATTERN" ".*det.*"
epicsEnvSet "SPECTRA_DIR" "$(ICPCONFIGROOT)/tables"
epicsEnvSet "SPECTRA_PATTERN" ".*spec.*"
epicsEnvSet "PERIOD_DIR" "$(ICPCONFIGROOT)/tables"
epicsEnvSet "PERIOD_PATTERN" ".*period.*"
epicsEnvSet "TCB_DIR" "$(ICPCONFIGROOT)/tcb"
epicsEnvSet "TCB_PATTERN" ".*tcb.*"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/ISISDAE-IOC-01.dbd"
ISISDAE_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## used for restarting EPICS archiver via web URL
webgetConfigure("web")

## uncomment to disable uamps too large check
#epicsEnvSet("NOCHECKFUAMP","1")

## local dae, no dcom/labview
isisdaeConfigure("icp", $(DAEDCOM=1), $(DAEHOST=localhost), "spudulike", "reliablebeam")
## pass 1 as second arg to signify DCOM to either local or remote dae
#isisdaeConfigure("icp", 1, "localhost")
#isisdaeConfigure("icp", 1, "ndxchipir", "spudulike", "reliablebeam")

## Load the FileLists
FileListConfigure("WLIST", "$(WIRING_DIR)", "$(WIRING_PATTERN)", 1)
FileListConfigure("DLIST", "$(DETECTOR_DIR)", "$(DETECTOR_PATTERN)", 1)
FileListConfigure("SLIST", "$(SPECTRA_DIR)", "$(SPECTRA_PATTERN)", 1)
FileListConfigure("PLIST", "$(PERIOD_DIR)", "$(PERIOD_PATTERN)", 1)
FileListConfigure("TLIST", "$(TCB_DIR)", "$(TCB_PATTERN)", 1)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

#epicsEnvSet("VETO_DELAY","1")
#epicsEnvSet("OTHER_DAE","$(MYPVPREFIX)TEST_01:")
#epicsEnvSet("VETO_1","$(MYPVPREFIX)TEST_01:VETO_1")
#epicsEnvSet("VETO_2","$(MYPVPREFIX)TEST_01:VETO_2")

## Load our record instances
dbLoadRecords("$(ISISDAE)/db/isisdae.db","S=$(MYPVPREFIX), P=$(MYPVPREFIX),Q=DAE:, WIRINGLIST=WLIST, DETECTORLIST=DLIST, SPECTRALIST=SLIST, PERIODLIST=PLIST, TCBLIST=TLIST, OTHER_DAE=$(OTHER_DAE=), VETO_1=$(VETO_1=), VETO_2=$(VETO_2=), VETO_DELAY=$(VETO_DELAY=0)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

# Save motor positions every 5 seconds
create_monitor_set("$(IOCNAME)_positions.req", 5, "P=$(MYPVPREFIX)DAE:")

# Save motor settings every 30 seconds
create_monitor_set("$(IOCNAME)_settings.req", 30, "P=$(MYPVPREFIX)DAE:")
