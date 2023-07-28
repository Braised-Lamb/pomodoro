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

    //property var pomodoroTime:25
    //property var restTime:5

    signal clockdialogClosed(int result)
    // 创建全局单例对象
    GlobalSettings{id:settings}

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
        allTime: settings.duration*60 // 设置倒计时总时间，单位为秒
        totalTime:settings.pomodoro*60
        width:parent.width*2/3
        height:parent.height*5/6
        offset:Math.abs((height-width)/2)

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
            countDownTimer.resetCount();
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
            settings.duration=result;
            countDownTimer.initPomo();
        }
    }

    SettingDialog {
        id: settingDialog
        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
        width:parent.width*0.8
        height:parent.height*0.6
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
                text: settings.duration.toString() // Default value
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

            settings.duration=durationValue;
            settings.saveGlobalValues();
            // You can use these values as needed
            console.log("Duration:", settings.duration, "minutes");
            countDownTimer.initPomo();
        }
    }
}
