__METADATA__
{
  "v3Meta": {
    "objectGuid": "adad1634-155d-4798-a2bc-d7b70b38fa38",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {
      "_3S.CoDeSys.LanguageModelManager.BuildProperty": "<?xml version=\"1.0\" encoding=\"utf-8\"?><Single xml:space=\"preserve\" Type=\"{24568a24-c491-472c-a21f-ee5d33859fab}\" Method=\"IArchivable\"><Single Name=\"MemoryReserveForOnlineChange\" Type=\"int\">0</Single><Single Name=\"ExcludeFromBuild\" Type=\"bool\">False</Single><Single Name=\"External\" Type=\"bool\">False</Single><Single Name=\"EnableSystemCall\" Type=\"bool\">False</Single><Single Name=\"CompilerDefines\" Type=\"string\"></Single><Single Name=\"LinkAlways\" Type=\"bool\">False</Single><Array Name=\"Undefines\" Type=\"string\" /></Single>"
    },
    "subObjects": {}
  }
}
__DECLARATION__
FUNCTION_BLOCK frequencyCalculate
VAR_INPUT
	Bath: POINTER TO Bath;
END_VAR
VAR_OUTPUT
END_VAR
VAR
	freqMax :UINT := 100;
	error, diff1, diff, freqTemp,Kp :REAL;
	LiquidInTemp: REAL;
	LiquidTargetTemp: REAL;
	LiquidDecreaseMax: REAL;
	LiquidIncreaseMax: REAL;
END_VAR
__IMPLEMENTATION__
LiquidInTemp := Bath^.LiquidInTemp;
LiquidTargetTemp := Bath^.BathConfig.LiquidTargetTemp;
freqTemp := Bath^.Freq;
LiquidDecreaseMax := Bath^.LiquidDecreaseMax;
LiquidIncreaseMax := Bath^.LiquidIncreaseMax;

IF LiquidInTemp < LiquidDecreaseMax OR LiquidInTemp > LiquidIncreaseMax OR LiquidInTemp > LiquidTargetTemp+2 OR LiquidInTemp < LiquidTargetTemp-2  THEN
	
	IF LiquidInTemp < LiquidDecreaseMax THEN
		Bath^.LiquidDecreaseMax := LiquidInTemp;
		Bath^.LiquidIncreaseMax := LiquidTargetTemp;
	END_IF;
	
	IF LiquidInTemp > LiquidIncreaseMax THEN 
		Bath^.LiquidIncreaseMax := LiquidInTemp;
		Bath^.LiquidDecreaseMax := LiquidTargetTemp;
	END_IF
	
	IF LiquidInTemp > LiquidTargetTemp-0.5 OR LiquidInTemp < LiquidTargetTemp+0.5 THEN
		Kp := 1.2;
	ELSE
		Kp := 1;
	END_IF
	
	error := LiquidInTemp - LiquidTargetTemp;
	diff1 := LiquidTargetTemp / 100 * Kp;
	diff :=diff1 * error;
	freqTemp := freqTemp + diff;
	
END_IF


IF Bath^.Freq = 0 AND  freqTemp > 0 AND freqTemp < 10 THEN
	freqTemp := 10;
END_IF;

IF freqTemp < Bath^.BathConfig.FanMinFreq THEN
	freqTemp := Bath^.BathConfig.FanMinFreq;
END_IF;

IF freqTemp > freqMax THEN
	freqTemp := freqMax;
END_IF;

Bath^.Freq := freqTemp;
