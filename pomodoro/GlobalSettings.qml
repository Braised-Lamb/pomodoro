// GlobalSettings.qml
import QtQuick 2.3
import QtQuick.LocalStorage 2.0

QtObject {
    property int pomodoro: 25
    property int breakTime: 5
    property int duration: 120

    // 当全局变量值发生变化时，保存到LocalStorage
    function saveGlobalValues() {
        var db = LocalStorage.openDatabaseSync("myAppDb", "1.0", "Settings database", 1000000);
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(key TEXT, value TEXT)');
            tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?, ?)', ["pomodoro", pomodoro.toString()]);
            tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?, ?)', ["breakTime", breakTime.toString()]);
            tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?, ?)', ["duration", duration.toString()]);
        });
    }

    // 在应用程序启动时，从LocalStorage中加载全局变量值
    function loadGlobalValues() {
        var db = LocalStorage.openDatabaseSync("myAppDb", "1.0", "Settings database", 1000000);
        db.transaction(function(tx) {
            var rs1 = tx.executeSql('SELECT value FROM settings WHERE key = ?', ["pomodoro"]);
            if (rs1.rows.length > 0) {
                pomodoro = parseInt(rs1.rows.item(0).value);
            }

            var rs2 = tx.executeSql('SELECT value FROM settings WHERE key = ?', ["breakTime"]);
            if (rs2.rows.length > 0) {
                breakTime = parseInt(rs2.rows.item(0).value);
            }

            var rs3 = tx.executeSql('SELECT value FROM settings WHERE key = ?', ["duration"]);
            if (rs3.rows.length > 0) {
                duration = parseInt(rs3.rows.item(0).value);
            }
        });
    }

    // 调用应用程序启动时加载全局变量的函数
    Component.onCompleted: {
        loadGlobalValues();
    }

    // 保存全局变量的值到LocalStorage（使用property bindings）
    onPomodoroChanged: {
        saveGlobalValues();
        console.log("global",settings.duration,settings.pomodoro,settings.breakTime);
    }

    onBreakTimeChanged: {
        saveGlobalValues();
        console.log("global",settings.duration,settings.pomodoro,settings.breakTime);
    }

    onDurationChanged: {
        saveGlobalValues();
        console.log("global",settings.duration,settings.pomodoro,settings.breakTime);
    }
}
