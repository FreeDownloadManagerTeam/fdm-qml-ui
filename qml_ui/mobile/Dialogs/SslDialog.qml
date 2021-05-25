import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../common/Tools"
import "../BaseElements"

Dialog {
    id: root

    parent: appWindow.overlay

    x: Math.round((appWindow.width - width) / 2)
    y: Math.round((appWindow.height - height) / 2)
    width: appWindow.smallScreen ? 320 : 500

    modal: true

    contentItem: ColumnLayout {
        spacing: 20
        clip: true

        DialogTitle {
            Layout.fillWidth: true
            text: qsTr("Security risk") + App.loc.emptyString
        }

        Label {
            text: downloadTools.sslHost
            color: "#737373"
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }

        Label {
            text: qsTr("SSL Certificate is not valid.") + App.loc.emptyString
            color: "#737373"
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }

        Column {
            Layout.fillWidth: true
            spacing: 10
            BaseLabel {
                Layout.fillWidth: true
                Layout.topMargin: 10
                text: qsTr("Certificate fingerprints") + App.loc.emptyString
            }

            Column {
                width: parent.width
                spacing: 5
                BaseLabel {
                    text: qsTr("SHA-256:") + App.loc.emptyString
                    wrapMode: Text.Wrap
                }
                BaseLabel {
                    width: parent.width
                    text: downloadTools.sslSha256Fingerprint
                    wrapMode: Text.Wrap
                }
            }

            Column {
                width: parent.width
                spacing: 5
                BaseLabel {
                    text: qsTr("SHA1:") + App.loc.emptyString
                    wrapMode: Text.Wrap
                }

                BaseLabel {
                    width: parent.width
                    text: downloadTools.sslSha1Fingerprint
                    wrapMode: Text.Wrap
                }
            }
        }

        RowLayout {
            spacing: 5
            Layout.alignment: Qt.AlignHCenter

            DialogButton {
                text: qsTr("Continue") + App.loc.emptyString
                onClicked: {
                    downloadTools.acceptSsl();
                    root.close();
                }
            }

            DialogButton {
                text: qsTr("Cancel") + App.loc.emptyString
                onClicked: {
                    downloadTools.rejectSsl();
                    root.close();
                }
            }
        }
    }

    onRejected: downloadTools.rejectSsl()

    BuildDownloadTools {
        id: downloadTools
        onReject: {
            stackView.pop();
        }
    }

    function newSslRequest(request)
    {
        downloadTools.buildSslDialog(request);
        root.open();
    }
}
