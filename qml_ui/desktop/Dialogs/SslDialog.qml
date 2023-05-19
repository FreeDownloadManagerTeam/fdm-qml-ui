import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0

import "../../common/Tools"
import "../BaseElements"
import "../../common"

BaseDialog {
    id: root

    contentItem: BaseDialogItem {
        titleText: qsTr("Warning: potential security risk ahead") + App.loc.emptyString
        focus: true

        onCloseClick: {
            downloadTools.rejectSsl();
            root.close();
        }

        Keys.onEscapePressed: {
            downloadTools.rejectSsl();
            root.close();
        }

        Keys.onReturnPressed: {
            downloadTools.rejectSsl();
            root.close();
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10*appWindow.zoom
            Layout.rightMargin: 10*appWindow.zoom
            spacing: 10*appWindow.zoom

            BaseLabel {
                Layout.fillWidth: true
                text: downloadTools.sslHost
                wrapMode: Text.Wrap
            }

            RowLayout {
                spacing: 5*appWindow.zoom

                WaSvgImage {
                    Layout.alignment: Qt.AlignVCenter
                    source: Qt.resolvedUrl("../../images/desktop/ssl_warning.svg")
                    zoom: appWindow.zoom
                    Layout.preferredHeight: preferredHeight
                    Layout.preferredWidth: preferredWidth
                }

                BaseLabel {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    text: qsTr("SSL Certificate is not valid.") + App.loc.emptyString
                    wrapMode: Text.Wrap
                }
            }

            BaseLabel {
                Layout.fillWidth: true
                Layout.topMargin: 10*appWindow.zoom
                text: qsTr("Certificate fingerprints") + App.loc.emptyString
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 2

                BaseLabel {
                    Layout.preferredWidth: 70*appWindow.fontZoom
                    Layout.alignment: Qt.AlignTop
                    text: qsTr("SHA-256:") + App.loc.emptyString
                    wrapMode: Text.Wrap
                }

                BaseLabel {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    text: downloadTools.sslSha256Fingerprint
                    wrapMode: Text.Wrap
                }

                BaseLabel {
                    Layout.alignment: Qt.AlignTop
                    text: qsTr("SHA1:") + App.loc.emptyString
                    wrapMode: Text.Wrap
                }

                BaseLabel {
                    Layout.alignment: Qt.AlignTop
                    text: downloadTools.sslSha1Fingerprint
                    wrapMode: Text.Wrap
                }
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.bottomMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight

                spacing: 5*appWindow.zoom

                CustomButton {
                    id: cnclBtn
                    text: qsTr("Accept the risk and download") + App.loc.emptyString
                    onClicked: {
                        downloadTools.acceptSsl();
                        root.close();
                    }
                }

                CustomButton {
                    text: qsTr("Cancel") + App.loc.emptyString
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    onClicked: {
                        downloadTools.rejectSsl()
                        root.close();
                    }
                }
            }
        }
    }

    BuildDownloadTools {
        id: downloadTools
    }

    onOpened: forceActiveFocus()
    onClosed: appWindow.appWindowStateChanged()

    function newSslRequest(request)
    {
        downloadTools.buildSslDialog(request);
        root.open();
        forceActiveFocus();
    }
}
