import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../BaseElements"
import org.freedownloadmanager.fdm 1.0
import "../../qt5compat"

import Qt.labs.platform 1.0 as QtLabs

BaseDialog {
    id: root

    width: 542

    property int percents
    property bool running: false
    property bool finished: false
    property bool error: false
    property string errorMsg
    property bool showWarning

    contentItem: BaseDialogItem {
        titleText: qsTr("Create portable version") + App.loc.emptyString
        Keys.onEscapePressed: root.close()
        onCloseClick: root.close()

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            spacing: 10

            DialogWrappedLabel {
                text: qsTr("Portable version of %1 can be used on different computers without the need to install and configure it on each of them.").arg(App.displayName) + App.loc.emptyString
                Layout.fillWidth: true
            }

            DialogWrappedLabel {
                text: qsTr("It can be conveniently placed on a flash disk, for example.") + App.loc.emptyString
                Layout.fillWidth: true
            }

            DialogWrappedLabel {
                visible: !running && !finished
                text: qsTr("Specify here the path where you would like to create this version. It should be a folder on some removable drive.") + App.loc.emptyString
                Layout.fillWidth: true
            }

            RowLayout {
                visible: !running && !finished

                Layout.fillWidth: true

                BaseTextField {
                    id: pathField
                    focus: true
                    Layout.fillWidth: true
                    onAccepted: root.create()
                    Keys.onEscapePressed: root.close()
                    onTextChanged: {showWarning = false;}
                }

                CustomButton {
                    id: folderBtn
                    implicitWidth: 38
                    implicitHeight: 30
                    Layout.alignment: Qt.AlignRight
                    Layout.preferredHeight: height
                    Image {
                        source: Qt.resolvedUrl("../../images/desktop/pick_file.svg")
                        sourceSize.width: 37
                        sourceSize.height: 30
                        layer {
                            effect: ColorOverlay {
                                color: folderBtn.isPressed ? folderBtn.secondaryTextColor : folderBtn.primaryTextColor
                            }
                            enabled: true
                        }
                    }

                    onClicked: browseDlg.open()
                    QtLabs.FolderDialog {
                        id: browseDlg
                        folder: QtLabs.StandardPaths.writableLocation(QtLabs.StandardPaths.HomeLocation)
                        acceptLabel: qsTr("Open") + App.loc.emptyString
                        rejectLabel: qsTr("Cancel") + App.loc.emptyString
                        onAccepted: pathField.text = App.toNativeSeparators(App.tools.url(folder).toLocalFile())
                    }
                }
            }

            RowLayout {
                visible: !running && !finished

                Layout.topMargin: 10
                Layout.bottomMargin: 10
                Layout.alignment: Qt.AlignRight
                Layout.fillWidth: true

                spacing: 5

                Rectangle {
                    color: "transparent"
                    height: cnclBtn.height
                    Layout.fillWidth: true

                    BaseLabel {
                        visible: showWarning
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Please specify the path.") + App.loc.emptyString
                        clip: true
                        wrapMode: Text.Wrap
                        width: parent.width
                        font.pixelSize: 13
                        color: "#585759"
                    }
                }


                CustomButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: root.close();
                    Layout.alignment: Qt.AlignRight
                }

                CustomButton {
                    text: qsTr("OK") + App.loc.emptyString
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    enabled: pathField.text.trim() != ''
                    onClicked: root.create()
                    Layout.alignment: Qt.AlignRight
                }
            }

            //Progressbar
            ColumnLayout {
                visible: running
                Layout.topMargin: 10
                Layout.bottomMargin: 30

                BaseLabel {
                    id: perscentText
                    color: "#595959"
                    text: qsTr("Creating %1\%").arg(Math.round(percents)) + App.loc.emptyString
                }

                DownloadsItemProgressIndicator {
                    Layout.fillWidth: true
                    percent: percents
                }
            }

            BaseLabel {
                visible: finished && error
                text: qsTr("An error occurred while creating a portable version: %1").arg(errorMsg) + App.loc.emptyString
                color: appWindow.theme.errorMessage
                Layout.fillWidth: true
                wrapMode: Label.Wrap
            }

            BaseLabel {
                visible: finished && !error
                text: qsTr("Creating a portable version was successfully completed.") + App.loc.emptyString
                color: appWindow.theme.successMessage
                Layout.fillWidth: true
                wrapMode: Label.Wrap
            }

            CustomButton {
                visible: finished
                id: closeBtn
                text: qsTr("Close") + App.loc.emptyString
                onClicked: root.close();
                Layout.alignment: Qt.AlignRight
                Layout.bottomMargin: 10
            }
        }
    }

    onClosed: {
        if (finished) {
            reset();
        }
        appWindow.appWindowStateChanged()
    }
    onOpened: root.forceActiveFocus()

    function create()
    {
        var path = App.fromNativeSeparators(pathField.text);
        if (App.tools.isLocalAbsoluteFilePathValid(path)) {
            App.portableVersionCreator.create(path);
        } else {
            showWarning = true;
        }
    }

    function reset()
    {
        finished = false;
        error = false;
        errorMsg = "";
        running = false;
        percents = 0;
        showWarning = false;
    }

    Connections {
        target: App.portableVersionCreator
        onRunning: {
            running = isRunning;
            if (!running) {
                errorMsg = App.portableVersionCreator.errorString(false);
                error = errorMsg.length > 0;
                finished = true;
                if (!root.opened) {
                    root.open();
                }
            }
        }
        onProgress: {
            root.percents = percents;
        }
    }
}
