import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "../../common"
import "../BaseElements"

CenteredDialog
{
    id: root

    property double downloadId: -1
    property var info: downloadId !== -1 ? App.downloads.infos.info(downloadId) : null

    modal: true

    contentItem: ColumnLayout {
        width: parent.width
        spacing: 10
        anchors.leftMargin: 20
        anchors.rightMargin: 20

        RowLayout
        {
            WaSvgImage
            {
                source: appWindow.theme.attentionImg
                width: 16
                height: 16
            }

            BaseLabel
            {
                font.bold: true
                text: qsTr("Download Failure") + App.loc.emptyString
            }
        }

        BaseLabel
        {
            text: qsTr("Can't resume download. Download link likely expired. Resume attempts failed.") + "<br><br>" +
                  qsTr("Please try to update the download link to resume.") + "<br><br>" +
                  qsTr("Go to the website with the original download source and copy the renewed link") +
                  (info && App.tools.isBrowsableUrl(info.webPageUrl) ? " - <a href='" + info.webPageUrl.toString() + "'>" + qsTr("click here") + "</a>" : "") + "." +
                  App.loc.emptyString
            Layout.fillWidth: true
            Layout.fillHeight: true
            wrapMode: Label.WordWrap
            textFormat: Text.StyledText
            onLinkActivated: {
                root.close();
                App.openDownloadUrl(link);
            }
        }

        RowLayout {
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            Layout.alignment: Qt.AlignRight

            spacing: 5

            DialogButton {
                visible: info && (info.flags & AbstractDownloadsUi.AllowChangeSourceUrl)
                text: qsTr("Update download") + App.loc.emptyString
                onClicked: {
                    root.close();
                    stackView.waPush(Qt.resolvedUrl("../ChangeUrlPage.qml"), {downloadModel:root.info})
                }
            }

            DialogButton {
                text: qsTr("Close") + App.loc.emptyString
                onClicked: root.close()
            }
        }
    }
}
