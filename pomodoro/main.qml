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

    Component.onCompleted: {
        // ������ʽ����Ϊ Material
        Qt.application.setStyle("Material");

        // ���� Material ��������Ϊ Dark
        Material.theme = Material.Dark;

        // ����ǿ��ɫΪ��ɫ
        Material.accent = "red";
    }

        RowLayout{
        id: setButtonLayout
        //anchors.centerIn: parent
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        

        Layout.fillWidth: true // Take all available space

        Button {
            id: setEndTime
            text: "End Time"
            //onClicked: alarmDialog.open()
        }   

        Button {
            id: setDuration
            text: "Duration"
            //onClicked: alarmDialog.open()
        }
    }

    CountdownTimerCircle {
        //anchors.centerIn:parent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: setButtonLayout.bottom // ��CountdownTimerCircle����RowLayout�·�
        anchors.topMargin: 5
        totalTime: 60 // ���õ���ʱ��ʱ�䣬��λΪ��
    }


}
