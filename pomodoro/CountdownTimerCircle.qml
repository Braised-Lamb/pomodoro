// CountdownTimerCircle.qml

import QtQuick 2.9
import QtQuick.Controls 2.4

Item {

    visible: true
    width: 200
    height:200

    property int totalTime: 60 // 倒计时的总时间，单位为秒
    property int remainingTime: totalTime
    property real progress: 1 // 圆形进度条的进度，范围从0到1

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
        onPaint: {
            var ctx = getContext("2d");
            var centerX = width / 2;
            var centerY = height / 2;
            var radius = Math.min(centerX, centerY) - 5;
            var startAngle = -Math.PI / 2; // 从12点方向开始
            var endAngle = Math.PI * 2 * progress + startAngle;

            // 绘制灰色背景圆
            ctx.strokeStyle = "#C0C0C0";
            ctx.lineWidth = 10;
            ctx.beginPath();
            ctx.arc(centerX, centerY, radius, 0, Math.PI * 2);
            ctx.stroke();

            // 绘制进度条
            ctx.strokeStyle = "#007ACC";
            ctx.beginPath();
            ctx.arc(centerX, centerY, radius, startAngle, endAngle);
            ctx.stroke();
        }
    }

    Text {
        anchors.centerIn: parent
        font.pixelSize: 24
        text: remainingTime.toString()
    }

    Button {
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 50
        }
        text: countdownTimer.running ? "停止" : "开始"
        onClicked: {
            countdownTimer.running = !countdownTimer.running;
        }
    }
}