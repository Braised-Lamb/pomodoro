import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4
import QtQuick.Layouts 1.11

Window {
    visible: true
    width: 300
    height: 300
    title: qsTr("pomodoro")
    color: Qt.rgba(0.5,0.5,0.5,0.5)

    property var currentTime: ""
    property var countTime: 25*60

    property var pomodoroTime:25
    property var restTime:5

    signal clockdialogClosed(int result)
    RowLayout{
        id: setButtonLayout
        //anchors.centerIn: parent
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        

        //Layout.fillWidth: true // Take all available space

        Button {
            id: setEndTime
            text: "End Time"
            onClicked: {
                currentTime=new Date();
                var result = clockDialog.open();
            }
        }   

        Button {
            id: setDuration
            text: "Duration"
            //onClicked: alarmDialog.open()
        }
    }

    CountdownTimerCircle {
        id: countDownTimer
        //anchors.centerIn:parent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: setButtonLayout.bottom // 把CountdownTimerCircle放在RowLayout下方
        anchors.topMargin: 5
        totalTime: pomodoroTime*60 // 设置倒计时总时间，单位为秒
        width:parent.width*2/3
        height:parent.height*5/6
        offset:Math.abs((height-width)/2)
    }

    ClockDialog {
        id: clockDialog
        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
        startTime: currentTime
        width:parent.width*0.8
        height:parent.height*0.95
        onClockdialogClosed: {
            console.log("Dialog closed with result:", result);
            // 这里可以根据 result 的值执行相应的操作
            var currentTime = new Date();
            countDownTimer.totalTime=(result-parseInt(currentTime.getHours())*60-parseInt(currentTime.getMinutes()))*60;
            countDownTimer.reset;
        }
    }
}
