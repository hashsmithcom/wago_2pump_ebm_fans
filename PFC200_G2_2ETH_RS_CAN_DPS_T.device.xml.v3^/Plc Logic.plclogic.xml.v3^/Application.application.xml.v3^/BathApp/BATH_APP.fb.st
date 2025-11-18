__METADATA__
{
  "v3Meta": {
    "objectGuid": "78bffb2b-1c65-4129-bdc8-a2c9dd384ce0",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {
      "_3S.CoDeSys.LanguageModelManager.BuildProperty": "<?xml version=\"1.0\" encoding=\"utf-8\"?><Single xml:space=\"preserve\" Type=\"{24568a24-c491-472c-a21f-ee5d33859fab}\" Method=\"IArchivable\"><Single Name=\"MemoryReserveForOnlineChange\" Type=\"int\">0</Single><Single Name=\"ExcludeFromBuild\" Type=\"bool\">False</Single><Single Name=\"External\" Type=\"bool\">False</Single><Single Name=\"EnableSystemCall\" Type=\"bool\">False</Single><Single Name=\"CompilerDefines\" Type=\"string\"></Single><Single Name=\"LinkAlways\" Type=\"bool\">False</Single><Array Name=\"Undefines\" Type=\"string\" /></Single>"
    },
    "subObjects": {}
  }
}
__DECLARATION__
FUNCTION_BLOCK BATH_APP
VAR_INPUT
	Bath :POINTER TO Bath;
END_VAR
VAR
	MainRelayDisable: MR_DISABLE;
	MainRelayEnable: MR_ENABLE;
	FrequenceRecalculate: frequencyCalculate;
	UpdateFanFreq: SET_FREQ_BALANCED;
	CoolingTemp: UINT;
	LiquidAlertTemp: UINT;
	LiquidInTemp: REAL;
	LiquidOutTemp: REAL;
	HighAirTemp: REAL;
	temp_MainStatus: BOOL;
	HA_TC_TOF: TOF;
END_VAR;
__IMPLEMENTATION__
LiquidInTemp :=Bath^.LiquidInTemp;
LiquidOutTemp := Bath^.LiquidOutTemp;
HighAirTemp := PV.HighAirTemp;

IF PV.main_remote_command > ENUM_MainStatuses.mainStatusRemoteErrorReset THEN
	IF PV.main_remote_command = ENUM_MainStatuses.mainStatusRemoteSoftShutDown THEN
		Bath^.MainStatus := ENUM_MainStatuses.mainStatusRemoteSoftShutDown;
		MainRelayDisable(Bath := Bath);
		IF LiquidInTemp > Bath^.BathConfig.LiquidTargetTemp -5 OR LiquidOutTemp > Bath^.BathConfig.LiquidTargetTemp -5 THEN
			Bath^.MainKMStatus := TRUE;
			Bath^.PumpKMStatus := TRUE;
			IF Bath^.Freq <> HighAirTemp - 5 THEN
				Bath^.Freq := 100;
				UpdateFanFreq(Bath:= Bath);
			END_IF;
		ELSE
			IF Bath^.Freq <> 0 THEN
				Bath^.Freq := Bath^.BathConfig.FanMinFreq;
				UpdateFanFreq(Bath:= Bath);
			END_IF;
			Bath^.PumpKMStatus := FALSE;
			IF GVL.ContainerAirTemp < HighAirTemp - 5 THEN
				Bath^.MainKMStatus := FALSE;
			ELSE
				Bath^.MainKMStatus := TRUE;
			END_IF;
		END_IF;
	END_IF;

	IF PV.main_remote_command = ENUM_MainStatuses.mainStatusRemoteEmergencyShutDown THEN
		Bath^.MainStatus := ENUM_MainStatuses.mainStatusRemoteEmergencyShutDown;
		MainRelayDisable(Bath := Bath);
		Bath^.PumpKMStatus := FALSE;
		Bath^.MainKMStatus   := FALSE;
		IF Bath^.Freq <> 0 THEN
			Bath^.Freq := Bath^.BathConfig.FanMinFreq;
			UpdateFanFreq(Bath:= Bath);
		END_IF;
	END_IF;
	
	IF PV.main_remote_command = ENUM_MainStatuses.mainStatusRemoteColdStart THEN
		Bath^.MainStatus := ENUM_MainStatuses.mainStatusRemoteColdStart;
	END_IF;

	IF PV.main_remote_command = ENUM_MAinStatuses.mainStatusRemoteMaintanceMode THEN
		Bath^.MainStatus := ENUM_MAinStatuses.mainStatusRemoteMaintanceMode;
		MainRelayDisable(Bath := Bath);
		Bath^.MainKMStatus := TRUE;
		IF LiquidInTemp > Bath^.BathConfig.LiquidAlertTemp-10 OR LiquidOutTemp > Bath^.BathConfig.LiquidAlertTemp-10 THEN
			Bath^.PumpKMStatus := TRUE;
			IF Bath^.Freq <> 100 THEN
				Bath^.Freq := 100;
				UpdateFanFreq(Bath:= Bath);
			END_IF;
		ELSE
			IF Bath^.Freq <> 0 THEN
				Bath^.Freq := Bath^.BathConfig.FanMinFreq;
				UpdateFanFreq(Bath:= Bath);
			END_IF;
			Bath^.PumpKMStatus := FALSE;
		END_IF;
	END_IF;

	RETURN;
END_IF;

(* Before code only for remote commands *)
IF PV.main_remote_command <= ENUM_MainStatuses.mainStatusRemoteErrorReset AND Bath^.MainStatus >= ENUM_MainStatuses.mainStatusRemoteErrorReset THEN
	Bath^.MainStatus := ENUM_MAinStatuses.statusOK;
