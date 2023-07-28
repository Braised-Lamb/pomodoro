import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4
import QtQuick.Layouts 1.11
import Qt.labs.settings 1.0

Window {
    visible: true
    width: 300
    height: 300
    title: qsTr("pomodoro")
    color: Qt.rgba(0.5,0.5,0.5,0.5)

    Settings {
        id: globalSettings
        property int pomodoro: 25
        property int breakTime: 5
        property int duration: 60
        fileName: "app_settings.ini"
    }

    property var currentTime: ""

    //property var pomodoroTime:25
    //property var restTime:5

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
                clockDialog.open();
            }
        }   

        Button {
            id: setDuration
            text: "Duration"
            onClicked: {
                //settingDialog.open()
                durationDialog.open()
            }
        }

        Button {
            id: settingDia
            text: "setting"
            onClicked: {
                settingDialog.open()
            }
        }
    }

    CountdownTimerCircle {
        id: countDownTimer
        //anchors.centerIn:parent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: setButtonLayout.bottom // 把CountdownTimerCircle放在RowLayout下方
        anchors.topMargin: 5
        allTime: globalSettings.duration*60 // 设置倒计时总时间，单位为秒
        totalTime:globalSettings.pomodoro*60
        width:parent.width*2/3
        height:parent.height*5/6
        offset:Math.abs((height-width)/2)
        globalPomodoro:globalSettings.pomodoro
        globalBreakTime:globalSettings.breakTime
        globalDuration:globalSettings.duration

        onPlayPomodoro:{
            setEndTime.enabled=false;
            setDuration.enabled=false;
            settingDia.enabled=false;
        }

        onPausePomodoro:{
            setEndTime.enabled=false;
            setDuration.enabled=false;
            settingDia.enabled=false;
        }

        onStopPomodoro:{
            setEndTime.enabled=true;
            setDuration.enabled=true;
            settingDia.enabled=true;
            countDownTimer.initPomo();
        }
        
        onFinishPomodoro:{
            setEndTime.enabled=true;
            setDuration.enabled=true;
            settingDia.enabled=true;
            countDownTimer.initPomo();
            finishedDia.open();
        }
    }
    Dialog{
        id: finishedDia
        standardButtons: Dialog.Ok
        Text{
            anchors.centerIn:parent
            text:"Finished All Pomodoro"
            
            font.pixelSize: 18 // 设置字体大小
            font.family: "Courier" // 设置字体为Roboto
            font.bold: true
            color: "pink"
        }
    }
    ClockDialog {
        id: clockDialog
        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
        startTime: currentTime
        width:parent.width*0.8
        height:parent.height*0.95
        onAccepted: {
            console.log("Dialog closed with result:", result);
            // 这里可以根据 result 的值执行相应的操作
            var currentTime = new Date();
            globalSettings.duration=result;
            globalSettings.sync();
            countDownTimer.globalDuration=globalSettings.duration;
            countDownTimer.initPomo();
        }
    }

    SettingDialog {
        id: settingDialog
        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
        width:parent.width*0.8
        height:parent.height*0.6
        pomodoroSet:globalSettings.pomodoro
        breakTimeSet:globalSettings.breakTime
        
        onSendPomodoro:{
            globalSettings.pomodoro=pomodoroValue;
            countDownTimer.globalPomodoro=pomodoroValue;
            globalSettings.sync();
            countDownTimer.initPomo();
        }
        onSendBreakTime:{
            globalSettings.breakTime=breakTimeValue
            countDownTimer.globalBreakTime=breakTimeValue;
            globalSettings.sync();
            countDownTimer.initPomo();
        }
    }

    Dialog {
        id: durationDialog
        title: "Duration"
        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
        width:parent.width*0.6
        height:parent.height*0.6
        standardButtons: Dialog.Ok | Dialog.Cancel

        RowLayout{
            anchors.fill:parent
            //columns:2
            width:parent.width
            anchors.centerIn:parent
            
            TextField {
                id: durationInput
                //width: 100
                Layout.fillWidth: true
                validator: IntValidator { bottom: 0 }
                text: globalSettings.duration.toString() // Default value
            }

            Label {
                //anchors.bottom:durationInput.bottom
                text:"mins"
            }

        }
        onAccepted: {
            // When the dialog is accepted (OK button clicked),
            // you can access the values entered by the user
            var durationValue = parseInt(durationInput.text);

            globalSettings.duration=durationValue;
            // You can use these values as needed
            console.log("Duration:", globalSettings.duration, "minutes");
            globalSettings.sync();
            countDownTimer.globalDuration=globalSettings.duration;
            countDownTimer.initPomo();
        }
    }
}
