import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0

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
                    text: fileIntegrityTools.title + " (" + JsTools.sizeUtils.bytesAsText(fileIntegrityTools.size) + ")"
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

                    ComboBox {
                        id: hashCombo
                        flat: true
                        antialiasing: true

                        model: [
                            {text: qsTr("MD5") + App.loc.emptyString, algorithm: AbstractDownloadsUi.Md5, hash: ""},
                            {text: qsTr("SHA-1") + App.loc.emptyString, algorithm: AbstractDownloadsUi.Sha1, hash: ""},
                            {text: qsTr("SHA-256") + App.loc.emptyString, algorithm: AbstractDownloadsUi.Sha256, hash: ""},
                            {text: qsTr("SHA-512") + App.loc.emptyString, algorithm: AbstractDownloadsUi.Sha512, hash: ""}]
                        textRole: "text"

                        contentItem: Text {
                            id: contentItemText
                            text: hashCombo.displayText
                            verticalAlignment: Text.AlignVCenter
                            color: theme.foreground
                            font.pixelSize: 13
                        }

                        indicator: Image {
                            id: img2
                            anchors.verticalCenter: parent.verticalCenter
                            x: contentItemText.implicitWidth
                            source: Qt.resolvedUrl("../images/arrow_drop_down.svg")
                            sourceSize.width: 24
                            sourceSize.height: 24
                            layer {
                                effect: ColorOverlay {
                                    color: appWindow.theme.foreground
                                }
                                enabled: true
                            }
                        }

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
                    text: qsTr("Hash") + App.loc.emptyString
                }

                BaseLabel {
                    id: perscentText
                    visible: fileIntegrityTools.calculatingInProgress
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

                TextField
                {
                    id: currentHash
                    visible: !fileIntegrityTools.calculatingInProgress
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    selectByMouse: true
                    readOnly: true
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
                    text: qsTr("Compare with") + App.loc.emptyString
                }

                Rectangle {
                    width: parent.width
                    height: hashCombo.height
                    color: "transparent"

                    TextField
                    {
                        id: userHash
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                        selectByMouse: true
                        focus: true
                        inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                    }
                }

                BaseLabel
                {
                    visible: verificationEnabled
                    color: verificationOK ? "#299100" : "#bc3737"
                    text: (verificationOK ? qsTr("Verification OK") : qsTr("Verification failed")) + App.loc.emptyString
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
