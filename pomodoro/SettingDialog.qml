import QtQuick 2.3
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11


Dialog {
	id: settingDialog

    standardButtons: Dialog.Ok | Dialog.Cancel
    //modality: Qt.ApplicationModal
    //width: 400
    property int pomodoroSet:25
    property int breakTimeSet:5
    property int pointSize:14

    GridLayout{
        anchors.fill:parent
        columns:2
        width:parent.width
        anchors.centerIn:parent

        Label {
            text: "Promodoro (mins):"
            
            font.pointSize:pointSize
        }

        TextField {
            id: workTimeInput
            //width: 100
            Layout.fillWidth: true
            validator: IntValidator { bottom: 0 }
            text: pomodoroSet.toString() // Default value
            
            font.pointSize:pointSize
            selectByMouse: true
        }

        Label {
            text: "Break (mins):"
            
            font.pointSize:pointSize
        }

        TextField {
            id: restTimeInput
            Layout.fillWidth: true
            //anchors.horizontalCenter:workTimeInput.horizontalCenter
            //width: 100
            validator: IntValidator { bottom: 0 }
            text: breakTimeSet.toString() // Default value
            
            font.pointSize:pointSize
            selectByMouse: true
        }
    }
    signal sendPomodoro(int pomodoroValue)
    signal sendBreakTime(int breakTimeValue)
    onAccepted: {
            // When the dialog is accepted (OK button clicked),
            // you can access the values entered by the user
            var workTimeValue = parseInt(workTimeInput.text);
            var restTimeValue = parseInt(restTimeInput.text);

            // You can use these values as needed
            console.log("Work Time:", workTimeValue, "minutes");
            console.log("Rest Time:", restTimeValue, "minutes");
            
            emit: sendPomodoro(workTimeValue);
            emit: sendBreakTime(restTimeValue);
        }
}