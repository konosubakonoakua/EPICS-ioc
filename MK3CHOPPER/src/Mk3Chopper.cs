﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.Remoting;
using CaSharpServer;

namespace Server
{
    class Mk3Chopper : IChopper
    {
        MK3ChopperSkeleton.IBeamLine _beamline = null;
        MK3ChopperSkeleton.RemotingHelper _helper;

        CAIntRecord NumEnabledChannelsRb;

        List<PVInfo> _PVs = new List<PVInfo>();

        public Mk3Chopper(CAServer server, string prefix, string config_file)
        {
            RemotingConfiguration.Configure(config_file, false);

            _helper = new MK3ChopperSkeleton.RemotingHelper();
            _beamline = (MK3ChopperSkeleton.IBeamLine)MK3ChopperSkeleton.RemotingHelper.CreateProxy();

            if (prefix.EndsWith(":")) prefix = prefix.Substring(0, prefix.Length - 1);

            NumEnabledChannelsRb = server.CreateRecord<CAIntRecord>(prefix + ":NUM_ENABLED");
            _PVs.Add(new PVInfo(NumEnabledChannelsRb.Name, "ai", "MEDIUM"));
            NumEnabledChannelsRb.PrepareRecord += new EventHandler(NumEnabledChannelsRb_PrepareRecord);
            NumEnabledChannelsRb.Scan = CaSharpServer.Constants.ScanAlgorithm.SEC10;
        }

        public List<PVInfo> GetPvInfo()
        {
            return _PVs;
        }

        void NumEnabledChannelsRb_PrepareRecord(object sender, EventArgs e)
        {
            NumEnabledChannelsRb.Value = (int)this.GetNumberEnabledChannels();
        }

        public double GetActualFreq(uint channel)
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleActualSpeed(channel);
            return res.doubleResult;
        }

