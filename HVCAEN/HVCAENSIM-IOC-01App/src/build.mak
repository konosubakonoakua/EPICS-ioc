TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

### NOTE: there should only be one build.mak for a given IOC family and this should be located in the ###-IOC-01 directory

#=============================
# Build the IOC application HVCAENSIM-IOC-01
# We actually use $(APPNAME) below so this file can be included by multiple IOCs

PROD_IOC = $(APPNAME)
# HVCAENSIM-IOC-01.dbd will be created and installed
DBD += $(APPNAME).dbd

caenhvwrapper_DIR = $(HVCAEN)/lib/$(EPICS_HOST_ARCH)

# HVCAENSIM-IOC-01.dbd will be made up from these files:
$(APPNAME)_DBD += base.dbd
## ISIS standard dbd ##
$(APPNAME)_DBD += icpconfig.dbd
$(APPNAME)_DBD += pvdump.dbd
$(APPNAME)_DBD += asSupport.dbd
$(APPNAME)_DBD += devIocStats.dbd
$(APPNAME)_DBD += caPutLog.dbd
$(APPNAME)_DBD += utilities.dbd
$(APPNAME)_DBD += asubFunctions.dbd

## add other dbd here ##
$(APPNAME)_DBD += sncSummary.dbd
$(APPNAME)_DBD += HVCAENx527Support.dbd

# Add all the support libraries needed by this IOC
$(APPNAME)_LIBS += HVCAENx527Sim HVCAENx527Summary CAENHVWrapperSim
## ISIS standard libraries ##
$(APPNAME)_LIBS += asubFunctions
$(APPNAME)_LIBS += seq pv
$(APPNAME)_LIBS += devIocStats 
$(APPNAME)_LIBS += pvdump $(MYSQLLIB) easySQLite sqlite 
$(APPNAME)_LIBS += caPutLog
$(APPNAME)_LIBS += icpconfig pugixml
$(APPNAME)_LIBS += autosave
$(APPNAME)_LIBS += utilities pcrecpp pcre
## Add other libraries here ##

$(APPNAME)_LIBS_WIN32 += caenhvwrapper
$(APPNAME)_SYS_LIBS_Linux += caenhvwrapper

# HVCAENSIM-IOC-01_registerRecordDeviceDriver.cpp derives from HVCAENSIM-IOC-01.dbd
$(APPNAME)_SRCS += $(APPNAME)_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
$(APPNAME)_SRCS_DEFAULT += $(APPNAME)Main.cpp
$(APPNAME)_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#$(APPNAME)_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
## area detector already includes PVA, so avoid including it twice
ifeq ($(AREA_DETECTOR),)
include $(CONFIG)/CONFIG_PVA_ISIS
endif

$(APPNAME)_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
