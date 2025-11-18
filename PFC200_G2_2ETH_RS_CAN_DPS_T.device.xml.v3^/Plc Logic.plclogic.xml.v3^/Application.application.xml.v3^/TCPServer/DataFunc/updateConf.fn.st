__METADATA__
{
  "v3Meta": {
    "objectGuid": "05be4c63-e72f-44c1-9cee-b93b0a5ac58b",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
FUNCTION updateConf : STRING(150);
VAR_INPUT
	sString			: STRING(300);
END_VAR
VAR
	sSeparatorChar: STRING := ':';
	configArray		: ARRAY [0..19] OF STRING;
	i,j,configPosition: INT;
	
	configCheck : INT := 1;
END_VAR
__IMPLEMENTATION__
j := 0;
configPosition := 0;

FOR i:= 0 TO LEN(sString) DO
	IF sString[i] = sSeparatorChar[0] THEN
		configArray[configPosition] := MID(sString, i-j+1, j);
		configPosition := configPosition + 1;
		j := i + 2;
	END_IF
END_FOR

configArray[configPosition] := MID(sString, i-j, j);

IF configPosition = 19 THEN
	IF STRING_TO_INT(configArray[configCheck]) = 0 THEN
		PV.BathConfigs[0].AdminMainRelay := ENUM_AdminRelayStatus.relayForceEnable;
	ELSIF STRING_TO_INT(configArray[configCheck]) = 1 THEN
		PV.BathConfigs[0].AdminMainRelay := ENUM_AdminRelayStatus.relayAutoEnable;
	ELSIF STRING_TO_INT(configArray[configCheck]) = 2 THEN
		PV.BathConfigs[0].AdminMainRelay := ENUM_AdminRelayStatus.relayForceDisable;
	END_IF
	
	configCheck := configCheck +1;
	
	IF STRING_TO_INT(configArray[configCheck]) = 0 THEN
		PV.BathConfigs[0].AdminPumpRelay := ENUM_AdminRelayStatus.relayForceEnable;
	ELSIF STRING_TO_INT(configArray[configCheck]) = 1 THEN
		PV.BathConfigs[0].AdminPumpRelay := ENUM_AdminRelayStatus.relayAutoEnable;
	ELSIF STRING_TO_INT(configArray[configCheck]) = 2 THEN
		PV.BathConfigs[0].AdminPumpRelay := ENUM_AdminRelayStatus.relayForceDisable;
	END_IF
	
	configCheck := configCheck +1;
	
	IF STRING_TO_INT(configArray[configCheck]) = 0 THEN
		PV.BathConfigs[0].AdminFanRelay := ENUM_AdminRelayStatus.relayForceEnable;
	ELSIF STRING_TO_INT(configArray[configCheck]) = 1 THEN
		PV.BathConfigs[0].AdminFanRelay := ENUM_AdminRelayStatus.relayAutoEnable;
	ELSIF STRING_TO_INT(configArray[configCheck]) = 2 THEN
		PV.BathConfigs[0].AdminFanRelay := ENUM_AdminRelayStatus.relayForceDisable;
	END_IF
	
	configCheck := configCheck +1;
	
	PV.BathConfigs[0].LiquidStepInterval := STRING_TO_TIME(configArray[configCheck]);
	configCheck := configCheck +1;
	
	PV.BathConfigs[0].LiquidTargetTemp := STRING_TO_UINT(configArray[configCheck]);
	configCheck := configCheck +1;
	
	PV.BathConfigs[0].LiquidAlertTemp := STRING_TO_UINT(configArray[configCheck]);
	configCheck := configCheck +1;
	
	PV.BathConfigs[0].PressureStabilizeInterval := STRING_TO_TIME(configArray[configCheck]);
	configCheck := configCheck +1;
	
	PV.BathConfigs[0].PressureStabilizeTarget := STRING_TO_REAL(configArray[configCheck]);
	configCheck := configCheck +1;
	
	PV.BathConfigs[0].FanMinFreq := STRING_TO_UINT(configArray[configCheck]);
	configCheck := configCheck +1;
	
	
	
	IF STRING_TO_INT(configArray[configCheck]) = 0 THEN
		PV.BathConfigs[1].AdminMainRelay := ENUM_AdminRelayStatus.relayForceEnable;
	ELSIF STRING_TO_INT(configArray[configCheck]) = 1 THEN
		PV.BathConfigs[1].AdminMainRelay := ENUM_AdminRelayStatus.relayAutoEnable;
	ELSIF STRING_TO_INT(configArray[configCheck]) = 2 THEN
		PV.BathConfigs[1].AdminMainRelay := ENUM_AdminRelayStatus.relayForceDisable;
	END_IF
	configCheck := configCheck +1;
	
	IF STRING_TO_INT(configArray[configCheck]) = 0 THEN
		PV.BathConfigs[1].AdminPumpRelay := ENUM_AdminRelayStatus.relayForceEnable;
	ELSIF STRING_TO_INT(configArray[configCheck]) = 1 THEN
		PV.BathConfigs[1].AdminPumpRelay := ENUM_AdminRelayStatus.relayAutoEnable;
	ELSIF STRING_TO_INT(configArray[configCheck]) = 2 THEN
		PV.BathConfigs[1].AdminPumpRelay := ENUM_AdminRelayStatus.relayForceDisable;
	END_IF
	configCheck := configCheck +1;
	
	IF STRING_TO_INT(configArray[configCheck]) = 0 THEN
		PV.BathConfigs[1].AdminFanRelay := ENUM_AdminRelayStatus.relayForceEnable;
	ELSIF STRING_TO_INT(configArray[configCheck]) = 1 THEN
		PV.BathConfigs[1].AdminFanRelay := ENUM_AdminRelayStatus.relayAutoEnable;
	ELSIF STRING_TO_INT(configArray[configCheck]) = 2 THEN
		PV.BathConfigs[1].AdminFanRelay := ENUM_AdminRelayStatus.relayForceDisable;
	END_IF
	configCheck := configCheck +1;
	
	PV.BathConfigs[1].LiquidStepInterval := STRING_TO_TIME(configArray[configCheck]);
	configCheck := configCheck +1;
	
	PV.BathConfigs[1].LiquidTargetTemp := STRING_TO_UINT(configArray[configCheck]);
	GVL.Baths[0].LiquidIncreaseMax := STRING_TO_REAL(configArray[configCheck]);
	GVL.Baths[1].LiquidIncreaseMax := STRING_TO_REAL(configArray[configCheck]);
	GVL.Baths[0].LiquidDecreaseMax := STRING_TO_REAL(configArray[configCheck]);
	GVL.Baths[1].LiquidDecreaseMax := STRING_TO_REAL(configArray[configCheck]);
	configCheck := configCheck +1;
	
	PV.BathConfigs[1].LiquidAlertTemp := STRING_TO_UINT(configArray[configCheck]);
	configCheck := configCheck +1;
	
	PV.BathConfigs[1].PressureStabilizeInterval := STRING_TO_TIME(configArray[configCheck]);
	configCheck := configCheck +1;
	
	PV.BathConfigs[1].PressureStabilizeTarget := STRING_TO_REAL(configArray[configCheck]);
	configCheck := configCheck +1;
	
	PV.BathConfigs[1].FanMinFreq := STRING_TO_UINT(configArray[configCheck]);
	configCheck := configCheck +1;
	
	PV.HighAirTemp := STRING_TO_UINT(configArray[configCheck]);
	
	GVL.Baths[0].BathConfig := PV.BathConfigs[0];
	GVL.Baths[1].BathConfig := PV.BathConfigs[1];
	
	updateConf := 'SUCCESS';
ELSE
	updateConf := 'FAIL';
END_IF
