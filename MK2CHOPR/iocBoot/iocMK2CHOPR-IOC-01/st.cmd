#!../../bin/windows-x64/MK2CHOPR-IOC-01

## You may have to change MK2CHOPR-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/MK2CHOPR-IOC-01.dbd"
MK2CHOPR_IOC_01_registerRecordDeviceDriver pdbbase

< ../iocMK2CHOPR-IOC-01/st-common.cmd
