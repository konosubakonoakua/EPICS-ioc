epicsEnvSet(OK_TO_RUN_PSUS,$(MYPVPREFIX)SIMPLE:VALUE1)
epicsEnvSet(ALLOW_CHANGEOVER,$(MYPVPREFIX)SIMPLE:VALUE2)
epicsEnvSet(PSU_DISABLE,$(MYPVPREFIX)$(IOCNAME):RB2C:PSUS:DISABLE)
epicsEnvSet(PSU_POWER,$(MYPVPREFIX)$(IOCNAME):RB2C:PSUS:POWER)

dbLoadRecords("$(TOP)/db/riken_changeover.db","PV_PREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,OK_TO_RUN_PSUS=$(OK_TO_RUN_PSUS),PSU_DISABLE=$(PSU_DISABLE),PSU_POWER=$(PSU_POWER)")
dbLoadRecords("$(TOP)/db/riken_rb2_mode_changeover_psus.db","PV_PREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,OK_TO_RUN_PSUS=$(OK_TO_RUN_PSUS),PSU_DISABLE=$(PSU_DISABLE),PSU_POWER=$(PSU_POWER)")
dbLoadRecords("$(TOP)/db/riken_changeover_groups.db","PV_PREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,OK_TO_RUN_PSUS=$(OK_TO_RUN_PSUS),PSU_DISABLE=$(PSU_DISABLE),PSU_POWER=$(PSU_POWER)")

seq riken_port_changeover, "OK_TO_RUN_PSUS=$(OK_TO_RUN_PSUS),ALLOW_CHANGEOVER=$(ALLOW_CHANGEOVER),PSU_DISABLE=$(PSU_DISABLE),PSU_POWER=$(PSU_POWER)"
