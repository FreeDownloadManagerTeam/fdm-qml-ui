import QtQuick 2.0
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "./BaseElements"
import "./Dialogs"

Page {

    property string pageName: "WaitingPage"

    header: Column {
        height: 108*appWindow.zoom
        width: parent.width

        Rectangle
        {
            width: parent.width
            height: 60*appWindow.zoom

            color: appWindow.theme.background

            BaseLabel {
                width: parent.width
                text: App.shortDisplayName
                clip: true
                elide: Text.ElideMiddle
                anchors.leftMargin: 10*appWindow.zoom
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 20*appWindow.fontZoom
                font.family: "Roboto"
                horizontalAlignment: Text.AlignHCenter
                font.weight: Font.DemiBold
            }
        }

        Rectangle {
            color: appWindow.theme.bottomPanelBar
            height: 48*appWindow.zoom
            width: parent.width

            BaseLabel {
                text: qsTr("Loading") + (App.asyncLoadMgr.remoteName ?
                          " (" + qsTr("Connection to %1").arg(App.asyncLoadMgr.remoteName) + ")" + App.loc.emptyString :
                          "")
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter

            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: appWindow.theme.background
    }

    Column
    {
        spacing: 10*appWindow.zoom
        anchors.centerIn: parent

        BaseLabel
        {
            visible: App.asyncLoadMgr.status

            text: App.asyncLoadMgr.status +
                  (App.asyncLoadMgr.error ? " " + qsTr("Error: %1").arg(App.asyncLoadMgr.error) : "") +
                  App.loc.emptyString
        }

        Row
        {
            visible: !App.asyncLoadMgr.loading
            spacing: 10*appWindow.zoom

            BaseButton
            {
                visible: App.asyncLoadMgr.canUserRetryLoad
                text: qsTr("Retry") + App.loc.emptyString
                onClicked: App.asyncLoadMgr.retryLoad()
            }

            BaseButton
            {
                visible: App.asyncLoadMgr.canUserCancelLoad
                text: qsTr("Cancel") + App.loc.emptyString
                onClicked: App.asyncLoadMgr.cancelLoad()
            }
        }

        BaseButton
        {
            visible: App.asyncLoadMgr.loading && App.asyncLoadMgr.canUserCancelLoad
            text: qsTr("Abort") + App.loc.emptyString
            onClicked: App.asyncLoadMgr.cancelLoad()
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    AuthDialog
    {
        id: authDlg
        remoteName: App.asyncLoadMgr.remoteName
        passwordOnly: true
        onAccepted: App.asyncLoadMgr.authorize(password, save)
        onRejected: App.asyncLoadMgr.cancelLoad()
        anchors.centerIn: parent
    }

    Connections
    {
        target: App.asyncLoadMgr
        onUnauthorized: {
            authDlg.open();
            authDlg.forceActiveFocus();
        }
    }
}
