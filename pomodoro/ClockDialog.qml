//clockDialog.qml

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import QtQuick.Window 2.11

Dialog {
    id: clockDialog
    title: "Set End Time"
    // Custom title item
    modal: true
    standardButtons: DialogButtonBox.Ok | DialogButtonBox.Cancel
    property var startTime: new Date();
    property var endTime: 0;
    property int pointSize: 14

    function formatNumber(number) {
        return number < 10 && number >= 0 ? "0" + number : number.toString()
    }

    onVisibleChanged: {
        if (clockDialog.visible==true){
            startTime=new Date();
            hourText.text=formatNumber(startTime.getHours());
            minuteText.text=formatNumber(startTime.getMinutes());
        }

    }
    onAccepted: {
        var endHour = parseInt(hourText.text);
        var endMinute = parseInt(minuteText.text);
        endTime = (endHour*60+endMinute);
        var sTime=parseInt(startTime.getHours())*60+parseInt(startTime.getMinutes())
        var durationTime=endTime-sTime;
        if (durationTime<=0) durationTime+=24*60
        emit:clockdialogClosed(durationTime);
    }
    onRejected: {
        //emit:clockdialogClosed(endTime);
    }

    signal clockdialogClosed(int result)

    Timer{
        id:indexTimer
        interval:200
        onTriggered:{
            hourText.text=formatNumber(parseInt(hoursTumbler.currentIndex));
            minuteText.text=formatNumber(parseInt(minutesTumbler.currentIndex));
            console.log("changing");
        }
    }

    Row {
        id: labelContainer
        anchors.horizontalCenter: parent.horizontalCenter
        //anchors.verticalCenter: parent.verticalCenter
        anchors{
            top:title.bottom
            horizontalCenter: parent.horizontalCenter
        }
        spacing:pointSize*2
        Text{
            width:hoursTumbler.width
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text:"Hour"
            font.bold: true
            font.pointSize: pointSize
            font.family: "Roboto"
            color: "pink"
            Layout.fillWidth: true
        }
        Text{
            width:minutesTumbler.width
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text:"Minute"
            font.bold: true
            font.pointSize: pointSize
            font.family: "Roboto"
            color: "pink"
            Layout.fillWidth: true
        }
    }

    Row {
        id: textContainer
        anchors.horizontalCenter: parent.horizontalCenter
        //anchors.verticalCenter: parent.verticalCenter
        anchors{
            top:labelContainer.bottom
            horizontalCenter: parent.horizontalCenter
        }
        spacing:pointSize*2
        TextField{
            id:hourText
            width:hoursTumbler.width
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: formatNumber(parseInt(startTime.getHours()))
            font.pointSize:pointSize
            selectByMouse: true
            validator: IntValidator { // 设置输入验证器，只允许输入整数
                bottom: 0
                top: 23
            }
            onTextChanged: {
                var hour = parseInt(hourText.text);
                if (hour >=0 && hour < 24){
                    hourText.text=formatNumber(parseInt(hourText.text));
                    hoursTumbler.currentIndex=parseInt(hourText.text);
                }
                else{
                    hourText.text=formatNumber(parseInt(startTime.getHours()));
                }

            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    hourText.text = "00" // 点击MouseArea时清空TextField内容
                    hourText.forceActiveFocus() // 使TextField获取焦点，让用户可以直接输入
                }
            }
        }
        TextField{
            id:minuteText
            width:minutesTumbler.width
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: formatNumber(parseInt(startTime.getMinutes()))
            font.pointSize:pointSize
            selectByMouse: true
            validator: IntValidator { // 设置输入验证器，只允许输入整数
                bottom: 0
                top: 59
            }
            onTextChanged: {
                var minute = parseInt(minuteText.text);
                if (minute >=0 && minute < 60){
                    minuteText.text=formatNumber(parseInt(minuteText.text));
                    minutesTumbler.currentIndex=parseInt(minuteText.text);
                }
                else{
                    minuteText.text=formatNumber(parseInt(startTime.getMinutes()));
                }

            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    minuteText.text = "00" // 点击MouseArea时清空TextField内容
                    minuteText.forceActiveFocus() // 使TextField获取焦点，让用户可以直接输入
                }
            }
        }
    }


    Rectangle{
        id:tumberContainer
        height:parent.height*0.6
        Layout.fillWidth: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top:textContainer.bottom

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing:pointSize*2

            Tumbler {
                id: hoursTumbler
                model: 24
                height: tumberContainer.height
                width:pointSize*3
                //visibleItemCount: 5
                currentIndex: parseInt(startTime.getHours())
                delegate: TumblerDelegate {
                    width: hoursTumbler.width / hoursTumbler.visibleItemCount
                    text: formatNumber(modelData)
                }
                font.pointSize:pointSize*0.8
                spacing:pointSize
                // 处理滚轮事件
               MouseArea {
                   anchors.fill: parent
                   onWheel: {
                       if (mouseX >= 0 && mouseX < parent.width) {
                           // 鼠标在第一个 Tumbler 列，控制第一个 Tumbler
                           handleWheelEvent(wheel, hoursTumbler);
                           hourText.text=formatNumber(hoursTumbler.currentIndex);
                       }
                   }
               }
               onCurrentIndexChanged: {
                    indexTimer.running = true;
               }
            }

            Tumbler {
                id: minutesTumbler
                model: 60
                height: tumberContainer.height
                width:pointSize*3
                //visibleItemCount: 5
                currentIndex: parseInt(startTime.getMinutes())
                delegate: TumblerDelegate {
                    width: minutesTumbler.width / minutesTumbler.visibleItemCount
                    text: formatNumber(modelData)
                }
                font.pointSize:pointSize*0.8
                spacing:pointSize
                // 处理滚轮事件
               MouseArea {
                   anchors.fill: parent
                   onWheel: {
                       if (mouseX >= 0 && mouseX < parent.width) {
                           // 鼠标在第一个 Tumbler 列，控制第一个 Tumbler
                           handleWheelEvent(wheel, minutesTumbler);
                           minuteText.text=formatNumber(minutesTumbler.currentIndex);
                       }
                   }
               }
               onCurrentIndexChanged: {
                    indexTimer.running = true;
                    console.log("running");
               }
            }
        }

    }


    function updateText(textField,tumbler){
        var curIndex = tumbler.currentIndex;
        textField.text = formatNumber(parseInt(curIndex));
    }

    // 处理滚轮事件，使滚轮和方向键单独调整
    function handleWheelEvent(event, tumbler) {
        var curIndex = tumbler.currentIndex;
        if (event.angleDelta.y > 0) {
            // 向上滚动
            curIndex--;
            if (curIndex < 0){
                curIndex = tumbler.count - 1;
            }
        } else if (event.angleDelta.y < 0) {
            // 向下滚动
            curIndex++;
            if (curIndex >= tumbler.count){
                curIndex = 0;
            }
        }
        tumbler.currentIndex= curIndex;
        //console.log(tumbler.currentIndex,tumbler.count);
    }

}
