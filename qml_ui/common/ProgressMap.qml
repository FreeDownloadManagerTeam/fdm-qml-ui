import QtQuick 2.10
import org.freedownloadmanager.fdm 1.0
import CppControls 1.0 as CppControls

Item {

    id: root

    anchors.fill: parent

    property var downloadId

    ////////////////////////////////////////////////
    //TODO: remove?
    property bool forceMapLoading: false
    property bool alignCenter: false
    ////////////////////////////////////////////////

    CppControls.ProgressMap
    {
        property var mapObj: App.downloads.infos.info(root.downloadId).progressMap(columnsCount*rowsCount)
        anchors.fill: parent
        map: mapObj.map
        filledSquareBorderColor: appWindow.theme.progressMapFillBorder
        filledSquareColor: appWindow.theme.progressMapFillBackground
        emptySquareBorderColor: appWindow.theme.progressMapClearBorder
        emptySquareColor: appWindow.theme.background
        squareSize: 8
        squareSpacing: 3
    }
}

/*Item {

    id: root

    anchors.fill: parent

    property var downloadId
    property bool forceMapLoading: false

    property int rectangleSize: 10

    property int rowsCount: Math.floor(root.height / rectangleSize)
    property int columnsCount: Math.floor(root.width / rectangleSize)

    property var intervals: []

    property var downloadProgressMap: App.downloads.infos.info(root.downloadId).progressMap(1)

    property bool alignCenter: false

    Canvas {
        id: map
        width: columnsCount * rectangleSize
        height: rowsCount * rectangleSize
        anchors.horizontalCenter: alignCenter ? parent.horizontalCenter : undefined
        anchors.left: alignCenter ? undefined : parent.left
        anchors.bottom: parent.bottom
        property int offset: 1

        onPaint: drawMap()

        function drawMap() {
            if (columnsCount === 0 || rowsCount === 0) {
                return;
            }

            var map = downloadProgressMap.map();
            var ctx = getContext("2d");

            for (var i = 0; i < map.length; i++) {
                var x = (i % columnsCount) * rectangleSize;
                var y = (Math.floor(i/columnsCount)) * rectangleSize;

                if (map[i]) {
                    drawFillRect(ctx, x, y);
                } else {
                    drawClearRect(ctx, x, y);
                }
            }
        }

        function drawFillRect(ctx, x, y) {
            ctx.fillStyle = appWindow.theme.progressMapFillBorder
            ctx.fillRect(x + offset, y + offset, rectangleSize - offset * 2, rectangleSize - offset * 2);
            ctx.fillStyle = appWindow.theme.progressMapFillBackground
            ctx.fillRect(x + offset + 1, y + offset + 1, rectangleSize - (offset + 1) * 2, rectangleSize - (offset + 1) * 2);
        }

        function drawClearRect(ctx, x, y) {
            ctx.fillStyle = appWindow.theme.progressMapClearBorder
            ctx.fillRect(x + offset, y + offset, rectangleSize - offset * 2, rectangleSize - offset * 2);
            ctx.fillStyle = appWindow.theme.background
            ctx.fillRect(x + offset + 1, y + offset + 1, rectangleSize - (offset + 1) * 2, rectangleSize - (offset + 1) * 2);
        }
    }

    Connections {
        target: downloadProgressMap
        onMapChanged: updateTimer.start();
    }

    onColumnsCountChanged: mapChanged()
    onRowsCountChanged: mapChanged()
//    Component.onCompleted: mapChanged()

    function mapChanged()
    {
        if (forceMapLoading) {
            updateMap()
        } else {
            updateTimer.start();
        }
    }

    Timer {
        id: updateTimer
        interval: 200;
        running: false;
        repeat: false
        onTriggered: updateMap()
    }

    property int lastPointsCount: 0
    function updateMap()
    {
        var newPointsCount = columnsCount * rowsCount;
        if (newPointsCount < 0) {
            newPointsCount = 0;
        }
        if (newPointsCount === 0) {
            downloadProgressMap = App.downloads.infos.info(root.downloadId).progressMap(1);
        } else if (newPointsCount !== lastPointsCount) {
            downloadProgressMap = App.downloads.infos.info(root.downloadId).progressMap(newPointsCount);
            lastPointsCount = newPointsCount;
        }
        map.requestPaint();
    }
}*/

