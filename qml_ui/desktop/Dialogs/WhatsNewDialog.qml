import QtQuick 2.12
import QtQuick.Layouts 1.3
import "../BaseElements"
import org.freedownloadmanager.fdm 1.0

BaseDialog
{
    id: root

    property string version: ""
    property string changelog: ""

    signal updateClicked()

    contentItem: BaseDialogItem
    {
        titleText: qsTr("New version is available") + App.loc.emptyString
        showTitleIcon: true

        Keys.onEscapePressed: root.close()
        onCloseClick: root.close()

        ColumnLayout
        {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Layout.margins: 10*appWindow.zoom

            spacing: 10*appWindow.zoom

            BaseTextArea
            {
                id: textArea

                Layout.fillHeight: true
                Layout.fillWidth: true

                textFormat: TextEdit.RichText

                rightPadding: 10*appWindow.zoom

                text: "<b>" + qsTr("What's new in %1").arg(root.version) + "</b>" +
                      "<div style='margin-left:20px; margin-top:5px'>" +
                      root.changelog.replace(/\r\n/g, "\n").replace(/\n/g, "<br>") +
                      "</div>" + App.loc.emptyString

                readOnly: true
            }

            CustomButton {
                id: updateBtn
                text: qsTr("Update") + App.loc.emptyString
                onClicked: {
                    updateClicked();
                    root.close();
                }
                Layout.alignment: Qt.AlignHCenter
                blueBtn: true
            }
        }
    }
}
