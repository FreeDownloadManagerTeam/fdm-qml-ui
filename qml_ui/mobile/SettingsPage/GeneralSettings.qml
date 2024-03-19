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

    property var flags: {"en_US": -250, "ar_EG": -260, "zh_CN": -130, "zh_TW": -270, "ug": -130, "uk_UA": -220,
                         "da_DK": -100, "nl_NL": -80, "fr_FR": -30, "de_DE": -20, "el_GR": -120, "id_ID": -180,
                         "it_IT": -50, "ja_JP": -150, "pl_PL": -70, "pt_BR": -200, "ro_RO": -60, "ru_RU": -110,
                         "sl_SI": -140, "es_ES": -10, "sv_SE": -90, "tr_TR": -160, "vi_VN": -190, "fa": -210,
                         "hu_HU": -230, "fa_IR": -240, "bg_BG": -280, "ko_KR": -290, "hi_IN": -300,
                         "cs_CZ": -310, "fi_FI": -320, "lv_LV": -330 }

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
                            x: 0
                            y: flags[App.loc.currentTranslation]
                            source: Qt.resolvedUrl("../../images/flags.svg")
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
