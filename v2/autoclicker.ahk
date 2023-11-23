#Requires AutoHotkey v2.0

SetMouseDelay(-1)

global isClickStop := false

F9::runClick
F10::stopClick
+Pause::Reload

runClick() {
    Loop {
        if (isClickStop) {
            global isClickStop := false
            return
        }

        Sleep(10)

        MouseClick(,,, 10)
    }
}

stopClick() {
    global isClickStop := true
}