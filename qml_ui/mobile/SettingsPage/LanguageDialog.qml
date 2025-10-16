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

    x: Math.round((appWindow.contentItem.width - width) / 2)
    y: Math.round((appWindow.contentItem.height - height) / 2)

    topMargin: appWindow.SafeArea.margins.top
    leftMargin: appWindow.SafeArea.margins.left
    bottomMargin: appWindow.SafeArea.margins.bottom
    rightMargin: appWindow.SafeArea.margins.right

    modal: true

    contentItem: ColumnLayout {
        spacing: 0

        BaseLabel {
            adaptive: true
            labelSize: adaptiveTools.labelSize.highSize
            text: qsTr("Language") + App.loc.emptyString
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: root.topPadding
            font.pixelSize: 19
            font.weight: Font.Medium
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: appWindow.theme.generalSettingsBorder
        }

        ListView {
            id: langList

            Layout.fillHeight: true
            Layout.fillWidth: true

            property double bckgRatio: 30 / 10

            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds

            model: App.loc.installedTranslations

            implicitHeight: 30 * count
            implicitWidth: 300

            clip: true

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

    onAboutToShow: {
        for (let i = 0; i < langList.model.length; ++i)
        {
            if (App.loc.currentTranslation === langList.model[i])
                langList.positionViewAtIndex(i, ListView.Contain);
        }
    }
}
