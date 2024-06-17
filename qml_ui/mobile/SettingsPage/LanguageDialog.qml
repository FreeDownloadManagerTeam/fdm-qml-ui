import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import QtQuick.Controls.Material 2.4
import "../../qt5compat"
import "../../common"
import "../BaseElements"

Dialog
{
    id: root

    parent: Overlay.overlay

    width: 320
    height: Math.min(parent.height, langList.count * 30) - 40

    x: Math.round((appWindow.width - width) / 2)
    y: Math.round((appWindow.height - height) / 2)

    modal: true

    // warning: don't forget to modify GeneralSettings.qml too
    property var flags: {"en_US": -250, "ar_EG": -260, "zh_CN": -130, "zh_TW": -270, "ug": -130, "uk_UA": -220,
                         "da_DK": -100, "nl_NL": -80, "fr_FR": -30, "de_DE": -20, "el_GR": -120, "id_ID": -180,
                         "it_IT": -50, "ja_JP": -150, "pl_PL": -70, "pt_BR": -200, "ro_RO": -60, "ru_RU": -110,
                         "sl_SI": -140, "es_ES": -10, "sv_SE": -90, "tr_TR": -160, "vi_VN": -190, "fa": -210,
                         "hu_HU": -230, "fa_IR": -240, "bg_BG": -280, "ko_KR": -290, "hi_IN": -300,
                         "cs_CZ": -310, "fi_FI": -320, "lv_LV": -330, "my_MM": -340, "bn_BD": -350 }

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
                            x: 0
                            y: flags[modelData] * zoom
                            source: Qt.resolvedUrl("../../images/flags.svg")
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
                            x: 0
                            y: flags[modelData]
                            source: Qt.resolvedUrl("../../images/flags.svg")
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
