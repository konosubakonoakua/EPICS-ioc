## set PS before calling
## if PS = 1 then the entries for PSU 1 in this IOC will be used for the setup


# this defines macros we can use for conditional loading later
stringiftest("PORT", "$(PORT$(PS)=)")

# create a real serial port, unless in simulation mode then create an unconnected asyn port 
$(IFPORT)$(IFRECSIM)    drvAsynSerialPortConfigure ("L$(PS)", "NUL", 0, 1)

## For unit testing:
$(IFDEVSIM) drvAsynIPPortConfigure("L$(PS)", "localhost:$(EMULATOR_PORT=)")

$(IFPORT) $(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure ("L$(PS)", "$(PORT$(PS)=)")
$(IFPORT) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption ("L$(PS)", 0, "baud", "$(BAUD$(PS)=9600)")
$(IFPORT) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption ("L$(PS)", 0, "bits", "$(BITS$(PS)=8)")
$(IFPORT) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption ("L$(PS)", 0, "parity", "$(PARITY$(PS)=none)")
$(IFPORT) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption ("L$(PS)", 0, "stop", "$(STOP$(PS)=1)")
$(IFPORT) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetSetInputEos("L$(PS)",0,"$(IEOS$(PS)=\\r)")
$(IFPORT) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetSetOutputEos("L$(PS)",0,"$(OEOS$(PS)=\\r)")

## Initialise the comms with the PSU
$(IFPORT) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetConnect("GENESYS_01$(PS)","L$(PS)")
$(IFPORT) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite GENESYS_01$(PS) "ADR $(ADDR$(PS))"

## Load record instances for connected psu
$(IFPORT)  dbLoadRecords("$(TOP)/db/TDK_LAMBDA_GENESYS.db", "P=$(MYPVPREFIX)$(IOCNAME):$(PS):,RECSIM=$(RECSIM=0), PORT=L$(PS), ADR=$(ADDR$(PS)), SP_PINI=$(SP_AT_STARTUP$(PS)=NO)")
