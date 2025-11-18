__METADATA__
{
  "v3Meta": {
    "objectGuid": "7a023974-3ed9-40ea-b936-88e5bca5239d",
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
PROGRAM TIMERS
VAR
	QF1_ENABLE_TOF : TOF;
	QF1_DISABLE_TOF : TOF;

	QF2_ENABLE_TOF : TOF;
	QF2_DISABLE_TOF : TOF;
END_VAR;
__IMPLEMENTATION__
(* Enabling QF1 *)
IF GVL.Baths[0].MainRelayDisable = FALSE THEN
	IF GVL.Baths[0].MainRelayEnable = TRUE THEN
		GVL.Baths[0].MainRelay_on := FALSE;
		GVL.Baths[0].MainRelayStatus := TRUE;
	END_IF;
	QF1_ENABLE_TOF(IN := GVL.Baths[0].MainRelay_on, PT := T#2S);
	GVL.Baths[0].MainRelayEnable := QF1_ENABLE_TOF.Q;
END_IF

IF GVL.Baths[0].MainRelayEnable = FALSE THEN
	IF GVL.Baths[0].MainRelayDisable = TRUE THEN
		GVL.Baths[0].MainRelay_off := FALSE;
		GVL.Baths[0].MainRelayStatus := FALSE;
	END_IF;
	QF1_DISABLE_TOF(IN := GVL.Baths[0].MainRelay_off, PT := T#5S);
	GVL.Baths[0].MainRelayDisable := QF1_DISABLE_TOF.Q;
END_IF;

(* Enabling QF2 *)
IF GVL.Baths[1].MainRelayDisable = FALSE THEN
	IF GVL.Baths[1].MainRelayEnable = TRUE THEN
		GVL.Baths[1].MainRelay_on := FALSE;
		GVL.Baths[1].MainRelayStatus := TRUE;
	END_IF;
	QF2_ENABLE_TOF(IN := GVL.Baths[1].MainRelay_on, PT := T#2S);
	GVL.Baths[1].MainRelayEnable := QF2_ENABLE_TOF.Q;
END_IF

(* Enabling QF2 *)
IF GVL.Baths[1].MainRelayEnable = FALSE THEN
	IF GVL.Baths[1].MainRelayDisable = TRUE THEN
		GVL.Baths[1].MainRelay_off := FALSE;
		GVL.Baths[1].MainRelayStatus := FALSE;
	END_IF;
	QF2_DISABLE_TOF(IN := GVL.Baths[1].MainRelay_off, PT := T#5S);
	GVL.Baths[1].MainRelayDisable := QF2_DISABLE_TOF.Q;
END_IF;

IF GVL.Baths[0].BathConfig.AdminFanRelay = ENUM_AdminRelayStatus.relayForceEnable THEN
	GVL.Baths[0].MainKMStatus := TRUE;
END_IF;

IF GVL.Baths[0].BathConfig.AdminFanRelay = ENUM_AdminRelayStatus.relayForceDisable THEN
	GVL.Baths[0].MainKMStatus := FALSE;
END_IF;

IF GVL.Baths[1].BathConfig.AdminFanRelay = ENUM_AdminRelayStatus.relayForceEnable THEN
	GVL.Baths[1].MainKMStatus := TRUE;
END_IF;

IF GVL.Baths[1].BathConfig.AdminFanRelay = ENUM_AdminRelayStatus.relayForceDisable THEN
	GVL.Baths[1].MainKMStatus := FALSE;
END_IF;

IF GVL.Baths[0].BathConfig.AdminPumpRelay = ENUM_AdminRelayStatus.relayForceEnable THEN
	GVL.Baths[0].PumpKMStatus := TRUE;
END_IF;

IF GVL.Baths[0].BathConfig.AdminPumpRelay = ENUM_AdminRelayStatus.relayForceDisable THEN
	GVL.Baths[0].PumpKMStatus := FALSE;
END_IF;

IF GVL.Baths[1].BathConfig.AdminPumpRelay = ENUM_AdminRelayStatus.relayForceEnable THEN
	GVL.Baths[1].PumpKMStatus := TRUE;
END_IF

IF GVL.Baths[1].BathConfig.AdminPumpRelay = ENUM_AdminRelayStatus.relayForceDisable THEN
	GVL.Baths[1].PumpKMStatus := FALSE;
END_IF
