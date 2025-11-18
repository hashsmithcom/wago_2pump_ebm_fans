__METADATA__
{
  "v3Meta": {
    "objectGuid": "b48ad024-6b96-4d1d-a6d5-291519fd8cb7",
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
FUNCTION getConf : STRING(500)
VAR_INPUT
END_VAR
VAR
	Bath1Conf : STRING(300);
	Bath2Conf : STRING(300);
END_VAR
__IMPLEMENTATION__
getConf := 'START:';
Bath1Conf := getBathConf(Bath := ADR(GVL.Baths[0]));
getConf := CONCAT(getConf, Bath1Conf);
getConf := CONCAT(getConf, ':');
Bath2Conf := getBathConf(Bath := ADR(GVL.Baths[1]));
getConf := CONCAT(getConf, Bath2Conf);
getConf := CONCAT(getConf ,':');
//HighAirTemp
getConf := CONCAT(getConf, UINT_TO_STRING(PV.HighAirTemp));
getConf := CONCAT(getConf, ':END');
