import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../../common"
import "../../common/Tools"

BaseDialog {
    id: root

    contentItem: BaseDialogItem {
        titleText: "Warning: your computer might be infected!"
        focus: true
        Keys.onEscapePressed: root.close()
        Keys.onReturnPressed: {
            Qt.openUrlExternally("https://www.freedownloadmanager.org/blog/?p=664");
            root.close();
        }
        onCloseClick: root.close()

        ColumnLayout {
            Layout.leftMargin: 10*appWindow.zoom
            Layout.rightMargin: 10*appWindow.zoom
            Layout.bottomMargin: 10*appWindow.zoom
            spacing: 10*appWindow.zoom

            RowLayout {
                spacing: 20*appWindow.zoom

                WaSvgImage {
                    Layout.alignment: Qt.AlignVCenter
                    source: Qt.resolvedUrl("../../images/warning.svg")
                    zoom: appWindow.zoom
                    Layout.preferredWidth: 32*zoom
                    Layout.preferredHeight: 32*zoom
                }

                BaseHyperLabel {
                    text: "Please read more details in our <a href='https://www.freedownloadmanager.org/blog/?p=664'>Important Security Announcement to Our Valued Users</a>."
                    wrapMode: Text.WordWrap
                    Layout.preferredWidth: 300
                }
            }

            BaseButton {
                Layout.alignment: Qt.AlignRight
                text: "OK"
                blueBtn: true
                onClicked: root.close()
            }
        }
    }

    Timer {
        id: timer
        interval: 500
        onTriggered: {
            if (!root.activeFocus)
                root.forceActiveFocus();
        }
    }

    onOpened: {
        timer.start();
        forceActiveFocus();
    }
}
