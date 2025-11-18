__METADATA__
{
  "v3Meta": {
    "objectGuid": "1417d12e-9ef1-45cb-8380-2109a88ea4c9",
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
FUNCTION updateCalibrate : STRING(150);
VAR_INPUT
	sString			: STRING(300);
END_VAR
VAR
	sSeparatorChar: STRING := ':';
	configArray		: ARRAY [0..8] OF STRING;
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

IF configPosition = 8 THEN
	PV.BathConfigs[0].CalibrateInPressureSensorMIN := STRING_TO_UINT(configArray[configCheck]);
	configCheck := configCheck +1;
	
	PV.BathConfigs[0].CalibrateInPressureSensorDelta := STRING_TO_UINT(configArray[configCheck]);
	configCheck := configCheck +1;
	
	PV.BathConfigs[0].CalibrateOutPressureSensorMIN := STRING_TO_UINT(configArray[configCheck]);
	configCheck := configCheck +1;
	
	PV.BathConfigs[0].CalibrateOutPressureSensorDelta := STRING_TO_UINT(configArray[configCheck]);
	configCheck := configCheck +1;
	
	PV.BathConfigs[1].CalibrateInPressureSensorMIN := STRING_TO_UINT(configArray[configCheck]);
	configCheck := configCheck +1;
	
	PV.BathConfigs[1].CalibrateInPressureSensorDelta := STRING_TO_UINT(configArray[configCheck]);
	configCheck := configCheck +1;
	
	PV.BathConfigs[1].CalibrateOutPressureSensorMIN := STRING_TO_UINT(configArray[configCheck]);
	configCheck := configCheck +1;
	
	PV.BathConfigs[1].CalibrateOutPressureSensorDelta := STRING_TO_UINT(configArray[configCheck]);
	configCheck := configCheck +1;
	
	GVL.Baths[0].BathConfig := PV.BathConfigs[0];
	GVL.Baths[1].BathConfig := PV.BathConfigs[1];
	
	updateCalibrate := 'SUCCESS';
ELSE
	updateCalibrate := 'FAIL';
END_IF
