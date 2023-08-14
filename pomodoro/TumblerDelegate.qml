/*
 * @Author: Braised-Lamb lambsjtu@outlook.com
 * @Email: ygaolamb@gmail.com
 * @Github: https://github.com/Braised-Lamb
 * @Blog: https://braised-lamb.github.io/
 * @Date: 2023-07-27 18:12:32
 * @LastEditors: Braised-Lamb
 * @LastEditTime: 2023-08-14 17:15:42
 * @FilePath: \pomodoro\pomodoro\TumblerDelegate.qml
 * @Description: 
 * 
 * Copyright (c) 2023 by Braised-Lamb, All Rights Reserved. 
 */

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4

Text {
    text: modelData
    color: Tumbler.tumbler.Material.foreground
    font: Tumbler.tumbler.font
    opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
