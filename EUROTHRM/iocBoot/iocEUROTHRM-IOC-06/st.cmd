#!../../bin/windows-x64/EUROTHRM

## You may have to change EUROTHRM to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/EUROTHRM-IOC-06.dbd"
EUROTHRM_IOC_06_registerRecordDeviceDriver pdbbase

< ../iocEUROTHRM-IOC-01/st-common.cmd
