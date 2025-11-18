__METADATA__
{
  "v3Meta": {
    "objectGuid": "0891eb52-ff7e-4a7f-bbdb-f4519479b08c",
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
FUNCTION getBathStats : STRING(300)
VAR_INPUT
	Bath:		POINTER TO Bath;
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
getBathStats := '';
//Liquid in temp
getBathStats := CONCAT(getBathStats, INT_TO_STRING(REAL_TO_INT(Bath^.LiquidInTemp*100)));
getBathStats := CONCAT(getBathStats ,':');
//Liquid Out Temp 
getBathStats := CONCAT(getBathStats, INT_TO_STRING(REAL_TO_INT(Bath^.LiquidOutTemp*100)));
getBathStats := CONCAT(getBathStats ,':');
//Pressure Incoming
getBathStats := CONCAT(getBathStats, UINT_TO_STRING(REAL_TO_UINT(Bath^.PressureIncoming*100)));
getBathStats := CONCAT(getBathStats ,':');
//Pressure Outgoing
getBathStats := CONCAT(getBathStats, UINT_TO_STRING(REAL_TO_UINT(Bath^.PressureOutgoing*100)));
getBathStats := CONCAT(getBathStats ,':');
//Freq
getBathStats := CONCAT(getBathStats, UINT_TO_STRING(REAL_TO_UINT(Bath^.Freq)));
getBathStats := CONCAT(getBathStats ,':');
//MainStatus
getBathStats := CONCAT(getBathStats, INT_TO_STRING(Bath^.MainStatus));
getBathStats := CONCAT(getBathStats ,':');
//TempStatus
getBathStats := CONCAT(getBathStats, INT_TO_STRING(Bath^.TempStatus));
getBathStats := CONCAT(getBathStats ,':');
//LevelStatus
getBathStats := CONCAT(getBathStats, INT_TO_STRING(Bath^.LevelStatus));
getBathStats := CONCAT(getBathStats ,':');
//MainRelayTripStatus
getBathStats := CONCAT(getBathStats, BOOL_TO_STRING(Bath^.MainRelayTripStatus));
getBathStats := CONCAT(getBathStats ,':');
//MainKMTripStatus
getBathStats := CONCAT(getBathStats, BOOL_TO_STRING(Bath^.MainKMTripStatus));
getBathStats := CONCAT(getBathStats ,':');
//PumpKMTripStatus
getBathStats := CONCAT(getBathStats, BOOL_TO_STRING(Bath^.PumpKMTripStatus));
getBathStats := CONCAT(getBathStats ,':');
//PumpCBTripStatus
getBathStats := CONCAT(getBathStats, BOOL_TO_STRING(Bath^.PumpCBTripStatus));
getBathStats := CONCAT(getBathStats ,':');
//ACCBTripStatus
getBathStats := CONCAT(getBathStats, BOOL_TO_STRING(Bath^.ACCBTripStatus));
getBathStats := CONCAT(getBathStats ,':');
//MainRelayStatus
getBathStats := CONCAT(getBathStats, BOOL_TO_STRING(Bath^.MainRelayStatus));
getBathStats := CONCAT(getBathStats ,':');
//MainKMStatus
getBathStats := CONCAT(getBathStats, BOOL_TO_STRING(Bath^.MainKMStatus));
getBathStats := CONCAT(getBathStats ,':');
//PumpKMStatus
getBathStats := CONCAT(getBathStats, BOOL_TO_STRING(Bath^.PumpKMStatus));