END_IF;

IF Bath^.BathConfig.AdminMainRelay =  ENUM_AdminRelayStatus.relayForceDisable THEN
	MainRelayDisable(Bath := Bath);
END_IF
IF GVL.ContainerAirTemp > HighAirTemp THEN
	temp_MainStatus := FALSE;
ELSE
	temp_MainStatus := TRUE;
END_IF;

HA_TC_TOF(IN :=temp_MainStatus, PT := T#5s);
IF  HA_TC_TOF.Q = FALSE THEN
	Bath^.MainStatus := ENUM_MainStatuses.highAirTempStatus;
END_IF;

IF Bath^.MainStatus = ENUM_MainStatuses.statusOK THEN
	//Starting pump
	Bath^.MainKMStatus := TRUE;
	
	//Checking pressure after pump started
	Bath^.PRESSURE_TC_TON(IN :=Bath^.PumpKMStatus, PT := Bath^.BathConfig.PressureStabilizeInterval);
	IF Bath^.PRESSURE_TC_TON.Q = TRUE THEN
		IF Bath^.PressureOutgoing < Bath^.BathConfig.PressureStabilizeTarget THEN
			Bath^.MainStatus := ENUM_MainStatuses.pressureFail;
		END_IF
	END_IF;
	
	//Checking Liquid Temperature Sensors
	IF LiquidOutTemp < -50 OR LiquidOuttemp > 200 THEN
		Bath^.TempStatus := ENUM_TempStatuses.tempOutsensorFail;
		Bath^.MainStatus := ENUM_MainStatuses.liquidTempSensorFail;
	END_IF;
	IF LiquidInTemp < -50 OR LiquidIntemp > 200 THEN
		Bath^.TempStatus := ENUM_TempStatuses.tempInsensorFail;
		Bath^.MainStatus := ENUM_MainStatuses.liquidTempSensorFail;
	END_IF;

	
	IF Bath^.TempStatus = ENUM_TempStatuses.statusOK THEN
		LiquidAlertTemp := Bath^.BathConfig.LiquidAlertTemp;
		//Checking what liquid below Alert temperature
		IF LiquidInTemp > LiquidAlertTemp  THEN
			Bath^.TempStatus := ENUM_TempStatuses.tempLiquidAlert;
			Bath^.MainStatus := ENUM_MainStatuses.highLiquidTempStatus;
		END_IF;
		IF LiquidOutTemp > LiquidAlertTemp THEN
			Bath^.TempStatus := ENUM_TempStatuses.tempLiquidAlert;
			Bath^.MainStatus := ENUM_MainStatuses.highLiquidTempStatus;
		END_IF;
	ELSE
		//If first start or start after error reset, cooling liquid to target
		IF Bath^.TempStatus < ENUM_TempStatuses.tempInSensorFail THEN
			IF LiquidInTemp > Bath^.BathConfig.LiquidTargetTemp  THEN
				Bath^.TempStatus := ENUM_TempStatuses.tempCoolingMode;
				IF Bath^.Freq <> 100 THEN
					Bath^.Freq := 100;
					UpdateFanFreq(Bath:= Bath);
				END_IF;
			ELSE
				IF LiquidInTemp < Bath^.BathConfig.LiquidTargetTemp  THEN
					Bath^.TempStatus := ENUM_TempStatuses.statusOK;
				END_IF;
			END_IF;
		ELSE
			//Checking is sensor connected and working propertly after reseting error
				IF LiquidInTemp > -50 AND LiquidIntemp < 200 THEN
					Bath^.TempStatus := ENUM_TempStatuses.statusOK;
				END_IF;
				IF LiquidOutTemp > -50 AND LiquidOuttemp < 200 THEN
					Bath^.TempStatus := ENUM_TempStatuses.statusOK;
				END_IF;
		END_IF
	END_IF;

	//Cheking level sensor
	IF Bath^.LevelSensor = TRUE THEN
		Bath^.MainStatus := ENUM_MainStatuses.liquidLevelFail;
		Bath^.LevelStatus := ENUM_LevelStatuses.statusFail;
		MainRelayDisable(Bath := Bath);
		Bath^.PumpKMStatus := FALSE;
	ELSE
		Bath^.LevelStatus := ENUM_LevelStatuses.statusOK;
		Bath^.PumpKMStatus := TRUE;
	END_IF;
	
	//If all ok, working in normal mode
	IF Bath^.LevelStatus = ENUM_LevelStatuses.statusOK 
		AND Bath^.TempStatus = ENUM_TempStatuses.statusOK
		AND Bath^.MainStatus = ENUM_MainStatuses.statusOK THEN
		//Timer for fan speed recalculating
		IF Bath^.FanLastReload = FALSE AND Bath^.Bath_Freq_TON.Q = FALSE THEN
			Bath^.FanLastReload := TRUE;
		END_IF
		Bath^.Bath_Freq_TON(IN := Bath^.FanLastReload, PT := Bath^.BathConfig.LiquidStepInterval);
		//Recalculating and setting fan speed
		IF Bath^.Bath_Freq_TON.Q = TRUE THEN
			FrequenceRecalculate(Bath:= Bath);
			UpdateFanFreq(Bath:= Bath);
			Bath^.FanLastReload := FALSE;
		END_IF;

		Bath^.PumpKMStatus := TRUE;
		MainRelayEnable(Bath := Bath);
	END_IF;
ELSE
	IF Bath^.MainStatus <= ENUM_MainStatuses.mainStatusRemoteErrorReset THEN
		MainRelayDisable(Bath := Bath);
	END_IF;
END_IF;
