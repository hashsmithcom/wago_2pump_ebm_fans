__METADATA__
{
  "v3Meta": {
    "objectGuid": "bacb65cf-9697-47c5-b531-e2f143b164a0",
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
FUNCTION getBathConf : STRING(300)
VAR_INPUT
	Bath:		POINTER TO Bath;
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
getBathConf := '';
//AdminMainRelay
getBathConf := CONCAT(getBathConf, INT_TO_STRING(Bath^.BathConfig.AdminMainRelay));
getBathConf := CONCAT(getBathConf ,':');
//AdminPumpRelay 
getBathConf := CONCAT(getBathConf, INT_TO_STRING(Bath^.BathConfig.AdminPumpRelay));
getBathConf := CONCAT(getBathConf ,':');
//AdminFanRelay
getBathConf := CONCAT(getBathConf, INT_TO_STRING(Bath^.BathConfig.AdminFanRelay));
getBathConf := CONCAT(getBathConf ,':');
//LiquidStepInterval
getBathConf := CONCAT(getBathConf, TIME_TO_STRING(Bath^.BathConfig.LiquidStepInterval));
getBathConf := CONCAT(getBathConf ,':');
//LiquidTargetTemp
getBathConf := CONCAT(getBathConf, UINT_TO_STRING(Bath^.BathConfig.LiquidTargetTemp));
getBathConf := CONCAT(getBathConf ,':');
//LiquidAlertTemp
getBathConf := CONCAT(getBathConf, UINT_TO_STRING(Bath^.BathConfig.LiquidAlertTemp));
getBathConf := CONCAT(getBathConf ,':');
//PressureStabilizeInterval
getBathConf := CONCAT(getBathConf, TIME_TO_STRING(Bath^.BathConfig.PressureStabilizeInterval));
getBathConf := CONCAT(getBathConf ,':');
//PressureStabilizeTarget
getBathConf := CONCAT(getBathConf, REAL_TO_STRING(Bath^.BathConfig.PressureStabilizeTarget));
getBathConf := CONCAT(getBathConf ,':');
//FanMinFreq
getBathConf := CONCAT(getBathConf, UINT_TO_STRING(Bath^.BathConfig.FanMinFreq));
