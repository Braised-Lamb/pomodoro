import QtQuick 2.3
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11


Dialog {
	id: settingDialog

    standardButtons: Dialog.Ok | Dialog.Cancel
    //modality: Qt.ApplicationModal
    //width: 400

    // 导入GlobalSettings组件
    GlobalSettings {
        id: settings
    }

    GridLayout{
        anchors.fill:parent
        columns:2
        width:parent.width
        anchors.centerIn:parent

        Label {
            text: "Promodoro (minutes):"
        }

        TextField {
            id: workTimeInput
            //width: 100
            Layout.fillWidth: true
            validator: IntValidator { bottom: 0 }
            text: settings.pomodoro.toString() // Default value
        }

        Label {
            text: "Break (minutes):"
        }

        TextField {
            id: restTimeInput
            Layout.fillWidth: true
            //anchors.horizontalCenter:workTimeInput.horizontalCenter
            //width: 100
            validator: IntValidator { bottom: 0 }
            text: settings.breakTime.toString() // Default value
        }
    }

    onAccepted: {
        // When the dialog is accepted (OK button clicked),
        // you can access the values entered by the user
        var workTimeValue = parseInt(workTimeInput.text);
        var restTimeValue = parseInt(restTimeInput.text);

        settings.pomodoro=workTimeValue;
        settings.breakTime=restTimeValue;

        // You can use these values as needed
        console.log("Work Time:", workTimeValue, "minutes");
        console.log("Rest Time:", restTimeValue, "minutes");
    }
}