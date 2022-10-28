import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import org.freedownloadmanager.fdm.remotecontrol 1.0
import "../BaseElements"
import "../../common"

Item
{
    id: root

    visible: App.features.hasFeature(AppFeatures.RemoteControlServer) &&
             !App.rc.client.active

    implicitHeight: content.implicitHeight
    implicitWidth: content.implicitWidth

    width: parent.width

    Column
    {
        id: content

        anchors.fill: parent

        spacing: 0

        SettingsGroupHeader {
            text: qsTr("Remote Access") + ' ' + qsTr("(beta)") + App.loc.emptyString
        }

        Row
        {
            spacing: 40*appWindow.zoom

            SettingsGroupColumn {
                id: settingsGroupColumn

                SettingsCheckBox {
                    id: allowRcCb
                    text: qsTr("Allow remote access to %1 running on this device").arg(App.shortDisplayName) + App.loc.emptyString
                    checked: App.rc.server.enabled
                    onClicked: App.rc.server.enabled = checked
                }

                Grid {
                    id: infoGrid

                    enabled: allowRcCb.checked
                    anchors.left: parent.left
                    anchors.leftMargin: 38*appWindow.zoom

                    columns: 2
                    rowSpacing: 5*appWindow.zoom
                    columnSpacing: 30*appWindow.zoom

                    BaseLabel {
                        text: qsTr("ID") + App.loc.emptyString
                    }

                    BaseSelectableLabel {
                        id: idText
                        text: App.rc.id || " "
                    }

                    BaseLabel {
                        text: qsTr("Password") + App.loc.emptyString
                    }

                    Row
                    {
                        spacing: 5*appWindow.zoom

                        BaseSelectableLabel {
                            id: passwordText
                            text: App.rc.server.password || " "
                        }

                        WaSvgImage {
                            visible: App.rc.server.password
                            source: Qt.resolvedUrl("../../images/refresh.svg")
                            height: passwordText.height
                            width: height
                            smooth: false
                            zoom: appWindow.zoom
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: App.rc.server.generateNewPassword()
                            }
                        }
                    }

                    BaseLabel {
                        text: qsTr("Status") + App.loc.emptyString
                    }

                    ElidedLabelWithTooltip {
                        id: statusText
                        sourceText: App.rc.server.statusString || " "
                        width: Math.min(sourceTextWidth, 250*appWindow.zoom)
                        color: App.rc.server.status == RemoteControl.ServerStarting ? appWindow.theme.foreground :
                               App.rc.server.status == RemoteControl.ServerStillStarting ? appWindow.theme.lowMode :
                               App.rc.server.status == RemoteControl.ServerFailedToStart ? appWindow.theme.lowMode :
                               App.rc.server.status == RemoteControl.ServerRunning ? appWindow.theme.successMessage :
                                                                                     appWindow.theme.foreground
                    }
                }
            }

            Column
            {
                topPadding: settingsGroupColumn.topPadding - 8*appWindow.zoom

                Image
                {
                    id: qrCodeImg

                    visible: allowRcCb.checked && App.rc.id

                    source: visible ? "image://qrcode/remoteControl" : ""

                    fillMode: Image.Pad

                    cache: false

                    smooth: false
                }
            }
        }
    }

    Connections {
        target: App.rc.server
        onPasswordChanged: onIdOrPasswordChanged()
    }

    Connections {
        target: App.rc
        onIdChanged: onIdOrPasswordChanged()
    }

    function onIdOrPasswordChanged()
    {
        if (qrCodeImg.visible)
        {
            let source = qrCodeImg.source;
            qrCodeImg.source = "";
            qrCodeImg.source = source;
        }
    }
}
