import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../common"
import "../../qt5compat"

ComboBox {
    id: root

    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom
    implicitHeight: 30*appWindow.zoom

    editable: true

    property int popupWidth: 120*appWindow.zoom
    property int visibleRowsCount: 5

    signal folderRemoved(var path)

    model: ListModel {}

    delegate: Rectangle {
        id: delegateRoot

        property bool hover: false
        color: hover ? appWindow.theme.menuHighlight : "transparent"
        height: 30*appWindow.zoom
        width: parent ? parent.width : 0

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 6*appWindow.zoom
            anchors.rightMargin: 6*appWindow.zoom

            BaseLabel {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: App.toNativeSeparators(folder)
                elide: Text.ElideRight

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: delegateRoot.hover = true
                    onExited: delegateRoot.hover = false
                    onClicked: {
                        root.currentIndex = index;
                        root.editText = App.toNativeSeparators(folder);
                        root.popup.close();
                    }
                }

                BaseToolTip
                {
                    text: parent.text
                    visible: delegateRoot.hover && parent.truncated
                }
            }

            WaSvgImage {
                visible: root.model.count > 1
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: qtbug.leftMargin(0, 6*appWindow.zoom)
                Layout.rightMargin: qtbug.rightMargin(0, 6*appWindow.zoom)

                zoom: appWindow.zoom
                source: appWindow.macVersion ? Qt.resolvedUrl("../../images/desktop/search_clear_mac.svg") :
                                               Qt.resolvedUrl("../../images/desktop/clean.svg")

                layer {
                    effect: ColorOverlay {
                        color: appWindow.theme.foreground
                    }
                    enabled: true
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        let etext = root.editText;
                        let path = folder;
                        root.model.remove(index, 1);
                        if (App.toNativeSeparators(etext) === App.toNativeSeparators(path) &&
                                root.model.count)
                        {
                            etext = App.toNativeSeparators(root.model.get(0).folder);
                        }
                        root.editText = etext;
                        root.folderRemoved(path);
                    }
                }
            }
        }
    }

    background: Rectangle {
        color: appWindow.theme.background
        border.color: appWindow.theme.border
        border.width: 1*appWindow.zoom
    }

    contentItem: BaseTextField {
        text: root.editText
        anchors.left: parent.left
        leftPadding: qtbug.leftPadding(6*appWindow.zoom, 30*appWindow.zoom)
        rightPadding: qtbug.rightPadding(6*appWindow.zoom, 30*appWindow.zoom)
        background: Rectangle {
            color: "transparent"
            border.color: "transparent"
        }
        focus: true
    }

    indicator: Rectangle {
        z: 1
        x: LayoutMirroring.enabled ? 0 : root.width - width
        y: root.topPadding + (root.availableHeight - height) / 2
        width: height - 1*appWindow.zoom
        height: root.height
        color: "transparent"
        border.width: 1*appWindow.zoom
        border.color: appWindow.theme.border
        Rectangle {
            width: 9*appWindow.zoom
            height: 8*appWindow.zoom
            color: "transparent"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            WaSvgImage {
                source: appWindow.theme.elementsIcons
                zoom: appWindow.zoom
                x: 0
                y: -448*zoom
            }
        }

        MouseArea {
            propagateComposedEvents: false
            height: parent.height
            width: parent.width
            cursorShape: Qt.ArrowCursor
            onClicked: {
                if (root.popup.opened) {
                    root.popup.close();
                } else {
                    root.popup.open();
                }
            }
        }
    }

    popup: Popup {
        y: root.height - 1*appWindow.zoom
        width: Math.max(popupWidth, root.width)
        height: (Math.min(visibleRowsCount, root.model.count) * 30 + 2)*appWindow.zoom
        padding: 1*appWindow.zoom

        background: Rectangle {
            color: appWindow.theme.background
            border.color: appWindow.theme.border
            border.width: 1*appWindow.zoom
        }

        contentItem: ListView {
            clip: true
            flickableDirection: Flickable.VerticalFlick
            ScrollBar.vertical: ScrollBar{ visible: root.model.count > visibleRowsCount; policy: ScrollBar.AlwaysOn; }
            boundsBehavior: Flickable.StopAtBounds
            anchors.fill: parent
            model: root.model
            currentIndex: root.highlightedIndex
            delegate: root.delegate
        }
    }

    onModelChanged: setPopupWidth()

    function setPopupWidth() {
        var maxVal = 0;
        var currentVal = 0;
        for (var index in model) {
            currentVal = checkTextSize(model.get(index).folder);
            maxVal = maxVal < currentVal ? currentVal : maxVal;
        }
        popupWidth = maxVal + 20*appWindow.zoom;
    }

    function checkTextSize(text)
    {
        textMetrics.text = text;
        return textMetrics.width;
    }

    TextMetrics {
        id: textMetrics
        font.pixelSize: 12*appWindow.fontZoom
        font.family: Qt.platform.os === "osx" ? font.family : "Arial"
    }
}
