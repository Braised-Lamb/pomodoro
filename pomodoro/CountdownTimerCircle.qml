// CountdownTimerCircle.qml

import QtQuick 2.9
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.11

Item {

    visible: true
    //width: 200
    //height:250
    property int offset:25

    property int totalTime: 60 // 倒计时的总时间，单位为秒
    property int remainingTime: totalTime
    property real progress: 1 // 圆形进度条的进度，范围从0到1
    // 全局透明度属性
    property real globalOpacity: 0.6

    Timer {
        id: countdownTimer
        interval: 1000 // 每秒触发一次计时器
        running: false
        repeat: true
        onTriggered: {
            remainingTime--;
            progress = remainingTime / totalTime;
            if (remainingTime <= 0) {
                countdownTimer.stop();
            }
            canvas.requestPaint();
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true // 开启抗锯齿
        onPaint: {
            var ctx = getContext("2d");
            var centerX = width / 2;
            var centerY = height / 2 - offset;
            var radius = Math.min(centerX, centerY) - 5;
            var startAngle = -Math.PI / 2; // 从12点方向开始
            var endAngle = Math.PI * 2 * progress + startAngle;
            
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
            ctx.fillStyle = "#007ACC";
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
        font.pixelSize: 24
        text: formatNumber(parseInt(remainingTime/60)).toString()+":"+formatNumber(parseInt(remainingTime%60)).toString()
    }

    Button {
        id: countButton
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 5
        }
        text: countdownTimer.running ? "停止" : "开始"
        onClicked: {
            countdownTimer.running = !countdownTimer.running;
        }
    }

    function reset(){
        remainingTime=totalTime;
        countdownTimer.running=false;
    }
}