/*
Global Object
*/
global viPathMap := Map()
viPathMap["001"] := "vi /home/{2}cardbatch/tx/{2}_compare_{3}.txt"
viPathMap["003"] := "vi /home/{2}cardbatch/purchase/{2}_cancel_{3}.txt"
viPathMap["004"] := "vi /home/{2}cardbatch/settle/{2}_settle_info_{3}.txt"
viPathMap["005"] := "vi /home/{2}cardbatch/card/{2}_status_info_{3}.txt"
viPathMap["006"] := "vi /home/bccardbatch/franchiseeinteg/onnuri_franchisee_integ_{3}.txt"
viPathMap["007"] := "vi /home/bccardbatch/openbank/bc_openbank_{3}.txt"

global filePathMap := Map()
filePathMap["001"] := "ll /home/{2}cardbatch/tx/"
filePathMap["003"] := "ll /home/{2}cardbatch/purchase/"
filePathMap["004"] := "ll /home/{2}cardbatch/settle/"
filePathMap["005"] := "ll /home/{2}cardbatch/card/"
filePathMap["006"] := "ll /home/bccardbatch/franchiseeinteg/"
filePathMap["007"] := "ll /home/bccardbatch/openbank/"

global LOG_PATH_DEFAULT := "vi /home/batch/external/logs/default_{2}.log"
global LOG_PATH_RESULT  := "vi /home/batch/external/logs/BATCH_{1}/result_{2}.log"

global BATCH_RUN_PATH   := "/home/batch/external/batchExcute.sh BATCH_{1} {3} {2}CARD__"

CapsLock::Delete
F12::Reload

F1:: {
	commandArray := inputCommands("파일")

	if (commandArray.Length = 0)  {
		return
	}

	runCommands(commandArray, viPathMap)
}

F2:: {
	commandArray := inputCommands("리스트")

	if (commandArray.Length = 0)  {
		return
	}

	runCommands(commandArray, filePathMap)
}

F3:: {
	commandArray := inputCommands("로그")

	if (commandArray.Length = 0 || commandArray.Length > 2)  {
		return
	}

	if (commandArray.Length = 1) {
		commandArray.Push(FormatTime(, "yyyyMMdd"))
	}

	if (commandArray[1] = "000") {
		runDuplicationCommands(commandArray, LOG_PATH_DEFAULT)
	} else {
		runDuplicationCommands(commandArray, LOG_PATH_RESULT)
	}
}

F4:: {
	commandArray := inputCommands("배치 실행")

	if (commandArray.Length = 0)  {
		return
	}

	commandArray[2] := StrUpper(commandArray[2])

	runDuplicationCommands(commandArray, BATCH_RUN_PATH)
}

F5:: {
	MsgBox(StrGet(Buffer("ec9588eb85950d0a"), "UTF-8"))
}

inputCommands(title) {
	commandArray := StrSplit(InputBox("F1 : 파일 / F2 : 리스트 / F3 : 로그 / F4 : 배치 실행`n`n입력값 : 배치코드 (카드사) (날짜)`n`n001 : 거래대사 / 002 : 정산이체 / 003 : 매입취소`n004 : 정산정보 / 005 : 카드상태 / 006 : 통합자료 / 007 : 머니플랫폼`n`n예시 : 001 bc 20220301`n         001 bc`n         000", title, "w400 h250").value, A_Space)

	if (commandArray.Length = 2 && StrLen(commandArray[2]) = 2) {
		commandArray.Push(FormatTime(, "yyyyMMdd"))
	}

	return commandArray
}

runCommands(commandArray, dataMap) {
	try {
		SendInput(Trim(Format(dataMap.Get(commandArray[1]), commandArray*)))
	} catch UnsetItemError {
		MsgBox("입력 값을 확인해주세요.")
	} catch Error {
	}
}

runDuplicationCommands(commandArray, path) {
	try {
		SendInput(Trim(Format(path, commandArray*)))
	} catch UnsetItemError {
		MsgBox("입력 값을 확인해주세요.")
	} catch Error {
	}
}