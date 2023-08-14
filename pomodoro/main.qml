/*
 * @Author: Braised-Lamb lambsjtu@outlook.com
 * @Email: ygaolamb@gmail.com
 * @Github: https://github.com/Braised-Lamb
 * @Blog: https://braised-lamb.github.io/
 * @Date: 2023-07-27 18:12:32
 * @LastEditors: Braised-Lamb
 * @LastEditTime: 2023-08-14 17:15:12
 * @FilePath: \pomodoro\pomodoro\main.qml
 * @Description: main window
 * 
 * Copyright (c) 2023 by Braised-Lamb, All Rights Reserved. 
 */

import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4
import QtQuick.Layouts 1.11
import Qt.labs.settings 1.0
import QtMultimedia 5.10

Window {
    id:root
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
        property var circleColor:"#007ACC"
        property real circleOpacity: 0.6
        property real clockVolumn: 1
        fileName: "app_settings.ini"
    }

    // FontMetrics object to access font metrics
    Item {
        id: fontMetrics
        property int pointSize: 18 // Initial font size, adjust as needed
    }
    // Function to update font size based on window size

    function updateFontSize() {
        // Calculate the desired font size based on window width and height
        var desiredFontSize = Math.min(width / 17, height / 17);
        fontMetrics.pointSize = desiredFontSize;
        console.log(width,height,"basic font size:",fontMetrics.pointSize);
    }

    // Call the updateFontSize function when the window is resized
    onWidthChanged: updateFontSize()
    onHeightChanged: updateFontSize()

    property var currentTime: ""

    //property var pomodoroTime:25
    //property var restTime:5

    signal clockdialogClosed(int result)

    Drawer {
        id: settingsDrawer
        width: colorSet.width
        opacity:0.75
        spacing:0
        Column {
            //width: 100
            //height: 300
            //color: "lightblue"

            // Content of the settings page
            Button {
                id:colorSet
                text: "Circle Color"
                onClicked: {
                    colorWin.open(); // Open the settings window
                    settingsDrawer.close(); // Close the drawer after opening settings
                }
            }
            /*
            // Content of the settings page
            Button {
                id:toneSet
                width:colorSet.width
                text: "Alarm Tone"
                onClicked: {
                    settingsWindow.open(); // Open the settings window
                    settingsDrawer.close(); // Close the drawer after opening settings
                }
            }
            */
            Button {
                id: settingDia
                width:colorSet.width
                text: "Time setting"
                onClicked: {
                    settingDialog.open();
                    settingsDrawer.close();
                }
            }
            // Content of the settings page
            Button {
                id:showAbout
                width:colorSet.width
                text: "About"
                onClicked: {
                    aboutWin.open(); // Open the settings window
                    settingsDrawer.close(); // Close the drawer after opening settings
                }
            }
        }
    }

    Dialog{
        id:aboutWin
        anchors.centerIn:parent
        width:parent.width*0.8
        height:parent.height*0.6
        ColumnLayout{
            anchors.centerIn:parent
            Layout.fillWidth:true
            width:parent.width
            spacing:fontMetrics.pointSize*0.4
            TextInput {
                text:"A simple Pomodoro application"
                    
                font.pixelSize: fontMetrics.pointSize*0.8 // 设置字体大小
                font.family: "Roboto" // 设置字体为Roboto
                font.bold: true
                color: "pink"
                wrapMode: Text.WordWrap
                width: aboutWin.width*0.8
                Layout.fillWidth:true
                
                readOnly: true
                selectByMouse: true
                Layout.alignment:Qt.AlignLeft
            }
            
            TextInput {
                text:"Github: https://github.com/Braised-Lamb/pomodoro"
                    
                font.pixelSize: fontMetrics.pointSize*0.8 // 设置字体大小
                font.family: "Roboto" // 设置字体为Roboto
                font.bold: true
                color: "pink"
                wrapMode: Text.WordWrap
                width: aboutWin.width*0.8
                Layout.fillWidth:true
                
                readOnly: true
                selectByMouse: true
                Layout.alignment:Qt.AlignLeft
            }
            TextInput {
                text:"Blog: https://braised-lamb.github.io/"
                    
                font.pixelSize: fontMetrics.pointSize*0.8 // 设置字体大小
                font.family: "Roboto" // 设置字体为Roboto
                font.bold: true
                color: "pink"
                wrapMode: Text.WordWrap
                width: aboutWin.width*0.8
                Layout.fillWidth:true
                
                readOnly: true
                selectByMouse: true
                Layout.alignment:Qt.AlignLeft
            }
            TextInput {
                text:"@ 2023 Braised-Lamb"
                    
                font.pixelSize: fontMetrics.pointSize*0.8 // 设置字体大小
                font.family: "Roboto" // 设置字体为Roboto
                font.bold: true
                color: "pink"
                wrapMode: Text.WordWrap
                width: aboutWin.width*0.8
                Layout.fillWidth:true
                
                readOnly: true
                selectByMouse: true
                Layout.alignment:Qt.AlignLeft
            }
        }
    }

    ColorPalette {
        id: colorWin
        anchors{
            centerIn:parent
        }
        width:0.95*parent.width
        height:0.95*parent.height
        pointSize: fontMetrics.pointSize*0.5
        defaultVal:globalSettings.circleColor

        onAccepted:{
            colorWin.defaultVal=colorWin.hexVal;
            globalSettings.circleColor=colorWin.hexVal;
            globalSettings.circleOpacity=colorWin.opa;
            globalSettings.sync();
            colorWin.initTextWheel(globalSettings.circleColor);
            countDownTimer.initPomo();
        }
    }

    Rectangle {
        id: drawerButton
        anchors.left:root.left
        anchors.leftMargin:0
        anchors.topMargin:10
        //Layout.alignment: Qt.AlignLeft|Qt.AlignVCenter
        width: 25
        height: 25
        color: "transparent" // Set the background color of the button to transparent
        //radius: 8 // Optional: Add rounded corners for a nicer look

        // Button content
        Image {
            width: drawerButton.width
            height: drawerButton.height
            anchors.centerIn: drawerButton
            mipmap:true
            fillMode:Image.PreserveAspectCrop
            source: "imgs/drawer_icon.png"
            opacity:0.7
        }

        // Property to handle play/pause state
        //property bool isPlaying: false

        // Toggle play/pause state on button click
        MouseArea {
            anchors.fill: parent
            onClicked: {
                settingsDrawer.open();
            }
        }
    }


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
        offset:25
        globalPomodoro:globalSettings.pomodoro
        globalBreakTime:globalSettings.breakTime
        globalDuration:globalSettings.duration
        pointSize: fontMetrics.pointSize
        globalOpacity:globalSettings.circleOpacity
        circleColor:globalSettings.circleColor

        Component.onCompleted: {
            countDownTimer.initPomo();
        }

        onPlayPomodoro:{
            setEndTime.enabled=false;
            setDuration.enabled=false;
            settingsDrawer.enabled=false;
        }

        onPausePomodoro:{
            setEndTime.enabled=false;
            setDuration.enabled=false;
            settingsDrawer.enabled=false;
        }

        onStopPomodoro:{
            setEndTime.enabled=true;
            setDuration.enabled=true;
            settingsDrawer.enabled=true;
            countDownTimer.initPomo();
        }
        
        onFinishPomodoro:{
            setEndTime.enabled=true;
            setDuration.enabled=true;
            settingsDrawer.enabled=true;
            countDownTimer.initPomo();
            finishSound.play();
            finishedDia.open();
            root.flags = Qt.Window | Qt.WindowStaysOnTopHint | Qt.CustomizeWindowHint | Qt.WindowTitleHint
            showWinTimer.start();
        }
        
        onStartBreakPomodoro:{
            noticeSound.play();
            root.flags = Qt.Window | Qt.WindowStaysOnTopHint | Qt.CustomizeWindowHint | Qt.WindowTitleHint
            showWinTimer.start();
        }

        onStartFocusPomodoro:{
            relaxSound.play();
            root.flags = Qt.Window | Qt.WindowStaysOnTopHint | Qt.CustomizeWindowHint | Qt.WindowTitleHint
            showWinTimer.start();
        }

        //signal startBreakPomodoro();
        //signal startFocusPomodoro();
    }

    Timer {
        id: showWinTimer
        
        interval: 100 // 每秒触发一次计时器
        running: false
        repeat: false
        onTriggered: {
            root.flags = Qt.Window;
        }
    }

    MediaPlayer {
        id:finishSound
        source:"qrc:/audios/finish.mp3"
    }
    MediaPlayer {
        id:relaxSound
        source:"qrc:/audios/relax.mp3"
    }
    MediaPlayer {
        id:noticeSound
        source:"qrc:/audios/notice.mp3"
    }

    Dialog{
        id: finishedDia
        standardButtons: Dialog.Ok
        anchors.centerIn:parent
        Text{
            anchors.centerIn:parent
            text:"Finished All Pomodoros"
            
            font.pixelSize: fontMetrics.pointSize // 设置字体大小
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
        pointSize: fontMetrics.pointSize
        onClockdialogClosed: {
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
        width:parent.width*0.9
        height:parent.height*0.8
        pomodoroSet:globalSettings.pomodoro
        breakTimeSet:globalSettings.breakTime
        pointSize: fontMetrics.pointSize*0.65
        mVolumn:globalSettings.clockVolumn
        
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
        onValueChanged:{
            globalSettings.clockVolumn=clockVolumn;
            globalSettings.sync();
            noticeSound.volume=globalSettings.clockVolumn;
            relaxSound.volume=globalSettings.clockVolumn;
            finishSound.volume=globalSettings.clockVolumn;
        }
        onVolumnPreview:{
            previewSound.volume=clockVolumn;
            previewSound.play();
        }
        MediaPlayer {
            id:previewSound
            source:"qrc:/audios/notice.mp3"
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
                font.pointSize:fontMetrics.pointSize
                selectByMouse: true
            }

            Label {
                //anchors.bottom:durationInput.bottom
                text:"mins"
                font.pointSize:fontMetrics.pointSize
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
