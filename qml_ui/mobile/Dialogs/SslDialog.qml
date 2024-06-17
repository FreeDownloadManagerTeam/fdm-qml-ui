import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../common/Tools"
import "../BaseElements"

Dialog {
    id: root

    readonly property int maximumWidth: Math.min(appWindow.width*0.8, appWindow.smallScreen ? 320 : 500)

    parent: Overlay.overlay

    x: Math.round((appWindow.width - width) / 2)
    y: Math.round((appWindow.height - height) / 2)

    modal: true

    contentItem: ColumnLayout {

        spacing: 10
        clip: true

        DialogTitle {
            Layout.fillWidth: true
            text: qsTr("Security risk") + App.loc.emptyString
        }

        BaseLabel {
            text: downloadTools.sslHost
            color: "#737373"
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            Layout.maximumWidth: root.maximumWidth
            horizontalAlignment: Text.AlignLeft
        }

        BaseLabel {
            text: downloadTools.sslHostIsUnknownErr ?
                      qsTr("The authenticity of the host can't be established.") + App.loc.emptyString :
                      qsTr("SSL Certificate is not valid.") + App.loc.emptyString
            color: "#737373"
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignLeft
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 10
            BaseLabel {
                Layout.fillWidth: true
                text: downloadTools.sslHostIsUnknownErr ?
                          qsTr("%1 key fingerprints").arg(downloadTools.sslAlg) + App.loc.emptyString :
                          qsTr("Certificate fingerprints") + App.loc.emptyString
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 5
                BaseLabel {
                    text: qsTr("SHA-256:") + App.loc.emptyString
                    wrapMode: Text.Wrap
                }
                BaseLabel {
                    text: downloadTools.sslSha256Fingerprint
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                    Layout.maximumWidth: root.maximumWidth
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 5
                BaseLabel {
                    text: qsTr("SHA1:") + App.loc.emptyString
                    wrapMode: Text.Wrap
                }

                BaseLabel {
                    text: downloadTools.sslSha1Fingerprint
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                    Layout.maximumWidth: root.maximumWidth
                }
            }
        }

        BaseLabel {
            visible: downloadTools.sslHostIsUnknownErr
            Layout.fillWidth: true
            text: qsTr("If you trust this host, select Accept to remember the key and carry on connecting.") + App.loc.emptyString
            wrapMode: Text.Wrap
        }

        RowLayout {
            spacing: 5
            Layout.alignment: Qt.AlignHCenter

            DialogButton {
                text: downloadTools.sslHostIsUnknownErr ?
                          qsTr("Accept") + App.loc.emptyString :
                          qsTr("Continue") + App.loc.emptyString
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
