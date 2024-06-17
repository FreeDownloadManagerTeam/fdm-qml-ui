import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../mobile/BaseElements"
import org.freedownloadmanager.fdm

ColumnLayout
{
    id: root

    readonly property var details: App.downloads.infos.info(downloadsItemTools.itemId).details
    readonly property bool finished: downloadsItemTools.finished

    readonly property string btLastSeenComplete : details && details.btLastSeenComplete && App.tools.isDateTimeValid(details.btLastSeenComplete) ?
                                                      App.loc.dateTimeToString(details.btLastSeenComplete, false) + App.loc.emptyString :
                                                      qsTr("N/A") + App.loc.emptyString
    readonly property double btAvailability: details ? details.btAvailability.toPrecision(3) : 0.0
    readonly property int btSeedCount: details ? details.btSeedCount : 0
    readonly property int btConnectedSeedCount: details ? details.btConnectedSeedCount : 0
    readonly property int btPeerCount: details ? details.btPeerCount : 0
    readonly property int btConnectedPeerCount: details ? details.btConnectedPeerCount : 0

    spacing: 10

    GridLayout
    {
        columns: 2

        BaseLabel
        {
            text: App.my_BT_qsTranslate("BtDetailsTab", "Peers:") + App.loc.emptyString
        }
        RowLayout
        {
            BaseLabel
            {
                text: btPeerCount + ' ' + qsTr("(connected: %1)").arg(btConnectedPeerCount) + App.loc.emptyString
            }
            Item {implicitWidth: 30; implicitHeight: 1} // horizontal spacing
        }

        BaseLabel
        {
            text: App.my_BT_qsTranslate("BtDetailsTab", "Seeds:") + App.loc.emptyString
        }
        BaseLabel
        {
            text: btSeedCount + ' ' + qsTr("(connected: %1)").arg(btConnectedSeedCount) + App.loc.emptyString
        }

        BaseLabel
        {
            visible: !finished
            text: App.my_BT_qsTranslate("BtDetailsTab", "Availability:") + App.loc.emptyString
        }
        BaseLabel
        {
            visible: !finished
            text: btAvailability
        }

        BaseLabel
        {
            visible: !finished
            text: App.my_BT_qsTranslate("BtDetailsTab", "Last seen complete:") + App.loc.emptyString
        }
        BaseLabel
        {
            visible: !finished
            text: btLastSeenComplete
        }
    }

    ListView
    {
        id: trackers

        Layout.fillHeight: true
        Layout.fillWidth: true

        ScrollBar.vertical: ScrollBar{}
        flickableDirection: Flickable.AutoFlickIfNeeded
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        headerPositioning: ListView.OverlayHeader

        model: ListModel {}

        property int trackerUrlItemWidth: 0

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: appWindow.theme.border
            border.width: 1
        }

        header: RowLayout {
            width: parent.width
            spacing: 0
            z: 2

            TablesHeaderItem {
                id: trackerUrlItem
                text: App.my_BT_qsTranslate("BtDetailsTab", "Tracker URL") + App.loc.emptyString
                Layout.preferredWidth: trackers.width * 4/9
                Layout.fillHeight: true
                color: appWindow.theme.background
                onWidthChanged: trackers.trackerUrlItemWidth = width
            }

            TablesHeaderItem {
                id: trackerStatusItem
                text: qsTr("Status") + App.loc.emptyString
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: appWindow.theme.background
            }
        }

        delegate: RowLayout {
            width: trackers.width
            height: 35
            spacing: 0

            BaseLabel {
                text: model.url
                Layout.preferredWidth: trackers.trackerUrlItemWidth
                Layout.minimumWidth: Layout.preferredWidth
                Layout.fillHeight: true
                leftPadding: qtbug.leftPadding(6, 0)
                rightPadding: qtbug.rightPadding(6, 0)
                elide: Text.ElideRight
                wrapMode: Text.WrapAnywhere
            }

            BaseLabel {
                text: model.status
                color: model.statusColor
                Layout.fillWidth: true
                Layout.fillHeight: true
                leftPadding: qtbug.leftPadding(6, 0)
                rightPadding: qtbug.rightPadding(6, 0)
                elide: Text.ElideRight
                wrapMode: Text.WordWrap
            }
        }
    }

    onDetailsChanged: updateTrackersModel()

    function updateTrackersModel()
    {
        if (!details)
        {
            trackers.model.clear();
            return;
        }

        for (let i = 0; i < details.btTrackers.length; ++i)
        {
            let t = details.btTrackers[i];

            let status = "";
            let statusColor = "";

            if (t.waitingResponse)
            {
                status = qsTr("Updating...") + App.loc.emptyString;
                statusColor = appWindow.theme.foreground;
            }
            else if (t.error)
            {
                status = App.tools.errorToString(t.error, false);
                statusColor = appWindow.theme.errorMessage;
            }
            else if (t.warning)
            {
                status = t.warning;
                statusColor = appWindow.theme.warningMessage;
            }
            else
            {
                if (t.isOk)
                    status = "OK";
                statusColor = appWindow.theme.successMessage;
            }

            let o = {"url": t.url, "status": status, "statusColor": statusColor};

            if (trackers.model.count > i)
                trackers.model.set(i, o);
            else
                trackers.model.append(o);
        }

        if (trackers.model.count > details.btTrackers.length)
            trackers.model.remove(details.btTrackers.length, trackers.model.count - details.btTrackers.length);
    }

    Connections {
        target: App.loc
        onCurrentTranslationChanged: updateTrackersModel()
    }

    Connections {
        target: appWindow
        onThemeChanged: updateTrackersModel()
    }
}
