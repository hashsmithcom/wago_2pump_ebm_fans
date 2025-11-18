__METADATA__
{
  "v3Meta": {
    "objectGuid": "3be9e947-461a-4153-9608-4b77d9a91a3c",
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
PROGRAM TcpServer
VAR
	fbTcpServer: 			NBS.TCP_Server; 		// ФБ TCP-сервера
	// Массив структур для обработки подключений
	astClients: 			ARRAY [1..usiMaxConnections] OF CONNECTION;
	astClientsStats: 		ARRAY [1..usiMaxConnections] OF STRING(500);
	astClientsConf: 		ARRAY [1..usiMaxConnections] OF STRING(500);
	lastSize:				UINT;
	lastSizeLen:			INT;
	uiPortServer: 			UINT := 4444;
	usiActiveClientCounter: USINT; 					// Число подключенных клиентов
	i: 						INT; 					// Счетчик для цикла
END_VAR
VAR CONSTANT
	// Максимальное число подключенных клиентов
	usiMaxConnections: 		USINT := 10;
END_VAR
__IMPLEMENTATION__
// создаем сервер на заданном порту
fbTcpServer(xEnable:= TRUE,ipAddr := ,uiPort := uiPortServer);

IF fbTcpServer.xError THEN
	fbTcpServer(xEnable:= FALSE);
	; // обработка ошибок
END_IF

// создаем обработчики подключений для клиентов
FOR i:=1 TO usiMaxConnections DO
	astClients[i].fbTcpConnection(xEnable:=fbTcpServer.xBusy,hServer:=fbTcpServer.hServer);
	
	IF astClients[i].fbTcpConnection.xError THEN
		; // обработка ошибок
	END_IF
	// отслеживаем подключение клиента
	astClients[i].fbAddClient(CLK:=astClients[i].fbTcpConnection.xActive);
	// регистрируем подключение нового клиента
	IF astClients[i].fbAddClient.Q THEN
		usiActiveClientCounter := usiActiveClientCounter + 1;
	END_IF
	// регистрируем отключение одного из клиентов
	IF astClients[i].fbTcpConnection.xDone THEN
		usiActiveClientCounter := usiActiveClientCounter - 1;
	END_IF
	CASE astClients[i].eState OF
		SERVER_STATE.CREATE: // проверяем, что подключился клиент
			IF astClients[i].fbTcpConnection.xActive THEN
			astClients[i].eState:=SERVER_STATE.LISTEN;
			END_IF
		SERVER_STATE.LISTEN: // получаем данные от клиента
			astClients[i].fbTcpRead(xEnable := astClients[i].fbTcpConnection.xActive,hConnection := astClients[i].fbTcpConnection.hConnection,pData := ADR(astClients[i].sClientString),szSize := SIZEOF(astClients[i].sClientString));
			// если получен запрос от клиента - подготавливаем ответ
			IF astClients[i].fbTcpRead.xReady THEN
				astClients[i].sInverseString := 'Unknown command';
				IF FIND(astClients[i].sClientString, 'GET_STATS') > 0 THEN 
					astClientsStats[i] := getStats();
					astClients[i].sInverseString:=astClientsStats[i];
				ELSIF FIND(astClients[i].sClientString, 'GET_CONF') > 0 THEN
					astClientsConf[i] := getConf();
					astClients[i].sInverseString:=astClientsConf[i];
				ELSIF FIND(astClients[i].sClientString, 'GET_CALIBRATE') > 0 THEN
					astClientsConf[i] := getCalibrate();
					astClients[i].sInverseString:=astClientsConf[i];
				ELSIF FIND(astClients[i].sClientString, 'UPDATE_CONF') > 0 THEN
					astClients[i].sInverseString:=updateConf(sString := astClients[i].sClientString);
				ELSIF FIND(astClients[i].sClientString, 'UPDATE_CALIBRATE') > 0 THEN
					astClients[i].sInverseString:=updateCalibrate(sString := astClients[i].sClientString);
				ELSIF FIND(astClients[i].sClientString, 'REMOTE_RESET') > 0 THEN
					PV.main_remote_command := ENUM_MainStatuses.mainStatusRemoteErrorReset;
					astClients[i].sInverseString:='SUCCESS';
				ELSIF FIND(astClients[i].sClientString, 'REMOTE_SOFT_SHUTDOWN') > 0 THEN
					PV.main_remote_command := ENUM_MainStatuses.mainStatusRemoteSoftShutDown;
					astClients[i].sInverseString:='SUCCESS';
				ELSIF FIND(astClients[i].sClientString, 'REMOTE_EMERGENCY') > 0 THEN
					PV.main_remote_command := ENUM_MainStatuses.mainStatusRemoteEmergencyShutDown;
					astClients[i].sInverseString:='SUCCESS';
				ELSIF FIND(astClients[i].sClientString, 'REMOTE_COLDSTART') > 0 THEN
					PV.main_remote_command := ENUM_MainStatuses.mainStatusRemoteColdStart;
					astClients[i].sInverseString:='SUCCESS';
				ELSIF FIND(astClients[i].sClientString, 'REMOTE_MAINTENANCE') > 0 THEN
					PV.main_remote_command := ENUM_MainStatuses.mainStatusRemoteMaintanceMode;
					astClients[i].sInverseString:='SUCCESS';
				END_IF
				astClients[i].eState:=SERVER_STATE.SEND;
			ELSIF astClients[i].fbTcpRead.xError THEN
				; // обработка ошибок
			END_IF
		SERVER_STATE.SEND: // отправляем ответ клиенту
			lastSize    := SIZEOF(astClients[i].sInverseString);
			lastSizeLen := LEN(astClients[i].sInverseString);
			astClients[i].fbTcpWrite(xExecute := TRUE,hConnection := astClients[i].fbTcpConnection.hConnection,pData := ADR(astClients[i].sInverseString), szSize := LEN(astClients[i].sInverseString));
			// если ответ успешно отправлен - продолжаем слушать порт, ожидая следующего запроса
			IF astClients[i].fbTcpWrite.xDone THEN
				astClients[i].fbTcpWrite(xExecute:=FALSE);
				astClients[i].fbTcpConnection(xEnable := FALSE);
				astClients[i].eState:=SERVER_STATE.LISTEN;
			ELSIF astClients[i].fbTcpWrite.xError THEN
				astClients[i].fbTcpConnection(xEnable := FALSE);
				; // обработка ошибок
			END_IF
	END_CASE
END_FOR
