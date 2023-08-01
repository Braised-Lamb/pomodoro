/*
 * @Author: Braised-Lamb
 * @Email: ygaolamb@gmail.com
 * @Github: https://github.com/Braised-Lamb
 * @Blog: https://braisedlamb.github.io/
 * @Date: 2023-08-01 16:53:59
 * @Last Modified by: Braised-Lamb
 * @Last Modified time: 2023-08-01 16:53:59
 * @Description: CountdownTimerCircle.qml
*/

import QtQuick 2.9
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.11


Item {

    visible: true
    //width: 200
    //height:250

    property int timeInterval:1000 // 计时器间隔，提示用
    property int offset:25

    property int allTime: 60
    property int totalTime: 25 // 倒计时的总时间，单位为秒
    property int remainingTime: totalTime
    property real progress: 1 // 圆形进度条的进度，范围从0到1
    // 全局透明度属性
    property real globalOpacity: 0.6
    property var circleColor: "#007ACC"

    property int pomodoroNum: 1
    property bool focusStatus: true
    property int curPomo:pomodoroNum

    //property int restTime:0
    property int correct:0
    property int lastcorrect:0
    property int circleRadius:0

    signal finishPomodoro()
    signal playPomodoro()
    signal pausePomodoro()
    signal stopPomodoro()


    property int pointSize:16

    // 全局变量
    property int globalPomodoro:25
    property int globalBreakTime:5
    property int globalDuration:60

    Timer {
        id: countdownTimer
        interval: timeInterval // 每秒触发一次计时器
        running: false
        repeat: true
        onTriggered: {
            remainingTime--;
            if (remainingTime <= 0) {
                countdownTimer.stop();
                if (focusStatus) {
                    curPomo-=1;
                    if (curPomo>0){
                        totalTime=(globalBreakTime+correct)*60;
                        progress=1;
                        remainingTime=totalTime;
                        emit: startBreakPomodoro();
                        countdownTimer.start();
                    }
                    else {
                        emit: finishPomodoro();
                        countdownTimer.running=false;
                    }
                }
                else {
                    totalTime=(globalPomodoro+correct+(curPomo>0?0:lastcorrect))*60;
                    progress=1;
                    remainingTime=totalTime;
                    emit: startFocusPomodoro();
                    countdownTimer.start();
                }
                focusStatus=!focusStatus;
            }
            progress = remainingTime / totalTime;
            canvas.requestPaint();
        }
    }
    signal startBreakPomodoro();
    signal startFocusPomodoro();

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true // 开启抗锯齿
        onPaint: {
            var ctx = getContext("2d");
            var centerX = width / 2;
            var centerY = height / 2 - offset;
            var radius = Math.min(centerX, centerY) - 10;
            var startAngle = -Math.PI / 2; // 从12点方向开始
            var endAngle = Math.PI * 2 * progress + startAngle;
            
            circleRadius=radius

            ctx.clearRect(0, 0, width, height);
            ctx.globalAlpha = globalOpacity;
            // 绘制灰色背景圆
            //ctx.strokeStyle = Material.background;
            //ctx.lineWidth = 10;
            ctx.beginPath();
            //ctx.moveTo(centerX, centerY);
            ctx.arc(centerX, centerY, radius, 0, Math.PI * 2);
            //ctx.stroke();
            // 填充扇形，以红色填充
            ctx.fillStyle = "#C0C0C0"; 
            ctx.fill();

            // 绘制进度条
            //ctx.strokeStyle = Material.accent;
            ctx.beginPath();
            ctx.moveTo(centerX, centerY);
            ctx.arc(centerX, centerY, radius, startAngle, endAngle);
            ctx.lineTo(centerX, centerY);
            ctx.closePath();
            //ctx.stroke();
            // 填充扇形，以红色填充
            ctx.fillStyle = circleColor;
            //ctx.fillStyle = "rgb(0.5,0.5,0.5,0.5)";
            ctx.fill();

        }
    }
    function formatNumber(number) {
        return number < 10 && number >= 0 ? "0" + number : number.toString()
    }
    Text {
        // 将锚点设置为(0.5, 0.5)以使中心点居中
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -offset
        font.pixelSize: pointSize*3
        font.family: "Roboto" // 设置字体为Roboto
        font.bold: true
        color: "#404040"
        text: formatNumber(parseInt(remainingTime/60)).toString()+":"+formatNumber(parseInt(remainingTime%60)).toString()
    }

    Rectangle {
        id: countButton
        anchors{
            centerIn: parent
            verticalCenterOffset: circleRadius-offset/2+5
        }
        width: 20
        height: 20
        color: "transparent" // Set the background color of the button to transparent
        //radius: 8 // Optional: Add rounded corners for a nicer look

        // Button content
        Image {
            width: Math.min(countButton.width, countButton.height)
            height: Math.min(countButton.width, countButton.height)
            anchors.centerIn: countButton
            mipmap:true
            source: countdownTimer.running ? "imgs/pause_icon.png" : "imgs/play_icon.png"
        }

        // Property to handle play/pause state
        //property bool isPlaying: false

        // Toggle play/pause state on button click
        MouseArea {
            anchors.fill: parent
            onClicked: {
                countdownTimer.running = !countdownTimer.running;
                if (countdownTimer.running) emit: playPomodoro();
                else emit: pausePomodoro();
                stopButton.visible=true;
                countButton.anchors.horizontalCenterOffset=-15;
            }
        }
    }

    Rectangle {
        id: stopButton
        anchors{
            centerIn: parent
            verticalCenterOffset: circleRadius-offset/2+5
            horizontalCenterOffset: 15
        }
        width: 20
        height: 20
        visible: false
        color: "transparent" // Set the background color of the button to transparent
        //radius: 8 // Optional: Add rounded corners for a nicer look

        // Button content
        Image {
            width: Math.min(countButton.width, countButton.height)
            height: Math.min(countButton.width, countButton.height)
            anchors.centerIn: countButton
            mipmap:true
            source: "imgs/stop_icon.png"
        }

        // Property to handle play/pause state
        //property bool isPlaying: false

        // Toggle play/pause state on button click
        MouseArea {
            anchors.fill: parent
            onClicked: {
                emit: stopPomodoro();
                stopButton.visible=false;
                countButton.anchors.horizontalCenterOffset=0;
            }
        }
    }

    Text {
        id:statusText
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: countButton.bottom
            bottomMargin: 10
        }
        text:(2*(pomodoroNum-curPomo)+(focusStatus?1:0)).toString()+"/"+(pomodoroNum+pomodoroNum-1).toString()+"\tNow:"+(focusStatus?"Focus":"Break")

        font.pixelSize: pointSize // 设置字体大小
        font.family: "Courier" // 设置字体为Roboto
        font.bold: true
        color: "#404040"
         
    }

    onFinishPomodoro:{
        stopButton.visible=false;
        countButton.anchors.horizontalCenterOffset=0;
    }

    function initPomo(){
        console.log(globalPomodoro,globalDuration,correct);
        if (globalPomodoro>globalDuration){
            pomodoroNum=1; 
            correct=0;
            lastcorrect=0;
            totalTime=(globalDuration+correct)*60;
        }
        else {
            var cycle=(globalPomodoro+globalBreakTime)*60;
            var restTime = allTime%cycle/60;
            pomodoroNum = allTime/cycle;
            if (restTime <= globalPomodoro) {
                pomodoroNum+=1;
            }
            else {
                correct=restTime/pomodoroNum;
                lastcorrect=restTime%pomodoroNum;
            }
            totalTime=(globalPomodoro+correct)*60;
        }
        focusStatus=true;
        remainingTime=totalTime;
        progress=1;
        curPomo=pomodoroNum;
        countdownTimer.stop();
        countdownTimer.interval=timeInterval;
        canvas.requestPaint();
        console.log("painting",totalTime);
        console.log(globalPomodoro,globalDuration,correct);
    }

    function resetCount(){  
        totalTime=globalPomodoro*60;
        remainingTime=totalTime;
        pomodoroNum=1;
        progress=1;
        curPomo=pomodoroNum;
        countdownTimer.stop();
        countdownTimer.interval=timeInterval;
        canvas.requestPaint();
        console.log("reset");
    }
}
