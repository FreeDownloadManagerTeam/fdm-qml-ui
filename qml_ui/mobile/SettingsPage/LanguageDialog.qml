import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm 1.0
import "../../qt5compat"
import "../../common"
import "../BaseElements"

Dialog
{
    id: root

    parent: Overlay.overlay

    width: 320
    height: Math.min(appWindow.contentItem.height, langList.count * 30)

    x: Math.round((appWindow.contentItem.width - width) / 2)
    y: Math.round((appWindow.contentItem.height - height) / 2)

    topMargin: appWindow.SafeArea.margins.top
    leftMargin: appWindow.SafeArea.margins.left
    bottomMargin: appWindow.SafeArea.margins.bottom
    rightMargin: appWindow.SafeArea.margins.right

    modal: true

    contentItem: Item {
        anchors.fill: parent

        Rectangle {
            width: parent.width
            height: 36
            color: "transparent"
            anchors.top: parent.top

            BaseLabel {
                adaptive: true
                labelSize: adaptiveTools.labelSize.highSize
                text: qsTr("Language") + App.loc.emptyString
                anchors.centerIn: parent
                font.pixelSize: 19
                font.weight: Font.Medium
            }
            Rectangle {
                width: parent.width
                height: 1
                anchors.bottom: parent.bottom
                color: appWindow.theme.generalSettingsBorder
            }
        }

        Rectangle {
            width: parent.width
            height: parent.height - 36
            anchors.top: parent.top
            anchors.topMargin: 36
            color: "transparent"
            clip: true

            ListView {
                id: langList
                anchors.fill: parent

                property double bckgRatio: 30 / 10

                flickableDirection: Flickable.VerticalFlick
                boundsBehavior: Flickable.StopAtBounds

                model: App.loc.installedTranslations

                delegate: Rectangle {
                    id: listItem
                    height: 30
                    width: langList.width
                    color: "transparent"
                    clip: true
                    readonly property bool isCurrentLang: App.loc.currentTranslation == modelData

                    Rectangle {
                        clip: true
                        color: "transparent"
                        width: 18 * langList.bckgRatio
                        height: parent.height
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 35
                        visible: listItem.isCurrentLang

                        WaSvgImage {
                            zoom: langList.bckgRatio
                            source: Qt.resolvedUrl("../../images/flags/" + modelData + ".svg")
                            opacity: 0.3
                            layer{
                                effect: FastBlur {
                                    radius: 16
                                    transparentBorder: true
                                }
                                enabled: true
                            }
                        }
                    }

                    Rectangle {
                        id: icon
                        clip: true
                        color: "transparent"
                        width: 18
                        height: 10
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 70

                        WaSvgImage {
                            source: Qt.resolvedUrl("../../images/flags/" + modelData + ".svg")
                        }
                    }

                    BaseLabel {
                        leftPadding: qtbug.leftPadding(15 + 18 + 70, 0)
                        rightPadding: qtbug.rightPadding(15 + 18 + 70, 0)
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: App.loc.translationLanguageString(modelData) + " (" + App.loc.translationCountryString(modelData) + ")"
                        font.capitalization: Font.Capitalize
                        font.pixelSize: 14
                    }

                    SettingsSeparator{
                        anchors.bottom: parent.bottom
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            let name = modelData;
                            root.close();
                            App.loc.load(name);
                        }
                    }
                }
            }
        }
    }

    onAboutToShow: {
        for (let i = 0; i < langList.model.length; ++i)
        {
            if (App.loc.currentTranslation === langList.model[i])
                langList.positionViewAtIndex(i, ListView.Contain);
        }
    }
}
