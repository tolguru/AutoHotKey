/*
전역변수 선언
*/
global isStop := false

/*
기본 기능 설정
*/
alwaysOnDisplay()

/*
기본 기능 선언
*/
^+F1::alwaysOnDisplay()
^+F2::global isStop := true

alwaysOnDisplay() {
	Loop {
		Sleep(480000)

		MouseGetPos(&x, &y)
		MouseMove(x + 1, y + 1)
		MouseMove(x - 1, y + 1)
		MouseMove(x + 1, y - 1)
		MouseMove(x - 1, y - 1)

		if (isStop) {
			break
		}
	}
}