__METADATA__
{
  "v3Meta": {
    "objectGuid": "1182af22-56fc-47d3-810f-19dc1a6ea97f",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {
      "_3S.CoDeSys.CFCObject.CFCProperty": "<?xml version=\"1.0\" encoding=\"utf-8\"?><Single xml:space=\"preserve\" Type=\"{97c1f2ea-5995-48b9-abd5-a3ab983c5def}\" Method=\"IArchivable\"><Single Name=\"UseExplicitExecutionOrder\" Type=\"bool\">False</Single></Single>"
    },
    "subObjects": {}
  }
}
__DECLARATION__
FUNCTION_BLOCK BathErrorsFunction
VAR_INPUT
END_VAR
VAR_OUTPUT
END_VAR
VAR
	MainRelayDisable: MR_DISABLE;
	MainRelayEnable: MR_ENABLE;
	UpdateFanFreq: SET_FREQ_BALANCED;
	EM_TC_TOF: TOF;
	
	COLDSTART_TC_TON: TON;
	COLDSTART_PUMP_TC_TON: TON;
	COLDSTART_PUMP_TC_TOF: TOF;
	
	ColdStartPumpInterval: TIME := T#1s;
	ColdStartPumpCount: UINT := 1;
END_VAR
__IMPLEMENTATION__
// Emergency button Press/Unpress
IF GVL.EMERGENCY = TRUE THEN
	GVL.Baths[0].MainKMStatus := FALSE;
	GVL.Baths[1].MainKMStatus := FALSE;
	GVL.Baths[0].PumpKMStatus := FALSE;
	GVL.Baths[1].PumpKMStatus := FALSE;
	MainRelayDisable(Bath := ADR(GVL.Baths[0]));
	MainRelayDisable(Bath := ADR(GVL.Baths[1]));
		
		
	GVL.Baths[0].MainStatus := ENUM_MainStatuses.emergencyOn;
	GVL.Baths[1].MainStatus := ENUM_MainStatuses.emergencyOn;
	GVL.Baths[0].Freq := GVL.Baths[0].BathConfig.FanMinFreq;
	GVL.Baths[1].Freq := GVL.Baths[1].BathConfig.FanMinFreq;
END_IF;

