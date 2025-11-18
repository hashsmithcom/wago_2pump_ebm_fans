__METADATA__
{
  "v3Meta": {
    "objectGuid": "4cf7d6c5-b782-4ec0-bd09-cc02df7dd08c",
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
FUNCTION getCalibrate : STRING(500)
VAR_INPUT
END_VAR
VAR
	Bath1Conf : STRING(300);
	Bath2Conf : STRING(300);
END_VAR
__IMPLEMENTATION__
getCalibrate := 'START:';
Bath1Conf := getBathCalibrate(Bath := ADR(GVL.Baths[0]));
getCalibrate := CONCAT(getCalibrate, Bath1Conf);
getCalibrate := CONCAT(getCalibrate, ':');
Bath2Conf := getBathCalibrate(Bath := ADR(GVL.Baths[1]));
getCalibrate := CONCAT(getCalibrate, Bath2Conf);
