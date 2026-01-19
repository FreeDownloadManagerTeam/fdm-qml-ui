import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../desktop/BaseElements"
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

    spacing: 10*appWindow.zoom

    GridLayout
    {
        columns: 4

        Layout.topMargin: appWindow.uiver === 1 ? 0 : 8*appWindow.zoom
        Layout.leftMargin: appWindow.uiver === 1 ? 0 : appWindow.theme_v2.mainWindowLeftMargin*appWindow.zoom

        BaseLabel
        {
            text: App.my_BT_qsTranslate("BtDetailsTab", "Peers:") + App.loc.emptyString
            color: appWindow.theme.generalTabKey
        }
        RowLayout
        {
            BaseLabel
            {
                text: btPeerCount + ' ' + qsTr("(connected: %1)").arg(btConnectedPeerCount) + App.loc.emptyString
                color: appWindow.uiver === 1 ?
                           appWindow.theme.generalTabValue :
                           appWindow.theme_v2.textColor
            }
            Item {implicitWidth: 30*appWindow.zoom; implicitHeight: 1} // horizontal spacing
        }

        BaseLabel
        {
            text: App.my_BT_qsTranslate("BtDetailsTab", "Seeds:") + App.loc.emptyString
            color: appWindow.theme.generalTabKey
        }
        BaseLabel
        {
            text: btSeedCount + ' ' + qsTr("(connected: %1)").arg(btConnectedSeedCount) + App.loc.emptyString
            color: appWindow.uiver === 1 ?
                       appWindow.theme.generalTabValue :
                       appWindow.theme_v2.textColor
        }

        BaseLabel
        {
            visible: !finished
            text: App.my_BT_qsTranslate("BtDetailsTab", "Availability:") + App.loc.emptyString
            color: appWindow.theme.generalTabKey
        }
        BaseLabel
        {
            visible: !finished
            text: btAvailability
            color: appWindow.uiver === 1 ?
                       appWindow.theme.generalTabValue :
                       appWindow.theme_v2.textColor
        }

        BaseLabel
        {
            visible: !finished
            text: App.my_BT_qsTranslate("BtDetailsTab", "Last seen complete:") + App.loc.emptyString
            color: appWindow.theme.generalTabKey
        }
        BaseLabel
        {
            visible: !finished
            text: btLastSeenComplete
            color: appWindow.uiver === 1 ?
                       appWindow.theme.generalTabValue :
                       appWindow.theme_v2.textColor
        }
    }

    ListView
    {
        id: trackers

        Layout.fillHeight: true
        Layout.fillWidth: true

        Layout.topMargin: appWindow.uiver === 1 ? 0 : 8*appWindow.zoom
        Layout.leftMargin: appWindow.uiver === 1 ? 0 : appWindow.theme_v2.mainWindowLeftMargin*appWindow.zoom

        ScrollBar.vertical: BaseScrollBar{}
        flickableDirection: Flickable.AutoFlickIfNeeded
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        headerPositioning: ListView.OverlayHeader

        model: ListModel {}

        property int trackerUrlItemWidth: 0

        Rectangle {
            visible: appWindow.uiver === 1
            anchors.fill: parent
            color: "transparent"
            border.color: appWindow.theme.border
            border.width: appWindow.zoom
        }

        header: RowLayout {
            width: parent.width
            spacing: 0
            z: 2

            TablesHeaderItem {
                id: trackerUrlItem
                text: App.my_BT_qsTranslate("BtDetailsTab", "Tracker URL") + App.loc.emptyString
                Layout.preferredWidth: Math.max(headerMinimumWidth, trackers.width / 3)
                Layout.fillHeight: true
                color: appWindow.uiver === 1 ?
                           appWindow.theme.background :
                           appWindow.theme_v2.bgColor
                onWidthChanged: trackers.trackerUrlItemWidth = width
            }

            TablesHeaderItem {
                id: trackerStatusItem
                text: qsTr("Status") + App.loc.emptyString
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: appWindow.uiver === 1 ?
                           appWindow.theme.background :
                           appWindow.theme_v2.bgColor
            }
        }

        delegate: RowLayout {
            width: trackers.width
            height: 22*appWindow.zoom
            spacing: 0

            ElidedLabelWithTooltip {
                sourceText: model.url
                color: appWindow.uiver === 1 ?
                           appWindow.theme.generalTabValue :
                           appWindow.theme_v2.textColor
                Layout.preferredWidth: trackers.trackerUrlItemWidth
                Layout.minimumWidth: Layout.preferredWidth
                Layout.fillHeight: true
                leftPadding: appWindow.uiver === 1 ? qtbug.leftPadding(6*appWindow.zoom,0) : 0
                rightPadding: appWindow.uiver === 1 ? qtbug.rightPadding(6*appWindow.zoom,0) : 0
            }

            ElidedLabelWithTooltip {
                sourceText: model.status
                color: model.statusColor
                Layout.fillWidth: true
                Layout.fillHeight: true
                leftPadding: appWindow.uiver === 1 ? qtbug.leftPadding(6*appWindow.zoom,0) : 0
                rightPadding: appWindow.uiver === 1 ? qtbug.rightPadding(6*appWindow.zoom,0) : 0
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
                statusColor = appWindow.theme.generalTabValue;
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

            // Qt 6.4.3 bug workaround
            // TODO: remove it later, it's fixed e.g. in Qt 6.6.3s
            statusColor = statusColor + "";

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