/*

Item {

    id: root

    anchors.fill: parent

    property var downloadId
    property bool forceMapLoading: false

    property int rectangleSize: 10

    property int rowsCount: Math.floor(root.height / rectangleSize)
    property int columnsCount: Math.floor(root.width / rectangleSize)

    property var intervals: []

    property var downloadProgressMap: App.downloads.infos.info(root.downloadId).progressMap(1)

    property bool alignCenter: false

    function cleanupMap()
    {
        for(var i = progressFillRect.children.length - 1; i >= 0 ; i--) {
            progressFillRect.children[i].destroy();
        }
    }

    function drawMap()
    {
        cleanupMap();
        if (columnsCount === 0 || rowsCount === 0) {
            return;
        }
        var map = downloadProgressMap.map();
        var interval = false;
        var drowInterval = function(interval){
            var x = interval.start_c * rectangleSize;
            var y = interval.start_r * rectangleSize;
            var width = (interval.last_c - interval.start_c + 1) * rectangleSize;
            var object = progressFillImg.createObject(progressFillRect, {"x": x, "y": y, "width": width});
        }

        for (var i = 0; i < map.length; i++) {
            if (map[i]) {
                var c = i % columnsCount;
                var r = Math.floor(i/columnsCount);
                if (interval && interval.start_r !== r) {
                    drowInterval(interval);
                    interval = false;
                }
                if (!interval) {
                    interval = {
                        start_c: c,
                        start_r: r
                    }
                }
                interval.last_c = c;
            } else {
                if (interval) {
                    drowInterval(interval);
                    interval = false;
                }
            }
        }
        if (interval) {
            drowInterval(interval);
            interval = false;
        }
    }

    Rectangle {
        color: "transparent"
        width: columnsCount * rectangleSize
        height: rowsCount * rectangleSize
        anchors.horizontalCenter: alignCenter ? parent.horizontalCenter : undefined
        anchors.left: alignCenter ? undefined : parent.left
        anchors.bottom: parent.bottom

        Image {
            anchors.fill: parent
            fillMode: Image.Tile
            horizontalAlignment: Image.AlignLeft
            verticalAlignment: Image.AlignTop
            source: appWindow.theme.progressMapClear
        }

        Rectangle {
            id: progressFillRect
            color: "transparent"
            anchors.fill: parent

            Component {
                id: progressFillImg
                Image {
                    source: appWindow.theme.progressMapFill
                    fillMode: Image.Tile
                    horizontalAlignment: Image.AlignLeft
                    verticalAlignment: Image.AlignTop
                }
            }
        }
    }

    Connections {
        target: downloadProgressMap
        onMapChanged: updateTimer.start();
    }

    onColumnsCountChanged: mapChanged()
    onRowsCountChanged: mapChanged()
    Component.onCompleted: mapChanged()

    function mapChanged()
    {
        if (forceMapLoading) {
            updateMap()
        } else {
            updateTimer.start();
        }
    }

    Timer {
        id: updateTimer
        interval: 200;
        running: false;
        repeat: false
        onTriggered: updateMap()
    }

    property int lastPointsCount: 0
    function updateMap()
    {
        var newPointsCount = columnsCount * rowsCount;
        if (newPointsCount < 0) {
            newPointsCount = 0;
        }
        if (newPointsCount === 0) {
            downloadProgressMap = App.downloads.infos.info(root.downloadId).progressMap(1);
        } else if (newPointsCount !== lastPointsCount) {
            downloadProgressMap = App.downloads.infos.info(root.downloadId).progressMap(newPointsCount);
            lastPointsCount = newPointsCount;
        }
        drawMap();
    }
}
*/
