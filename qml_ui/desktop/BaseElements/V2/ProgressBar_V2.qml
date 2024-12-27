import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm 1.0
import "../../../common/Tools"

ProgressBar
{
    id: root

    property bool running: false
    property string text
    property int eta: -1 // ETA, in seconds
    readonly property string percentsString: indeterminate ?
                                                 qsTr("n/a") + App.loc.emptyString :
                                                 Math.floor(visualPosition * 100) + '%'

    to: 100

    background: Rectangle {
        radius: 4*appWindow.zoom
        implicitHeight: 16*appWindow.zoom
        implicitWidth: 70*appWindow.zoom
        color: appWindow.theme_v2.bg300
    }

    contentItem: Item {
        implicitHeight: 16*appWindow.zoom
        implicitWidth: 70*appWindow.zoom
        clip: true

        Rectangle {
            visible: !root.indeterminate
            radius: 4*appWindow.zoom
            color: value == to ? appWindow.theme_v2.primary : appWindow.theme_v2.bg400
            width: root.visualPosition * parent.width
            height: parent.height
        }

        Rectangle {
            visible: root.indeterminate && root.running
            radius: 4*appWindow.zoom
            width: parent.width/4
            height: parent.height
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: appWindow.theme_v2.bg500 }
                GradientStop { position: 0.5; color: appWindow.theme_v2.bg600 }
                GradientStop { position: 1.0; color: appWindow.theme_v2.bg500 }
            }
            XAnimator on x {
                from: -parent.width
                to: root.width
                loops: Animation.Infinite
                running: root.indeterminate && root.running
                duration: 1000
                onToChanged: if (running) restart()
                onFromChanged: if (running) restart()
            }
        }

        BaseText_V2 {
            visible: root.indeterminate || root.value != root.to
            anchors.centerIn: parent
            text: {
                let arr = [];

                if (root.text)
                    arr.push(root.text);

                if (root.percentsString)
                {
                    arr.push(root.percentsString);

                    if (root.running && !root.indeterminate && root.eta >= 0)
                        arr.push(JsTools.timeUtils.remainingTime(root.eta));
                }

                switch (arr.length)
                {
                case 0: return "";

                case 1: return arr[0];

                default: {
                    let result = arr[0] + " (";
                    for (let i = 1; i < arr.length; ++i)
                    {
                        if (i != 1)
                            result += ", ";
                        result += arr[i];
                    }
                    result += ')';
                    return result;
                }

                }
            }
            font.pixelSize: 11*appWindow.fontZoom
        }
    }
}
