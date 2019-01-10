cd ${TOP}/iocBoot/${IOC}

##ISIS## Run IOC initialisation
< $(IOCSTARTUP)/init.cmd

## Startup script
# ### E1210 (8AI) ###
epicsEnvSet("E12XX_ASYNPORT","IP")

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("$(E12XX_ASYNPORT)", "localhost:$(EMULATOR_PORT=)")

$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynIPPortConfigure ("$(E12XX_ASYNPORT)","$(IP_ADDR):$(PORT=502)")

stringiftest("MOXA1210", $(MODELNO), 5, "1210")

$(IFMOXA1210) < ${TOP}/iocBoot/iocMOXA1210-IOC-01/st-e1210.cmd

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit()

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
