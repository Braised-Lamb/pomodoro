import QtQuick 2.5
import QtQuick.Controls 2.5

Dialog {

/*
    Rectangle {
        anchors.fill: parent

        Canvas {
            anchors.fill: parent

            function drawColorWheel(cx, cy, radius) {
                var ctx = getContext("2d"); // Define ctx here

                for (var i = 0; i < 360; i++) {
                    var angle = i * Math.PI / 180;
                    var color = hslToRgb(i, 100, 50);

                    for (var i = 0; i < 360; i++) {
                        var angle = i * Math.PI / 180;
                        for (var j = 0; j < 100; j+=1){
                            var color = hslToRgb(i, j, 50);
                            ctx.fillStyle = color;
                            ctx.beginPath();
                            var x = cx + radius * Math.cos(angle) * j / 100;
                            var y = cy + radius * Math.sin(angle) * j / 100;
                            ctx.arc(x, y, 5, 0, Math.PI * 2);
                            ctx.fill();
                        }
                    }
                }
            }

            onPaint: {
                var centerX = width / 2;
                var centerY = height / 2;
                var radius = Math.min(width, height) / 2 - 10;
                drawColorWheel(centerX, centerY, radius);
            }
        }

    }
*/
    id:paletteDia
    property int pointSize:8
    property real opa:0.6
    standardButtons: Dialog.Ok | Dialog.Cancel

    property int rVal:0
    property int gVal:122
    property int bVal:204
    property var hexVal:"#007ACC"

    function padZero(hexColor) {
        // 补零函数：确保输入的十六进制颜色代码为六位
        while (hexColor.length < 7) {
            hexColor = hexColor+"0";
        }
        return hexColor;
    }

    function hexToRgb(hexColor) {
        // 去除可能包含的 # 号
        hexColor = hexColor.replace("#", "");

        // 将十六进制颜色代码分解为红、绿、蓝三个分量
        var red = parseInt(hexColor.substr(0, 2), 16);
        var green = parseInt(hexColor.substr(2, 2), 16);
        var blue = parseInt(hexColor.substr(4, 2), 16);
        console.log("rgb in hex",hexColor.substr(0, 2),hexColor.substr(2, 2),hexColor.substr(4, 2))
        // 返回包含三个值的数组
        return [red, green, blue];
    }

    function rgbToHex(r, g, b) {
        // 使用 JavaScript 的 toString(16) 方法将每个分量转换为十六进制字符串
        var hexr=("00" + parseInt(r).toString(16).toUpperCase()).slice(-2);
        var hexg=("00" + parseInt(g).toString(16).toUpperCase()).slice(-2);
        var hexb=("00" + parseInt(b).toString(16).toUpperCase()).slice(-2);

        return "#"+hexr+hexg+hexb;
    }
    Rectangle {
        id: paletteWheel
        anchors.left:paletteDia.left
        anchors.top:paletteDia.top
        width: parent.width*0.6
        height: parent.height*0.6
        color: "transparent" // Set the background color of the button to transparent
        //radius: 8 // Optional: Add rounded corners for a nicer look

        // Button content
        Image {
            id:wheelImg
            width: Math.min(paletteWheel.width,paletteWheel.height)
            height: Math.min(paletteWheel.width,paletteWheel.height)
            anchors.centerIn: paletteWheel
            mipmap:true
            //fillMode:Image.PreserveAspectCrop
            fillMode: Image.PreserveAspectFit
            source: "imgs/color_wheel.png"
            //opacity:0.7
        }

        Image {
            id: cursorPos
            // 设置锚点为 paletteWheel，保持相对位置不变
            //anchors.left: paletteWheel.left
            //anchors.top: paletteWheel.top
            source: "imgs/cursor_icon.png"
            width: 10
            height: 10
            visible: true
            mipmap:true
            property real hRatio:0
            property real wRatio:0
        }

        // Property to handle play/pause state
        //property bool isPlaying: false

        // Toggle play/pause state on button click
        MouseArea {
            anchors.fill: parent
            onClicked: {
                cursorPos.x = mouseX - cursorPos.width / 2;
                cursorPos.y = mouseY - cursorPos.height / 2;
                cursorPos.wRatio=(cursorPos.x-wheelImg.x)/wheelImg.width;
                cursorPos.hRatio=(cursorPos.y-wheelImg.y)/wheelImg.height;
            }
        }
        onWidthChanged:{
            cursorPos.x=wheelImg.x+cursorPos.wRatio*wheelImg.width;
            console.log(cursorPos.x);
        }
        onHeightChanged:{
            cursorPos.y=wheelImg.y+cursorPos.hRatio*wheelImg.height;
        }
    }

    Column {
        //spacing: 20
        anchors.top:paletteWheel.bottom
        anchors.horizontalCenter:paletteWheel.horizontalCenter
        // 亮度Slider
        Column {
            Slider {
                id: brightnessSlider
                from:0 // 最小值
                to: 100  // 最大值
                value: 50 // 默认值
                stepSize: 1 // 步进值
                width:paletteWheel.width
                onValueChanged: {
                    // 处理亮度变化
                    // brightnessSlider.value表示亮度的值
                    // 这里可以将亮度值应用到对应的元素
                    // 例如，如果你有一个元素叫做"brightnessElement"，可以使用下面的方式设置亮度：
                    // brightnessElement.brightness = brightnessSlider.value
                }
            }
        }

        // 透明度Slider
        Column {
            Label {
                id:opalabel
                text:"Opacity: " + opacitySlider.value.toFixed(2)
                font.pointSize:pointSize*0.8
            }

            Slider {
                id: opacitySlider
                from: 0.0 // 最小值
                to: 1.0 // 最大值
                value: opa // 默认值
                stepSize: 0.01 // 步进值
                width:paletteWheel.width

                onValueChanged: {
                    // 处理透明度变化
                    // opacitySlider.value表示透明度的值
                    // 这里可以将透明度值应用到对应的元素
                    // 例如，如果你有一个元素叫做"opacityElement"，可以使用下面的方式设置透明度：
                    // opacityElement.opacity = opacitySlider.value
                    //opacityLabel.text = "Opacity: " + opacitySlider.value.toFixed(2)
                    opa=opacitySlider.value.toFixed(2);
                }
            }
        }
    }

    Column {
        anchors.left:paletteWheel.right
        anchors.right:parent.right
        spacing:0
        Row{
            spacing:4
            Label{
                id:rlabel
                text:"R"
                width:hexlabel.width
                font.pointSize:pointSize
                anchors.verticalCenter: rInput.verticalCenter
            }
            TextField {
                id: rInput
                width: hexlabel.width*2
                //width: 100
                //Layout.fillWidth: true
                validator: IntValidator { 
                    bottom: 0 
                    top: 255
                }
                text: rVal // Default value
                baselineOffset: rlabel.baselineOffset  
                font.pointSize:pointSize
                selectByMouse: true
                onTextChanged:{
                    updateHex();
                }
            }
        }
        Row{
            spacing:4
            Label{
                id:glabel
                text:"G"
                width:hexlabel.width
                font.pointSize:pointSize
                anchors.verticalCenter: gInput.verticalCenter
            }
            TextField {
                id: gInput
                width: hexlabel.width*2
                //width: 100
                //Layout.fillWidth: true
                validator: IntValidator { 
                    bottom: 0 
                    top: 255
                }
                text: gVal // Default value
                baselineOffset: rlabel.baselineOffset
                font.pointSize:pointSize
                selectByMouse: true
                onTextChanged:{
                    updateHex();
                }
            }
        }
        Row{
            spacing:4
            Label{
                id: blabel
                text:"B"
                width:hexlabel.width
                font.pointSize:pointSize
                anchors.verticalCenter: bInput.verticalCenter
            }
            TextField {
                id: bInput
                width: hexlabel.width*2
                //width: 100
                //Layout.fillWidth: true
                // 使用 RegExpValidator 来验证输入的格式
                validator: IntValidator { 
                    bottom: 0 
                    top: 255
                }
                text: bVal // Default value
                baselineOffset: blabel.baselineOffset
                font.pointSize:pointSize
                selectByMouse: true
                onTextChanged:{
                    updateHex();
                }
            }
        }
        Row{
            spacing:4
            Label{
                id:hexlabel
                text:"HEX"
                font.pointSize:pointSize
                anchors.verticalCenter: hexInput.verticalCenter
            }
            TextField {
                id: hexInput
                width: hexlabel.width*3
                //Layout.fillWidth: true
                validator: RegExpValidator {
                    regExp: /^#[0-9A-Fa-f]{6}$/ // 以 # 开头，后面跟6位十六进制字符
                }
                text: hexVal // Default value
                baselineOffset: hexlabel.baselineOffset
                font.pointSize:pointSize
                selectByMouse: true

                onTextChanged:{
                    hexInput.text = hexInput.text.toUpperCase();
                }
                onFocusChanged:{
                    if (!hexInput.activeFocus){
                        //hexInput.text = hexInput.text.toUpperCase();
                        console.log("leave hex");
                        hexVal=padZero(hexInput.text);
                        colorPreview.color = hexVal;
                        rVal = hexToRgb(hexVal)[0];
                        gVal = hexToRgb(hexVal)[1];
                        bVal = hexToRgb(hexVal)[2];
                        rInput.text=rVal;
                        gInput.text=gVal;
                        bInput.text=bVal;
                    }

                }
            }
        }

        Rectangle{
            id:colorPreviewBorder
            anchors.bottom:standardButtons.top
            anchors.top:hexInput.bottom
            anchors.topMargin:5
            width:paletteDia.width*0.3
            height:paletteDia.height*0.2
            color:Qt.rgba(0.5,0.5,0.5,0.5)

            Rectangle{
                id:colorPreview
                //anchors.verticalCenter:
                anchors{
                    centerIn:parent
                }
                width:parent.width-2
                height:parent.height-2
                color: hexVal
                opacity:opa
            }
        }
    }

    function hslToRgb(h, s, l) {
        h /= 360.0;
        s /= 100.0;
        l /= 100.0;

        var r, g, b;

        if (s == 0) {
            r = g = b = l; // achromatic
        } else {
            var hue2rgb = function hue2rgb(p, q, t) {
                if (t < 0) t += 1;
                if (t > 1) t -= 1;
                if (t < 1/6) return p + (q - p) * 6 * t;
                if (t < 1/2) return q;
                if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
                return p;
            }

            var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
            var p = 2 * l - q;
            r = hue2rgb(p, q, h + 1/3);
            g = hue2rgb(p, q, h);
            b = hue2rgb(p, q, h - 1/3);
        }

        r = Math.round(r * 255);
        g = Math.round(g * 255);
        b = Math.round(b * 255);
        var hexr=("00" + parseInt(r).toString(16).toUpperCase()).slice(-2);
        var hexg=("00" + parseInt(g).toString(16).toUpperCase()).slice(-2);
        var hexb=("00" + parseInt(b).toString(16).toUpperCase()).slice(-2);

        var hexcode="#"+hexr+hexg+hexb;
        //console.log("rgb",r,g,b);
        //console.log("hex",hexr,hexg,hexb,hexcode);
        return "#"+hexr+hexg+hexb;
    }

    function rgbToHsl(r, g, b) {
        var maxVal = Math.max(r, g, b);
        var minVal = Math.min(r, g, b);
        var h, s, l = (maxVal + minVal) / 2;

        if (maxVal === minVal) {
            h = 0;
            s = 0;
        } else {
            var d = maxVal - minVal;
            s = l > 0.5 ? d / (2 - maxVal - minVal) : d / (maxVal + minVal);

            if (maxVal === r)
                h = (g - b) / d + (g < b ? 6 : 0);
            else if (maxVal === g)
                h = (b - r) / d + 2;
            else
                h = (r - g) / d + 4;

            h /= 6;
        }

        return [h, s, l];
    }

    function updateHex(){
        rVal=Math.min(rInput.text,255);
        gVal=Math.min(gInput.text,255);
        bVal=Math.min(bInput.text,255);
        rInput.text=rVal;
        gInput.text=gVal;
        bInput.text=bVal;
        hexVal=rgbToHex(rVal,gVal,bVal);
        hexInput.text=hexVal;
    }
}
