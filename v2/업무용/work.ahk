CapsLock::Delete
F12::Reload

F1:: {
	commandArray := inputCommands("테스트")
	;commandArray[1] := StrUpper(commandArray[1])

}

inputCommands(title) {
	return StrSplit(InputBox("배치코드 카드사 (날짜) (명령어)`n`n001 : 거래대사 / 002 : 정산이체 / 003 : 매입취소`n004 : 정산정보 / 005 : 카드상태 / 006 : 통합자료 / 007 : 머니플랫폼`n`n예시 : 001 bc 20220301 vi", title, "w400 h200").value, A_Space)
}

runCommands(commandArray) {

}

