## NI cDAQ-9185
epicsEnvSet("CDAQER","cDAQ9185-1D195CFMod2")
epicsEnvSet("CDAQAO","cDAQ9185-1D195CFMod3")
epicsEnvSet("CDAQAI","cDAQ9185-1D195CFMod4")

## output
$(IFNOTDEVSIM) DAQmxConfig("W0", "$(CDAQAO)/ao0", 0, "AO","N=1 F=0") ## x
$(IFNOTDEVSIM) DAQmxConfig("W0", "$(CDAQAO)/ao1", 1, "AO","N=1 F=0") ## x
$(IFNOTDEVSIM) DAQmxConfig("W0", "$(CDAQAO)/ao2", 2, "AO","N=1 F=0") ## Separator Volt
$(IFNOTDEVSIM) DAQmxConfig("W0", "$(CDAQAO)/ao3", 3, "AO","N=1 F=0") ## Separator Curr

## input
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQAI)/ai0", 0, "AI","OneShot N=1 F=0") ## Kicker Volt
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQAI)/ai1", 1, "AI","OneShot N=1 F=0") ## Kicker Curr
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQAI)/ai2", 2, "AI","OneShot N=1 F=0") ## Separator Volt
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQAI)/ai3", 3, "AI","OneShot N=1 F=0") ## Separator Curr

## Load record instances
