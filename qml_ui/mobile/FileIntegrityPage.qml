import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui 

import "BaseElements"
import "../common/Tools/"

Page {
    id: root
    property var downloadModel
    property int fileIndex

    property bool verificationEnabled: currentHash.displayText != "" && userHash.displayText != ""
    property bool verificationOK: verificationEnabled && currentHash.displayText.toLowerCase() == userHash.displayText.toLowerCase().trim()

    header: Column {
        height: 108
        width: parent.width

        BaseToolBar {
            RowLayout {
                anchors.fill: parent
                anchors.rightMargin: 60

                ToolbarBackButton {
                    onClicked: { fileIntegrityTools.abortHashCalculating(); stackView.pop(); }
                }

                ToolbarLabel {
                    text: qsTr("Check file integrity") + App.loc.emptyString
                    Layout.fillWidth: true
                }
            }
        }

        ToolBarShadow {}

        ExtraToolBar {
            Rectangle {
                color: "transparent"
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20

                BaseLabel {
                    text: fileIntegrityTools.title + " (" + App.bytesAsText(fileIntegrityTools.size) + ")" + App.loc.emptyString
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideMiddle
                    color: appWindow.theme.toolbarTextColor
                }
            }
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10

        Rectangle {
            width: parent.width
            height: enterColumn.height
            color: "transparent"

            Column {
                id: enterColumn
                spacing: 2
                width: parent.width

                Rectangle {
                    width: parent.width
                    height: hashCombo.height
                    color: "transparent"

                    BaseComboBox {
                        id: hashCombo
                        flat: true
                        antialiasing: true
                        anchors.left: parent.left
                        fontSize: 13

                        model: [
                            {text: qsTr("MD5") + App.loc.emptyString, algorithm: AbstractDownloadsUi.Md5, hash: ""},
                            {text: qsTr("SHA-1") + App.loc.emptyString, algorithm: AbstractDownloadsUi.Sha1, hash: ""},
                            {text: qsTr("SHA-256") + App.loc.emptyString, algorithm: AbstractDownloadsUi.Sha256, hash: ""},
                            {text: qsTr("SHA-512") + App.loc.emptyString, algorithm: AbstractDownloadsUi.Sha512, hash: ""}]

                        onActivated: fileIntegrityTools.calculateHash(model[index].algorithm, model[index].hash)
                        Component.onCompleted: fileIntegrityTools.calculateHash(model[currentIndex].algorithm, "")
                    }

                    BaseLabel
                    {
                        anchors {
                            left: hashCombo.right
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }
                        id: errorLabel
                        color: appWindow.theme.errorMessage
                        elide: Text.ElideRight
                    }
                }

                BaseLabel
                {
                    anchors.left: parent.left
                    text: qsTr("Hash") + App.loc.emptyString
                }

                BaseLabel {
                    id: perscentText
                    visible: fileIntegrityTools.calculatingInProgress
                    anchors.left: parent.left
                    anchors.topMargin: 20
                    text: qsTr("Calculating %1\%").arg(Math.round(fileIntegrityTools.calculatingProgress)) + App.loc.emptyString
                }

                Rectangle {
                    visible: fileIntegrityTools.calculatingInProgress
                    width: parent.width
                    height: currentHash.height - perscentText.implicitHeight - 4
                    color: "transparent"

                    // ProgressBar
                    Rectangle {

                        anchors.fill: parent
                        color: "transparent"

                        Rectangle {
                            height: 4
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: 10
                            color: "transparent"

                            ProgressBar {
                                id: progressbar_download
                                from: 0
                                to: 100
                                value: fileIntegrityTools.calculatingProgress
                                anchors.fill: parent
                                LayoutMirroring.enabled: false

                                background: Rectangle {
                                    anchors.fill: parent
                                    color: "#d9d9d9"
                                    radius: 0
                                }

                                contentItem: Item {
                                    anchors.fill: parent

                                    Rectangle {
                                        width: progressbar_download.visualPosition * parent.width
                                        height: parent.height
                                        color: theme.accent
                                    }
                                }
                            }
                        }
                    }
                }

                BaseTextField
                {
                    id: currentHash
                    visible: !fileIntegrityTools.calculatingInProgress
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    selectByMouse: true
                    readOnly: true
                    horizontalAlignment: Text.AlignLeft
                }

            }
        }

        Rectangle {
            width: parent.width
            height: compareColumn.height
            color: "transparent"

            Column {
                id:compareColumn
                spacing: 2
                width: parent.width

                BaseLabel
                {
                    anchors.left: parent.left
                    text: qsTr("Compare with") + App.loc.emptyString
                }

                Rectangle {
                    width: parent.width
                    height: hashCombo.height
                    color: "transparent"

                    BaseTextField
                    {
                        id: userHash
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                        selectByMouse: true
                        focus: true
                        inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                        horizontalAlignment: Text.AlignLeft
                    }
                }

                BaseLabel
                {
                    visible: verificationEnabled
                    color: verificationOK ? "#299100" : "#bc3737"
                    text: (verificationOK ? qsTr("Verification OK") : qsTr("Verification failed")) + App.loc.emptyString
                    anchors.left: parent.left
                }
            }
        }
    }

    FileIntegrityTools {
        id: fileIntegrityTools
        downloadModel: root.downloadModel
        fileIndex: root.fileIndex
    }
}
