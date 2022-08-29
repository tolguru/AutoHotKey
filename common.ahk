showMsg(msg, seconds) {
	ToolTip, %msg%
	Sleep, % seconds * 1000
	ToolTip
}

showTrayMsg(title, msg, seconds) {
	TrayTip, %title%, %msg%
	Sleep, % seconds * 1000
	TrayTip
}