        public uint GetActualPhase(uint channel)
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleActualDelay(channel);
            return res.uintResult;
        }

        public int GetActualPhaseError(uint channel)
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleActualErrorWindow(channel);
            return res.intResult;
        }

        public double[] GetAllowedFrequencies(uint channel)
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetAllowedDemandSpeeds(channel);
            return res.doubleArray;
        }

        public string GetBeamlineName()
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetBeamLineName();
            return res.stringResult;
        }

        public string GetChannelsCurrentSettings()
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetChannelsCurrentSettings();
            return res.stringResult;
        }

        public string GetChopperName(uint channel)
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetChopperName(channel);
            return res.stringResult;
        }

        public string GetChopperType(uint channel)
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetChopperType(channel);
            return res.stringResult;
        }

        public bool GetChangeDirectionEnabled(uint channel)
        {
            string chopperType = GetChopperType(channel);

            if (chopperType == "MK3ChopperServer.TS2DiscChopper")
            {
                return true;
            }

            ////Other types are:
            //"TS1DiscChopper"
            //"TS1TZeroChopper"
            //"TS2TZeroChopper"
            return false;
        }

        public bool GetComputerMode()
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetComputerMode();
            return res.boolResult;
        }

        public int GetFirmwareVersion(uint channel)
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleFirmwareVersion(channel);
            return res.intResult;
        }

        public int GetMPPeriod(uint channel)
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleMPPeriod(channel);
            return res.intResult;
        }

        public double GetNominalAngle(uint channel)
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetStoredDemandDiscAngle(channel);
            return res.doubleResult;
        }

        public bool GetNominalDirection(uint channel)
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetStoredDemandCWDirection(channel);
            return res.boolResult;
        }

        public double GetNominalFreq(uint channel)
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleDemandSpeed(channel);
            return res.doubleResult;
        }

        public uint GetNominalPhaseError(uint channel)
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleDemandErrorWindow(channel);
            return res.uintResult;
        }

        public uint GetNominalPhase(uint channel)
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleDemandDelay(channel);
            return res.uintResult;
        }

        public uint GetNumberEnabledChannels()
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetNumberOfEnabledChannels();
            return res.uintResult;
        }

        public int GetSoftwareVersion(uint channel)
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleSoftwareVersion(channel);
            return res.intResult;
        }

        public BitArray GetStatusRegister(uint channel)
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleStatusRegister(channel);
            return res.statusReg;
        }

        public int GetNumberChannels()
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.GetTotalNumberOfChannels();
            return res.intResult;
        }

        //public int PutNominalAngle(uint channel, double angle)
        //{
        //    MK3ChopperSkeleton.ResultContainer res = _beamline.SetStoredDemandDiscAngle(channel, angle);
        //    checkError(res);
        //    res = _beamline.SendStoredDemandDiscAngleToModule(channel);
        //    checkError(res);
        //    res = _beamline.SaveChopperSettings();
        //    checkError(res);

        //    return res.intResult;
        //}

        public int PutNominalDirection(uint channel, bool cw)
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.SetStoredDemandCWDirection(channel, cw);
            checkError(res);
            res = _beamline.SendStoredDemandCWDirectionToModule(channel);
            checkError(res);
            res = _beamline.SaveChopperSettings();
            checkError(res);

            return res.intResult;
        }

        public double PutNominalFreq(uint channel, double speed)
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.SetStoredDemandSpeed(channel, speed);
            checkError(res);
            res = _beamline.SendStoredDemandSpeedToModule(channel);
            checkError(res);
            double newVal = res.doubleResult;
            res = _beamline.SaveChopperSettings();
            checkError(res);

            return newVal;
        }

        public uint PutNominalPhaseErrorWindow(uint channel, uint error)
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.SetStoredDemandErrorWindow(channel, error);
            checkError(res);
            res = _beamline.SendStoredDemandErrorWindowToModule(channel);
            checkError(res);
            uint newVal = res.uintResult;
            res = _beamline.SaveChopperSettings();
            checkError(res);

            return newVal;
        }

        public uint PutNominalPhase(uint channel, uint phase)
        {
            MK3ChopperSkeleton.ResultContainer res = _beamline.SetStoredDemandDelay(channel, phase);
            checkError(res);
            res = _beamline.SendStoredDemandDelayToModule(channel);
            checkError(res);
            uint newVal = res.uintResult;
            res = _beamline.SaveChopperSettings();
            checkError(res);

            return newVal;
        }

        private void checkError(MK3ChopperSkeleton.ResultContainer res)
        {
            if (res.error)
            {
                throw new Exception(resolveErrorCode(res.errorCode));
            }
        }

        private string resolveErrorCode(uint code)
        {
            string errorMsg = "";

            switch (code)
            {
                case 1:
                    errorMsg = "Channel Number Not In Range.";
                    break;
                case 2:
                    errorMsg = "Channel Not Enabled";
                    break;
                case 3:
                    errorMsg = "Set User Delay Too Large For Chopper";
                    break;
                case 4:
                    errorMsg = "Controller Module Did Not Echo Command and Data";
                    break;
                case 5:
                    errorMsg = "Communication To Module Error";
                    break;
                case 6:
                    errorMsg = "Chopper Type Not Recognized";
                    break;
                case 7:
                    errorMsg = "Returned CMD Error";
                    break;
                case 8:
                    errorMsg = "Returned Non - Numerical Data";
                    break;
                case 9:
                    errorMsg = "Returned Incorrect String Length";
                    break;
                case 10:
                    errorMsg = "Error Window Too Large";
                    break;
                case 11:
                    errorMsg = "Cannot Save To Chopper Settings File";
                    break;
                case 12:
                    errorMsg = "Chopper Settings File Does Not Exist";
                    break;
                case 13:
                    errorMsg = "Cannot Read Chopper Settings File";
                    break;
                case 14:
                    errorMsg = "Cannot Update Chopper Log File";
                    break;
                case 15:
                    errorMsg = "Chopper Log File Does Not Exist";
                    break;
                case 16:
                    errorMsg = "Cannot Read Chopper Log File";
                    break;
                case 17:
                    errorMsg = "Could Not Clear Chopper Log File";
                    break;
                case 18:
                    errorMsg = "Remote Access Never Allowed For This Method";
                    break;
                case 19:
                    errorMsg = "Tried To Set Angle On non Disk Chopper";
                    break;
                case 20:
                    errorMsg = "Tried To Set Out Of Range Angle";
                    break;
                case 21:
                    errorMsg = "Current User Demand Delay Too Large for Angle , Direction & Speed";
                    break;
                case 22:
                    errorMsg = "Incorrect Speed Request";
                    break;
                case 23:
                    errorMsg = "Tried to Set Same Value for TS1 Bit";
                    break;
                case 24:
                    errorMsg = "Number of Requested Channels to Enable Not in Range";
                    break;
                case 25:
                    errorMsg = "Cannot Accept Empty String";
                    break;
                case 26:
                    errorMsg = "Incorrect IP Format";
                    break;
                case 27:
                    errorMsg = "Tried To Set Direction On T0 CHopper";
                    break;
                case 28:
                    errorMsg = "Module Returned Incorrect Termination String";
                    break;
                case 29:
                    errorMsg = "Send Stored Demand Disc Angle To Module Via \"Send User Demand Delay\"";
                    break;
                case 30:
                    errorMsg = "Module Did Not Return \"0\" Or \"1\" Data";
                    break;
                case 31:
                    errorMsg = "Remote Access Not Allowed When System In Manual Mode";
                    break;
                case 32:
                    errorMsg = "Tried To Set From Test Mode To Normal Mode When PCB Jumper Set To Test Mode";
                    break;
                case 33:
                    errorMsg = "Channels Not Consequectively Enabled In \"ChopperSettings.xml\" File";
                    break;
                case 34:
                    errorMsg = "Channel 1 Not Enabled In \"ChopperSettings.xml\" File";
                    break;
                case 35:
                    errorMsg = "Second PC LAN Card Not Found";
                    break;
                case 36:
                    errorMsg = "Could Not Find Any Chopper Modules";
                    break;
                case 37:
                    errorMsg = "Too Many Connected Chopper Modules";
                    break;
                case 38:
                    errorMsg = "Server ChopperList Empty";
                    break;
                default:
                    errorMsg = "OK";
                    break;
            }

            return errorMsg;
        }
    }
}

