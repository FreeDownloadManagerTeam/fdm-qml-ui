import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import "BaseElements"
import "Dialogs"

Page {

    property string pageName: "WaitingPage"

    header: Column {
        height: 108
        width: parent.width

        BaseToolBar {}
        ToolBarShadow {}
        ExtraToolBar {}

        Rectangle {
            visible: App.asyncLoadMgr.remoteName
            height: 30
            width: parent.width
            color: appWindow.theme.waitPageClr1
            BaseLabel {
                text: qsTr("Loading") + (App.asyncLoadMgr.remoteName ?
                          " (" + qsTr("Connection to %1").arg(App.asyncLoadMgr.remoteName) + ")" + App.loc.emptyString :
                          "")
                anchors.centerIn: parent
            }
        }
    }

    Column
    {
        spacing: 10
        anchors.centerIn: parent

        BaseLabel
        {
            visible: App.asyncLoadMgr.status
            anchors.horizontalCenter: parent.horizontalCenter

            text: App.asyncLoadMgr.status +
                  (App.asyncLoadMgr.error ? " " + qsTr("Error: %1").arg(App.asyncLoadMgr.error) : "") +
                  App.loc.emptyString
        }

        Row
        {
            visible: !App.asyncLoadMgr.loading
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter

            DialogButton
            {
                visible: App.asyncLoadMgr.canUserRetryLoad
                text: qsTr("Retry") + App.loc.emptyString
                onClicked: App.asyncLoadMgr.retryLoad()
            }

            DialogButton
            {
                visible: App.asyncLoadMgr.canUserCancelLoad
                text: qsTr("Cancel") + App.loc.emptyString
                onClicked: App.asyncLoadMgr.cancelLoad()
            }
        }

        DialogButton
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
