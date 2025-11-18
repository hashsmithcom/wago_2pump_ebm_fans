__METADATA__
{
  "v3Meta": {
    "objectGuid": "0fa90ed9-fad0-452e-90ae-fbd1a767835f",
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
PROGRAM DATA_EXTRACTOR
VAR
	LeftIncomingTemp: INT;
	LeftOungoingTemp: INT;
	RightIncomingTemp: INT;
	RightOutgoingTemp: INT;
	
	LeftPressureIn: WORD;
	LeftPressureOut: WORD;
	RightPressureIn: WORD;
	RightPressureOut: WORD;
	
	ContainerAirTemp: WORD;
	ContainerAirHumi: WORD;
	
	CabinetAirTemp: WORD;
	CabinetAirHumi: WORD;

	AirTempSensorMin: REAL:= -40;
	AirTempSensorDeltaT: REAL:= 100;
	
	TempSensorMin: REAL:= -40;
	TempSensorDeltaT: REAL:= 100;
END_VAR;
__IMPLEMENTATION__
GVL.Baths[0].LiquidInTemp := INT_TO_REAL(LeftIncomingTemp)/10;
GVL.Baths[0].LiquidOutTemp := INT_TO_REAL(LeftOungoingTemp)/10;
GVL.Baths[1].LiquidInTemp := INT_TO_REAL(RightIncomingTemp)/10;
GVL.Baths[1].LiquidOutTemp := INT_TO_REAL(RightOutgoingTemp)/10;

GVL.Baths[0].PressureIncoming := (WORD_TO_REAL(LeftPressureIn)/2047.5)/16*GVL.Baths[0].BathConfig.CalibrateInPressureSensorDelta-ABS(GVL.Baths[0].BathConfig.CalibrateInPressureSensorMIN);
GVL.Baths[0].PressureOutgoing := (WORD_TO_REAL(LeftPressureOut)/2047.5)/16*GVL.Baths[0].BathConfig.CalibrateOutPressureSensorDelta-ABS(GVL.Baths[0].BathConfig.CalibrateOutPressureSensorMIN);
GVL.Baths[1].PressureIncoming := (WORD_TO_REAL(RightPressureIn)/2047.5)/16*GVL.Baths[1].BathConfig.CalibrateInPressureSensorDelta-ABS(GVL.Baths[1].BathConfig.CalibrateInPressureSensorMIN);
GVL.Baths[1].PressureOutgoing := (WORD_TO_REAL(RightPressureOut)/2047.5)/16*GVL.Baths[1].BathConfig.CalibrateOutPressureSensorDelta-ABS(GVL.Baths[1].BathConfig.CalibrateOutPressureSensorMIN);

GVL.Baths[0].PressureIncomingBar := GVL.Baths[0].PressureIncoming/14.5038;
GVL.Baths[0].PressureOutgoingBar := GVL.Baths[0].PressureOutgoing/14.5038;
GVL.Baths[1].PressureIncomingBar := GVL.Baths[1].PressureIncoming/14.5038;
GVL.Baths[1].PressureOutgoingBar := GVL.Baths[1].PressureOutgoing/14.5038;

GVL.ContainerAirTemp:= (WORD_TO_REAL(ContainerAirTemp)/2047.5)/16*AirTempSensorDeltaT-ABS(AirTempSensorMin);
GVL.ContainerAirHumi := (WORD_TO_REAL(CabinetAirHumi)/2047.5)/16*100;

GVL.CabinetAirTemp:= (WORD_TO_REAL(CabinetAirTemp)/2047.5)/16*AirTempSensorDeltaT-ABS(AirTempSensorMin);
GVL.CabinetAirHumi := (WORD_TO_REAL(CabinetAirHumi)/2047.5)/16*100;
