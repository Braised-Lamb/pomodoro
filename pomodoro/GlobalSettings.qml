// GlobalSettings.qml

import QtQuick 2.15
import Qt.labs.settings 1.0

Settings {
    id: globalSettings
    property int pomodoro: 25
    property int breakTime: 5
    property int duration: 60
    fileName: "app_settings.ini"
}
