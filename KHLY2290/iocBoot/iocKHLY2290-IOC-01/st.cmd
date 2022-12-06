#!../../bin/windows-x64/KHLY2290-IOC-01

## You may have to change KHLY2290-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/KHLY2290-IOC-01.dbd"
KHLY2290_IOC_01_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocKHLY2290-IOC-01/st-common.cmd
dbDumpRecord > dbDumpRecord.log


