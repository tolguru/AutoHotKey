#Include common.ahk

Pause::Reload
return

;---------------------------------------------------------------------------------------------------------
; Bitvise 터미널
;---------------------------------------------------------------------------------------------------------
#IfWinActive ahk_class totermw_wnd
!/::
MsgBox,
(
----- 접속, 로그 관리 -----

-SHELL-
^1 - 접속
^2 - 리스트
^3 - Clipboard, 로그 출력
^4 - POD의 LAMP 로그 출력


-기존 방식-
^+1 - 접속
^+2 - 리스트
^+3 - Clipboard, 로그 출력
^+4 - Pod 접속

^9 - Installer Server
^0 - Batch Server

F9, F10 - 기존 방식 card 자동화


----- batch 온누리가맹점 적재자료 체크 -----

F1 - Clipboard, vi, 내용 체크
F2 - +g, vi 마지막행으로 이동
F3 - :q, vi 종료
F4 - Clipboard, 개수 체크
F8 - 폴더별로 출력
)
return

; 기존 방식으로 API CARD 서비스 리스트 출력
F9::
accessPodAuto()
displayPoList(true)
return

; 기존 방식, API CARD 로그 출력
F10::displayLog(true)
return

; Shell 사용, Installer 접속 -> 로그 Shell 입력
^1::accessPod()
return

^2::displayPoListShell()
return

; Shell 사용, 로그 Shell 출력
^3::displayLogToShell()
return

; Pod 접속
^4::accessInPodShell()
return

; 기존 방식, Installer 접속
^+1::accessPodAuto()
return

; 기존 방식, Card 리스트 출력
^+2::displayPoList(false)
return

; 기존 방식, 로그 출력 직전 멈춤
^+3::displayLog(false)
return

; 기존 방식, Pod 접속
^+4::accessInPod()
return

^9::accessInstaller()
;accessDevServer()
return

^0::accessBatchServer()
return

; batch 온누리가맹점 적재자료 체크
F1::showMsg(Round((Clipboard-2602)/1301), 1)
return

;F12::
;
;return

accessInstaller() {
	WinGetTitle, title, A
	title := SubStr(title, 11, 3)

	if (title = "DEV") {
		SendInput, /home/centos/external/connInstaller.sh`n
		Sleep, 200

		SendInput, sudo su -`n
		Sleep, 300
	} else if (title = "PRO") {
		SendInput, ssh -i /home/centos/.ssh/eonnuri.pem centos@10.232.129.32`n
		Sleep, 200

		SendInput, sudo su -`n
		Sleep, 400
	} else {
		showMsg("터미널 Title을 식별할 수 없음", 2)
	}
	return
}

displayLog(isCard) {
	SendInput, oc logs -f %Clipboard% -n external-api
	if (isCard) {
		SendInput, -card`n

	}
	return
}

accessPod() {
	accessInstaller()

	SendInput, cd /home/external`n
	Sleep, 10
	return
}

accessPodAuto() {
	accessInstaller()

	SendInput, export KUBECONFIG=/data/install/cluster01/auth/kubeconfig`n
	Sleep, 200

	SendInput, oc get nodes -o wide`n
	Sleep, 500
	return
}

accessDevServer() {
	accessInstaller()

	SendInput, ssh core@10.232.130.199`n
	Sleep, 300

	SendInput, sudo su -`n
	return
}

accessBatchServer() {
	SendInput, ssh -i /home/centos/.ssh/eonnuri.pem centos@10.232.130.214`n
	Sleep, 200

	SendInput, sudo su -`n
	return
}

accessInPodShell() {
	SendInput, ./showLampLog.sh card %Clipboard%
	return
}

accessInPod() {
	SendInput, oc exec -it %Clipboard% -n external-api -- sh
	return
}

displayPoListShell() {
	SendInput, ./showPodLog.sh card
	return
}

displayPoList(isCard) {
	SendInput, oc get po -n external-api

	if (isCard) {
		SendInput -card -o wide`n
		return
	}

	SendInput, ` -o wide
	return
}

displayLogToShell() {
	Send, {Up}
	SendInput, ` %Clipboard%`n
}

checkFranchise(isPutEnter) {
	clipboardLength := StrLen(Clipboard)

	SendInput, vi `

	if (clipboardLength = 35) {
		path := "/home/bccardbatch/franchisee"
	} else if (clipboardLength = 36) {
		path := "/home/bccardbatch/franchiseeinteg"
	} else if (clipboardLength = 38) {
		path := StrReplace("/home/zzcardbatch/zzfranchisee", "zz", SubStr(Clipboard, 24, 2))
	} else {
		MsgBox, 길이가 일치하는 경우가 없음
		return
	}

	SendInput, %path%/%Clipboard%
	if (isPutEnter) {
		SendInput, `n
	}
	return
}


;---------------------------------------------------------------------------------------------------------
; /Using definition
;---------------------------------------------------------------------------------------------------------

;---------------------------------------------------------------------------------------------------------
; Function definition/
;---------------------------------------------------------------------------------------------------------

;---------------------------------------------------------------------------------------------------------
; /Function definition
;---------------------------------------------------------------------------------------------------------

;---------------------------------------------------------------------------------------------------------
; etc/
;---------------------------------------------------------------------------------------------------------
;^2::
;now := CurrentDateTime
;FormatTime, now,, yyyyMMdd
;SendInput /home/onnuri/external/apicard/logs/telegram_%now%.log

; 08.09 backup
;F9::
;accessPod()
;displayPoList(true)
;return
;
;F10::
;displayLog(true)
;return
;
;^1::
;accessPod()
;return
;
;^+1::
;accessInstaller()
;return
;
;^2::
;displayPoList(true)
;return
;
;^+2::
;displayPoList(false)
;return
;
;^3::
;displayLog(true)
;return
;
;^+3::
;displayLog(false)
;return
;
;^9::
;accessDevServer()
;return
;
;^0::
;accessBatchServer()
;return
;
;^4::
;Send ^a
;return
;
;accessInstaller() {
;	SendInput, ssh -i /home/centos/.ssh/eonnuri.pem centos@10.232.130.209`n
;	Sleep, 300
;	SendInput, su - root`n
;	Sleep, 300
;	SendInput, @OKD12#`n
;	Sleep, 400
;	return
;}
;
;displayLog(isCard) {
;	SendInput, oc logs -f `
;	Click, 100 100 Right
;	SendInput, ` -n external-api
;	if (isCard) {
;		SendInput, -card`n
;	}
;	return
;}
;
;accessPod() {
;	accessInstaller()
;	SendInput, export KUBECONFIG=/data/install/cluster01/auth/kubeconfig`n
;	Sleep, 200
;	SendInput, oc get nodes`n
;	return
;}
;
;accessDevServer() {
;	accessInstaller()
;	SendInput, ssh core@10.232.130.199`n
;	Sleep, 300
;	SendInput, sudo su - root`n
;	return
;}
;
;accessBatchServer() {
;	SendInput, ssh -i /home/centos/.ssh/eonnuri.pem centos@10.232.130.214`n
;	Sleep, 200
;	SendInput, su - root`n
;	return
;}
;
;displayPoList(isCard) {
;	SendInput, oc get po -n external-api
;	if (isCard) {
;		SendInput -card`n
;	}
;	return
;}
;---------------------------------------------------------------------------------------------------------
; /etc
;---------------------------------------------------------------------------------------------------------