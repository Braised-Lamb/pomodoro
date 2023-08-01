/*
 * @Author: Braised-Lamb
 * @Email: ygaolamb@gmail.com
 * @Github: https://github.com/Braised-Lamb
 * @Blog: https://braisedlamb.github.io/
 * @Date: 2023-08-01 16:54:58
 * @Last Modified by: Braised-Lamb
 * @Last Modified time: 2023-08-01 16:54:58
 * @Description: 
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
