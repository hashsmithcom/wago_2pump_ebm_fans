__METADATA__
{
  "v3Meta": {
    "objectGuid": "4dca100b-ef0c-4f4b-ad53-04cccb9d8b2a",
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
FUNCTION getStats : STRING(500)
VAR_INPUT
END_VAR
VAR
	Bath1Stat : STRING(300);
	Bath2Stat : STRING(300);
END_VAR
__IMPLEMENTATION__
getStats := 'START:';
Bath1Stat := getBathStats(Bath := ADR(GVL.Baths[0]));
getStats := CONCAT(getStats, Bath1Stat);
getStats := CONCAT(getStats, ':');
Bath2Stat := getBathStats(Bath := ADR(GVL.Baths[1]));
getStats := CONCAT(getStats, Bath2Stat);
getStats := CONCAT(getStats, ':');
getStats := CONCAT(getStats, UINT_TO_STRING(REAL_TO_UINT(GVL.ContainerAirTemp*100)));
getStats := CONCAT(getStats, ':');
getStats := CONCAT(getStats, UINT_TO_STRING(REAL_TO_UINT(GVL.ContainerAirHumi*100)));
getStats := CONCAT(getStats, ':');
getStats := CONCAT(getStats, UINT_TO_STRING(REAL_TO_UINT(GVL.CabinetAirTemp*100)));
getStats := CONCAT(getStats, ':');
getStats := CONCAT(getStats, UINT_TO_STRING(REAL_TO_UINT(GVL.CabinetAirHumi*100)));
getStats := CONCAT(getStats, ':END');
