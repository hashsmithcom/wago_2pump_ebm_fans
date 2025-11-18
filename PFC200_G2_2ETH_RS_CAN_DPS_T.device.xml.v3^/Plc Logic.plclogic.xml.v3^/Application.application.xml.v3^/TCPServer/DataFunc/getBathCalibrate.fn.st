__METADATA__
{
  "v3Meta": {
    "objectGuid": "b33815b0-5a15-4c02-b35e-4a2c81901653",
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
FUNCTION getBathCalibrate : STRING(300)
VAR_INPUT
	Bath:		POINTER TO Bath;
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
getBathCalibrate := '';
//
getBathCalibrate := CONCAT(getBathCalibrate, UINT_TO_STRING(Bath^.BathConfig.CalibrateInPressureSensorMIN));
getBathCalibrate := CONCAT(getBathCalibrate ,':');
// 
getBathCalibrate := CONCAT(getBathCalibrate, UINT_TO_STRING(Bath^.BathConfig.CalibrateInPressureSensorDelta));
getBathCalibrate := CONCAT(getBathCalibrate ,':');
//
getBathCalibrate := CONCAT(getBathCalibrate, UINT_TO_STRING(Bath^.BathConfig.CalibrateOutPressureSensorMIN));
getBathCalibrate := CONCAT(getBathCalibrate ,':');
//
getBathCalibrate := CONCAT(getBathCalibrate, UINT_TO_STRING(Bath^.BathConfig.CalibrateOutPressureSensorDelta));
