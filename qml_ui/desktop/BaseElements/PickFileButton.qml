import QtQuick 2.12
import "../../common"
import "../../qt5compat"
import "V2"
import org.freedownloadmanager.fdm

Item
{
    id: root

    signal clicked()

    property bool toBrowseForFolder: true

    readonly property var btn: appWindow.uiver === 1 ? v1 : v2

    implicitWidth: btn.implicitWidth
    implicitHeight: btn.implicitHeight

    CustomButton
    {
        id: v1
        visible: appWindow.uiver === 1
        anchors.fill: parent

        implicitWidth: Math.max(37*appWindow.zoom, img.preferredWidth + 2*5*appWindow.zoom)
        implicitHeight: Math.max(30*appWindow.zoom, img.preferredHeight + 2*5*appWindow.zoom)

        clip: true

        onClicked: root.clicked()

        WaSvgImage
        {
            id: img
            source: Qt.resolvedUrl("../../images/desktop/pick_file.svg")
            zoom: appWindow.zoom
            anchors.centerIn: parent

            layer {
                effect: ColorOverlay {
                    color: v1.isPressed ? v1.secondaryTextColor : v1.primaryTextColor
                }
                enabled: true
            }
        }
    }

    ToolbarFlatButton_V2
    {
        id: v2
        visible: appWindow.uiver !== 1
        anchors.fill: parent

        //: Browse for a file
        title: toBrowseForFolder ? "" : qsTr("Browse...") + App.loc.emptyString

        iconSource: Qt.resolvedUrl("V2/folder_open.svg")

        bgColor: appWindow.theme_v2.bg400

        leftPadding: 12*appWindow.zoom
        rightPadding: leftPadding

        onClicked: root.clicked()
    }
}

