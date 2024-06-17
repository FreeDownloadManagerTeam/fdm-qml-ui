import QtQuick 2.12
import QtQuick.Layouts 1.3
import "../BaseElements"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0

BaseDialog
{
    id: root

    property double downloadId: -1
    property var info: downloadId !== -1 ? App.downloads.infos.info(downloadId) : null

    contentItem: BaseDialogItem
    {
        titleText: qsTr("Download Failure") + App.loc.emptyString

        showTitleIcon: true
        titleIconUrl: appWindow.theme.attentionImg

        Keys.onEscapePressed: root.close()
        onCloseClick: root.close()

        ColumnLayout
        {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Layout.leftMargin: 10*appWindow.zoom
            Layout.rightMargin: Layout.leftMargin
            Layout.bottomMargin: Layout.leftMargin

            spacing: 10*appWindow.zoom

            BaseLabel {              
                text: qsTr("Can't resume download. Download link likely expired. Resume attempts failed.") + "<br><br>" +
                      qsTr("Please try to update the download link to resume.") + "<br><br>" +
                      qsTr("Go to the website with the original download source and copy the renewed link") +
                      (info && App.tools.isBrowsableUrl(info.webPageUrl) ? " - <a href='" + info.webPageUrl.toString() + "'>" + qsTr("click here") + "</a>" : "") + "." +
                      App.loc.emptyString
                wrapMode: Text.WordWrap
                Layout.fillHeight: true
                Layout.fillWidth: true
                textFormat: Text.StyledText
                onLinkActivated: App.openDownloadUrl(link)
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton // we don't want to eat clicks on the Text
                    cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight

                CustomButton {
                    visible: info && (info.flags & AbstractDownloadsUi.AllowChangeSourceUrl)
                    text: qsTr("Update download") + App.loc.emptyString
                    blueBtn: true
                    onClicked: {
                        root.close();
                        changeUrlDlg.showDialog(downloadId);
                    }
                }

                CustomButton {
                    text: qsTr("Close") + App.loc.emptyString
                    blueBtn: true
                    onClicked: root.close();
                }
            }
        }
    }
}
