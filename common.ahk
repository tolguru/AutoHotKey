showMsg(msg, seconds) {
	ToolTip, %msg%
	SetTimer, RemoveToolTip, % seconds * -1000
}

showTrayMsg(title, msg, seconds) {
	TrayTip, %title%, %msg%
	SetTimer, RemoveTrayTip, % seconds * -1000
}

RemoveToolTip:
	ToolTip
return

RemoveTrayTip:
	TrayTip
return