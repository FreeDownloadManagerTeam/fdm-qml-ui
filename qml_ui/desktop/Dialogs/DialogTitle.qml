import QtQuick 2.0
import QtQuick.Layouts 1.12
import '../BaseElements'
import "../../common"

Rectangle {

    id: root

    property string text
    property bool showTitleIcon: false
    property bool showCloseButton: true
    property url titleIconUrl: Qt.resolvedUrl("../../images/mobile/fdmlogo.svg")

    signal closeClick

    readonly property int prefferedHeight: 36*appWindow.zoom

    implicitHeight: prefferedHeight
    color: appWindow.theme.dialogTitleBackground

    Rectangle {
        anchors.fill: parent
        visible: appWindow.macVersion && appWindow.theme === lightTheme
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#ececec" }
            GradientStop { position: 1.0; color: "#dddcdc" }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10*appWindow.zoom
        anchors.rightMargin: 10*appWindow.zoom

        WaSvgImage {
            source: root.titleIconUrl
            zoom: appWindow.zoom
            Layout.preferredHeight: Math.min(preferredHeight, root.prefferedHeight - 6*appWindow.zoom)
            Layout.preferredWidth: Layout.preferredHeight
            Layout.alignment: Qt.AlignVCenter
            visible: root.showTitleIcon
        }

        BaseLabel {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            text: root.text
            color: appWindow.macVersion ? appWindow.theme.dialogTitleMac : appWindow.theme.dialogTitle
        }

        Item {
            visible: showCloseButton
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.preferredHeight: 24*appWindow.zoom
            Layout.preferredWidth: 24*appWindow.zoom

            WaSvgImage {
                source: appWindow.theme.elementsIconsRoot + "/close2.svg"
                zoom: appWindow.zoom
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.closeClick()
            }
        }
    }
}
