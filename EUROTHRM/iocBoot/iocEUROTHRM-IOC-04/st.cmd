#!../../bin/windows-x64/EUROTHRM

## You may have to change EUROTHRM to something else
## everywhere it appears in this file

< envPaths
epicsEnvSet "IOCPVPREFIX" "EUROTHRM_04"

## Register all support components
dbLoadDatabase "${TOP}/dbd/EUROTHRM-IOC-04.dbd"
EUROTHRM_IOC_04_registerRecordDeviceDriver pdbbase

< ../iocEUROTHRM-IOC-01/st-common.cmd
