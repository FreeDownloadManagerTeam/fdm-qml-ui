import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../BaseElements/V2"

Item
{
    property var downloadItemId: null
    property var downloadInfo: null
    property bool createDownloadDialog: false

    readonly property var myModel: downloadInfo && downloadInfo.filesCount > 1 ? downloadInfo.filesTreeListModel() : null
    property alias rowsCount: listView.count

    implicitWidth: meat.implicitWidth
    implicitHeight: meat.implicitHeight

    signal selectAllToDownload()
    signal selectNoneToDownload()

    onSelectAllToDownload: { if (myModel) myModel.selectAllToDownload() }
    onSelectNoneToDownload: { if (myModel) myModel.selectNoneToDownload() }

    ColumnLayout
    {
        id: meat

        anchors.fill: parent
        anchors.leftMargin: createDownloadDialog ? 0 : appWindow.theme_v2.mainWindowLeftMargin*appWindow.zoom
        anchors.topMargin: createDownloadDialog ? 0 : 8*appWindow.zoom

        spacing: 6*appWindow.zoom

        FilesTreeHeader_V2
        {
            id: filesTreeHeader
            Layout.fillWidth: true
        }

        ListView
        {
            id: listView

            Layout.fillWidth: true
            Layout.fillHeight: true

            model: myModel

            ScrollBar.vertical: BaseScrollBar_V2 {
                policy: parent.contentHeight > parent.height ?
                            ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
            }

            flickableDirection: Flickable.AutoFlickIfNeeded
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            delegate: FilesTreeItem_V2 {
                header: filesTreeHeader
            }
        }
    }
}
