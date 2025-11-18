__METADATA__
{
  "v3Meta": {
    "objectGuid": "3150b598-9ac2-4b74-bf2a-eba7158ce868",
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
FUNCTION_BLOCK SET_FREQ_BALANCED
VAR_INPUT
	Bath: POINTER TO Bath;
END_VAR
VAR_OUTPUT
END_VAR
VAR
	FreqTemp: REAL;
	FanMinVar:WORD := 0;
	FanMaxVar:WORD := 64000;
	Speed:    WORD := 0;
	PW:		  ARRAY[0..5]OF BYTE := [101, 112, 77, 32, 69, 67];
	iCycle:UINT;
END_VAR
__IMPLEMENTATION__
FreqTemp := Bath^.Freq;

Speed := REAL_TO_WORD(FanMaxVar / 100 * FreqTemp);

IF Speed < FanMinVar THEN
	Speed := FanMinVar;
END_IF;
IF Speed > FanMaxVar THEN
	Speed := FanMaxVar;
END_IF;

FOR iCycle := 1 TO 12 BY 1 DO 
	Bath^.Fans[iCycle].Speed := Speed;
END_FOR;
