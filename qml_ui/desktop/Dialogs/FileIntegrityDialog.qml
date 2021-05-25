import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../common/Tools"
import "../BaseElements"

BaseDialog {
    id: root

    width: 542

    property bool verificationEnabled: currentHash.text != "" && userHash.text != ""
    property bool verificationOK: verificationEnabled && currentHash.text.toLowerCase() == userHash.text.toLowerCase().trim()

    FileIntegrityTools {
        id: fileIntegrityTools
    }

    contentItem: BaseDialogItem {
        titleText: qsTr("Check file integrity") + App.loc.emptyString
        Keys.onEscapePressed: root.reject()
        onCloseClick: root.reject()

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            spacing: 7

            BaseLabel {
                text: fileIntegrityTools.title + " (" + JsTools.sizeUtils.bytesAsText(fileIntegrityTools.size) + ")"
                font.weight: Font.DemiBold
                elide: Text.ElideMiddle
                Layout.fillWidth: true
                Layout.topMargin: 8
            }

            BaseLabel
            {
                text: qsTr("Hash") + App.loc.emptyString
                Layout.topMargin: 5
            }

            RowLayout {
                width: parent.width

                HashAlgorithmCombobox {
                    id: hashCombo
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 30
                }

                //Progressbar
                ColumnLayout {
                    visible: fileIntegrityTools.calculatingInProgress

                    BaseLabel {
                        id: perscentText
                        font.pixelSize: 12
                        color: "#595959"
                        text: qsTr("Calculating %1\%").arg(Math.round(fileIntegrityTools.calculatingProgress)) + App.loc.emptyString
                    }

                    DownloadsItemProgressIndicator {
                        Layout.fillWidth: true
                        percent: fileIntegrityTools.calculatingProgress
                    }

                }

                BaseTextField
                {
                    id: currentHash
                    visible: !fileIntegrityTools.calculatingInProgress
                    Layout.fillWidth: true
                    selectByMouse: true
                    readOnly: true
                }
            }

            BaseLabel
            {
                text: qsTr("Compare with") + App.loc.emptyString
                Layout.topMargin: 5
            }

            BaseTextField
            {
                id: userHash
                Layout.fillWidth: true
                selectByMouse: true
                focus: true
            }

            Rectangle {
                width: parent.width
                height: 50

                BaseLabel
                {
                    visible: verificationEnabled
                    color: verificationOK ? appWindow.theme.successMessage : appWindow.theme.errorMessage
                    text: (verificationOK ? qsTr("Verification OK") : qsTr("Verification failed")) + App.loc.emptyString
                }
            }

            RowLayout {
                Layout.topMargin: 10
                Layout.bottomMargin: 10
                Layout.alignment: Qt.AlignRight

                spacing: 5

                CustomButton {
                    text: qsTr("Close") + App.loc.emptyString
                    onClicked: root.reject()
                }
            }
        }
    }

    onClosed: {appWindow.appWindowStateChanged();}
    onOpened: {userHash.text = "";}

    function showRequestData(requestId, fileIndex)
    {
        fileIntegrityTools.start(requestId, fileIndex);
        root.open();
    }

    function reject()
    {
        fileIntegrityTools.abortHashCalculating();
        root.close();
    }
}
