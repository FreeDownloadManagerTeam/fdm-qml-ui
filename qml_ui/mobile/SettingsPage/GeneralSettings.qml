import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import "../BaseElements"
import "../../common"

Column {
    spacing: 7

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        height: mainContent.implicitHeight + 18
        radius: 26
        color: appWindow.theme.background
        Rectangle {
            width: parent.width
            height: parent.height / 2
            color: parent.color
        }

        GridLayout
        {
            id: mainContent

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            columns: 2

            Item {implicitHeight: 10; implicitWidth: 1}
            Item {implicitHeight: 10; implicitWidth: 1}

            BaseLabel {
                text: qsTr("Language") + App.loc.emptyString
                font.pixelSize: 16
                Layout.fillWidth: true
                MouseArea {
                    anchors.fill: parent
                    onClicked: langDialog.open()
                }
            }

            Item {
                implicitWidth: currentLngRow.implicitWidth
                implicitHeight: currentLngRow.implicitHeight

                RowLayout
                {
                    id: currentLngRow

                    Rectangle {
                        clip: true
                        color: "transparent"
                        implicitWidth: 18
                        implicitHeight: 10
                        WaSvgImage {
                            source: Qt.resolvedUrl("../../images/flags/" + App.loc.currentTranslation + ".svg")
                        }
                    }

                    BaseLabel {
                        text: App.loc.translationLanguageString(App.loc.currentTranslation) + " (" + App.loc.translationCountryString(App.loc.currentTranslation) + ")"
                        font.capitalization: Font.Capitalize
                        font.pixelSize: 16
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: langDialog.open()
                }
            }

            Item {visible: App.loc.needRestart; implicitHeight: 10; implicitWidth: 1}
            RestartRequiredLabel {visible: App.loc.needRestart}
        }
    }

    LanguageDialog {
        id: langDialog
    }
}
