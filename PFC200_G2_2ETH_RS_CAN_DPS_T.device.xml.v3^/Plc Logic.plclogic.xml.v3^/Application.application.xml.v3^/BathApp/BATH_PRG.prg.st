__METADATA__
{
  "v3Meta": {
    "objectGuid": "8777781a-7b36-4e09-af8b-6433de4710e3",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {
      "_3S.CoDeSys.CFCObject.CFCProperty": "<?xml version=\"1.0\" encoding=\"utf-8\"?><Single xml:space=\"preserve\" Type=\"{97c1f2ea-5995-48b9-abd5-a3ab983c5def}\" Method=\"IArchivable\"><Single Name=\"UseExplicitExecutionOrder\" Type=\"bool\">False</Single></Single>"
    },
    "subObjects": {}
  }
}
__DECLARATION__
PROGRAM BATH_PRG
VAR
	iCycle: UINT;
	App: BATH_APP;
	START 	:BOOL := FALSE;
	BathErrorsFunction: BathErrorsFunction;
END_VAR
__IMPLEMENTATION__
IF START = FALSE THEN
	START := TRUE;
	GVL.Baths[0].BathConfig := PV.BathConfigs[0];
	GVL.Baths[1].BathConfig := PV.BathConfigs[1];
END_IF

IF (GVL.QFUndervoltage = FALSE) THEN
	GVL.QFUndervoltage := TRUE;
ELSE
	App(Bath:= ADR(GVL.Baths[0]));
	App(Bath:= ADR(GVL.Baths[1]));
	
	BathErrorsFunction();
END_IF