IF GVL.Baths[0].MainStatus = ENUM_MainStatuses.emergencyOn OR GVL.Baths[1].MainStatus = ENUM_MainStatuses.emergencyOn THEN
	EM_TC_TOF(IN := GVL.EMERGENCY, PT := T#5S);
	IF  EM_TC_TOF.Q = FALSE THEN
		GVL.Baths[0].MainStatus := ENUM_MainStatuses.statusOK;
		GVL.Baths[1].MainStatus := ENUM_MainStatuses.statusOK;
	END_IF;
END_IF;

// HighAirTemp Inside Container 
IF GVL.Baths[0].MainStatus = ENUM_MainStatuses.highAirTempStatus OR GVL.Baths[1].MainStatus = ENUM_MainStatuses.highAirTempStatus THEN
	GVL.Baths[0].MainStatus := ENUM_MainStatuses.highAirTempStatus;
	GVL.Baths[1].MainStatus := ENUM_MainStatuses.highAirTempStatus;
	IF GVL.Baths[0].LiquidInTemp > GVL.Baths[0].BathConfig.LiquidTargetTemp - 5 OR GVL.Baths[1].LiquidInTemp > GVL.Baths[1].BathConfig.LiquidTargetTemp - 5  THEN
		GVL.Baths[0].PumpKMStatus := TRUE;
		GVL.Baths[1].PumpKMStatus := TRUE;
		IF GVL.Baths[0].Freq <> 100 OR GVL.Baths[1].Freq <> 100 THEN
			GVL.Baths[0].Freq := 100;
			GVL.Baths[1].Freq := 100;
			UpdateFanFreq(Bath:= ADR(GVL.Baths[0]));
			UpdateFanFreq(Bath:= ADR(GVL.Baths[1]));
		END_IF;
	ELSE
		GVL.Baths[0].PumpKMStatus := FALSE;
		GVL.Baths[1].PumpKMStatus := FALSE;
		IF GVL.Baths[0].Freq <> 0 OR GVL.Baths[1].Freq <> 0 THEN
			GVL.Baths[0].Freq := GVL.Baths[0].BathConfig.FanMinFreq;
			GVL.Baths[1].Freq := GVL.Baths[1].BathConfig.FanMinFreq;
			UpdateFanFreq(Bath:= ADR(GVL.Baths[0]));
			UpdateFanFreq(Bath:= ADR(GVL.Baths[1]));
		END_IF;
	END_IF;
END_IF;

//High Liquid temp Alert
IF GVL.Baths[0].MainStatus = ENUM_MainStatuses.highLiquidTempStatus OR GVL.Baths[1].MainStatus = ENUM_MainStatuses.highLiquidTempStatus THEN
	IF GVL.Baths[0].MainStatus <> ENUM_MainStatuses.highLiquidTempStatus THEN
		GVL.Baths[0].MainStatus := ENUM_MainStatuses.dependentStatus;
	ELSIF GVL.Baths[1].MainStatus <> ENUM_MainStatuses.highLiquidTempStatus THEN 
		GVL.Baths[1].MainStatus := ENUM_MainStatuses.dependentStatus;
	END_IF
	GVL.Baths[0].Freq := GVL.Baths[0].BathConfig.FanMinFreq;
	GVL.Baths[1].Freq := GVL.Baths[1].BathConfig.FanMinFreq;
	UpdateFanFreq(Bath:= ADR(GVL.Baths[0]));
	UpdateFanFreq(Bath:= ADR(GVL.Baths[1]));
	MainRelayDisable(Bath := ADR(GVL.Baths[0]));
	MainRelayDisable(Bath := ADR(GVL.Baths[1]));
	GVL.Baths[0].PumpKMStatus := FALSE;
	GVL.Baths[1].PumpKMStatus := FALSE;
END_IF;

//Pressure Fail temp Alert
IF GVL.Baths[0].MainStatus = ENUM_MainStatuses.pressureFail OR GVL.Baths[1].MainStatus = ENUM_MainStatuses.pressureFail THEN
	IF GVL.Baths[0].MainStatus <> ENUM_MainStatuses.pressureFail THEN
		GVL.Baths[0].MainStatus := ENUM_MainStatuses.dependentStatus;
	ELSIF GVL.Baths[1].MainStatus <> ENUM_MainStatuses.pressureFail THEN 
		GVL.Baths[1].MainStatus := ENUM_MainStatuses.dependentStatus;
	END_IF
	GVL.Baths[0].Freq := GVL.Baths[0].BathConfig.FanMinFreq;
	GVL.Baths[1].Freq := GVL.Baths[1].BathConfig.FanMinFreq;
	UpdateFanFreq(Bath:= ADR(GVL.Baths[0]));
	UpdateFanFreq(Bath:= ADR(GVL.Baths[1]));
	MainRelayDisable(Bath := ADR(GVL.Baths[0]));
	MainRelayDisable(Bath := ADR(GVL.Baths[1]));
	GVL.Baths[0].PumpKMStatus := FALSE;
	GVL.Baths[1].PumpKMStatus := FALSE;
END_IF;


//Liquid Level Fail
IF GVL.Baths[0].MainStatus = ENUM_MainStatuses.liquidLevelFail OR GVL.Baths[1].MainStatus = ENUM_MainStatuses.liquidLevelFail THEN
	IF GVL.Baths[0].MainStatus <> ENUM_MainStatuses.liquidLevelFail THEN
		GVL.Baths[0].MainStatus := ENUM_MainStatuses.dependentStatus;
	ELSIF GVL.Baths[1].MainStatus <> ENUM_MainStatuses.liquidLevelFail THEN 
		GVL.Baths[1].MainStatus := ENUM_MainStatuses.dependentStatus;
	END_IF
	GVL.Baths[0].Freq := GVL.Baths[0].BathConfig.FanMinFreq;
	GVL.Baths[1].Freq := GVL.Baths[1].BathConfig.FanMinFreq;
	UpdateFanFreq(Bath:= ADR(GVL.Baths[0]));
	UpdateFanFreq(Bath:= ADR(GVL.Baths[1]));
	MainRelayDisable(Bath := ADR(GVL.Baths[0]));
	MainRelayDisable(Bath := ADR(GVL.Baths[1]));
	GVL.Baths[0].PumpKMStatus := FALSE;
	GVL.Baths[1].PumpKMStatus := FALSE;
END_IF;

//Temperature Sensor Fail
IF GVL.Baths[0].MainStatus = ENUM_MainStatuses.liquidTempSensorFail OR GVL.Baths[1].MainStatus = ENUM_MainStatuses.liquidTempSensorFail THEN
	IF GVL.Baths[0].MainStatus <> ENUM_MainStatuses.liquidTempSensorFail THEN
		GVL.Baths[0].MainStatus := ENUM_MainStatuses.dependentStatus;
	ELSIF GVL.Baths[1].MainStatus <> ENUM_MainStatuses.liquidTempSensorFail THEN 
		GVL.Baths[1].MainStatus := ENUM_MainStatuses.dependentStatus;
	END_IF
	GVL.Baths[0].Freq := GVL.Baths[0].BathConfig.FanMinFreq;
	GVL.Baths[1].Freq := GVL.Baths[1].BathConfig.FanMinFreq;
	UpdateFanFreq(Bath:= ADR(GVL.Baths[0]));
	UpdateFanFreq(Bath:= ADR(GVL.Baths[1]));
	MainRelayDisable(Bath := ADR(GVL.Baths[0]));
	MainRelayDisable(Bath := ADR(GVL.Baths[1]));
	GVL.Baths[0].PumpKMStatus := FALSE;
	GVL.Baths[1].PumpKMStatus := FALSE;
END_IF;


//ColdStart
IF GVL.Baths[0].MainStatus = ENUM_MainStatuses.mainStatusRemoteColdStart OR GVL.Baths[1].MainStatus = ENUM_MainStatuses.mainStatusRemoteColdStart THEN
	IF ColdStartPumpInterval > T#8S THEN
		PV.main_remote_command := ENUM_MAinStatuses.mainStatusRemoteEmergencyShutDown;
		MainRelayDisable(Bath := ADR(GVL.Baths[0]));
		MainRelayDisable(Bath := ADR(GVL.Baths[1]));
	ELSE
		MainRelayEnable(Bath := ADR(GVL.Baths[0]));
		MainRelayEnable(Bath := ADR(GVL.Baths[1]));
	END_IF
	
	COLDSTART_TC_TON(IN :=GVL.Baths[0].MainRelayStatus, PT := T#8M);
	IF  COLDSTART_TC_TON.Q = TRUE THEN
		
		COLDSTART_PUMP_TC_TON(IN :=GVL.Baths[0].PumpKMStatus, PT := ColdStartPumpInterval);
		IF  COLDSTART_PUMP_TC_TON.Q = TRUE THEN
			GVL.Baths[0].PumpKMStatus := FALSE;
			GVL.Baths[1].PumpKMStatus := FALSE;
			IF ColdStartPumpCount = 3 THEN
				ColdStartPumpInterval := ColdStartPumpInterval + T#1S;
				ColdStartPumpCount := 1;
			ELSE
				ColdStartPumpCount := ColdStartPumpCount + 1;
			END_IF
		END_IF;
		
		COLDSTART_PUMP_TC_TOF(IN :=GVL.Baths[0].PumpKMStatus, PT := T#10S);
		IF  COLDSTART_PUMP_TC_TOF.Q = FALSE THEN
			GVL.Baths[0].PumpKMStatus := TRUE;
			GVL.Baths[1].PumpKMStatus := TRUE;
		END_IF;
		
	ELSE
		ColdStartPumpInterval := T#1S;
		ColdStartPumpCount := 1;
	END_IF;
	
END_IF;

// Remote Reset Command
IF PV.main_remote_command = ENUM_MainStatuses.mainStatusRemoteErrorReset THEN
	GVL.Baths[0].MainStatus := ENUM_MAinStatuses.statusOK;
	GVL.Baths[1].MainStatus := ENUM_MAinStatuses.statusOK;
	PV.main_remote_command := 0;
END_IF;


