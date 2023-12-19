import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../../common"
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0
import org.freedownloadmanager.fdm.knownwebbrowsers 1.0
import org.freedownloadmanager.fdm.appconstants 1.0

import "../BaseElements"

Column {
    id: root

    visible: App.features.hasFeature(AppFeatures.BrowsersIntegration)
    spacing: 0

    property var browsers: [
        {id: KnownWebBrowsers.Edge, title: "Edge", icon: Qt.resolvedUrl("../../images/desktop/edge_logo.svg"), supported: App.integration.isBrowserSupported(KnownWebBrowsers.Edge), installed: App.integration.isBrowserInstalled(KnownWebBrowsers.Edge)},
        {id: KnownWebBrowsers.Chrome, title: "Google Chrome", icon: Qt.resolvedUrl("../../images/desktop/chrome_logo.svg"), supported: App.integration.isBrowserSupported(KnownWebBrowsers.Chrome), installed: App.integration.isBrowserInstalled(KnownWebBrowsers.Chrome)},
        {id: KnownWebBrowsers.Firefox, title: "Firefox", icon: Qt.resolvedUrl("../../images/desktop/firefox_logo.svg"), supported: App.integration.isBrowserSupported(KnownWebBrowsers.Firefox), installed: App.integration.isBrowserInstalled(KnownWebBrowsers.Firefox)},
        {id: KnownWebBrowsers.Vivaldi, title: "Vivaldi", icon: "", supported: App.integration.isBrowserSupported(KnownWebBrowsers.Vivaldi), installed: App.integration.isBrowserInstalled(KnownWebBrowsers.Vivaldi)},
        {id: KnownWebBrowsers.Opera, title: "Opera", icon: "", supported: App.integration.isBrowserSupported(KnownWebBrowsers.Opera), installed: App.integration.isBrowserInstalled(KnownWebBrowsers.Opera)},
        {id: KnownWebBrowsers.Brave, title: "Brave", icon: "", supported: App.integration.isBrowserSupported(KnownWebBrowsers.Brave), installed: App.integration.isBrowserInstalled(KnownWebBrowsers.Brave)}
    ]

    property var browserButtons: Qt.platform.os == 'windows' ? [KnownWebBrowsers.Edge, KnownWebBrowsers.Chrome, KnownWebBrowsers.Firefox] : [KnownWebBrowsers.Chrome, KnownWebBrowsers.Firefox]

    property var buttonsModel: []
    property var listModel: []

    signal extensionClicked
    onExtensionClicked: {
        interceptCheckbox.checked = true;
        interceptCheckbox.clickCheckbox();
    }

    Component.onCompleted: filterBrowsers()

    function filterBrowsers() {
        buttonsModel = browsers.filter(e => e.supported &&  browserButtons.includes(e.id) && e.installed).concat(browsers.filter(e => e.supported &&  browserButtons.includes(e.id) && !e.installed));
        listModel    = browsers.filter(e => e.supported && !browserButtons.includes(e.id) && e.installed).concat(browsers.filter(e => e.supported && !browserButtons.includes(e.id) && !e.installed));
    }

    SettingsGroupHeader {
        text: qsTr("Browser Integration") + App.loc.emptyString
    }

    SettingsGroupColumn {

        anchors.left: parent.left

        width: parent.width

        BaseLabel {
            width: parent.width
            rightPadding: qtbug.rightPadding(0, 10*appWindow.zoom)
            leftPadding: qtbug.leftPadding(0, 10*appWindow.zoom)
            text: qsTr("Make sure you have %1 extension installed, otherwise, click one of the buttons below").arg(App.shortDisplayName) + App.loc.emptyString
            wrapMode: Label.WordWrap
            bottomPadding: 6*appWindow.zoom
        }

        // browser buttons: 1 row (if there is enough space), or 1 column otherwise
        Item {
            id: browserButtonsItem

            width: parent.width
            implicitHeight: browserButtonsRow.visible ? browserButtonsRow.implicitHeight : browserButtonsCol.implicitHeight

            readonly property bool hasEnoughWidth: browserButtonsRow.implicitWidth - 5*appWindow.zoom <= width

            Row {
                id: browserButtonsRow
                visible: browserButtonsItem.hasEnoughWidth

                anchors.left: parent.left

                spacing: 16*appWindow.zoom

                Repeater {
                    model: root.buttonsModel

                    BrowserButton {
                        browser: modelData
                        height: implicitHeight + 10*appWindow.zoom
                        width: implicitWidth + 10*appWindow.zoom
                    }
                }
            }

            Column {
                id: browserButtonsCol
                visible: !browserButtonsItem.hasEnoughWidth

                anchors.left: parent.left

                spacing: 10*appWindow.zoom

                Repeater {
                    model: root.buttonsModel

                    BrowserButton {
                        anchors.left: parent.left
                        browser: modelData
                        height: implicitHeight + 10*appWindow.zoom
                        width: implicitWidth + 10*appWindow.zoom
                    }
                }
            }
        }

        Row {
            topPadding: 20*appWindow.zoom
            anchors.left: parent.left

            BaseLabel {
                id: lbl
                text: qsTr("Other supported browsers") + App.loc.emptyString
                color: appWindow.theme.settingsSubgroupHeader
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {browsersList.visible = !browsersList.visible}
                }
            }

            Rectangle {
                color: "transparent"
                width: 19*appWindow.zoom
                height: 21*appWindow.zoom

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "transparent"
                    width: 19*appWindow.zoom
                    height: 15*appWindow.zoom
                    clip: true
                    WaSvgImage {
                        source: appWindow.theme.elementsIcons
                        zoom: appWindow.zoom
                        x: (!browsersList.visible ? 3 : -37)*zoom
                        y: -22*zoom
                        layer {
                            effect: ColorOverlay {
                                color: appWindow.theme.settingsSubgroupHeader
                            }
                            enabled: true
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {browsersList.visible = !browsersList.visible}
                }
            }
        }

        Repeater {
            id: browsersList
            visible: false
            model: listModel
            anchors.left: parent.left

            BrowserListElement {
                anchors.left: parent.left
                browser: modelData
                visible: browsersList.visible
            }
        }
    }

    SettingsGroupColumn {

        anchors.left: parent.left

        SettingsSubgroupHeader {
            text: qsTr("Automatically catch downloads from browsers") + App.loc.emptyString
        }

        SettingsCheckBox {
            id: interceptCheckbox
            text: qsTr("Intercept downloads in your web browser") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.app.value(AppSettings.WbInterceptDownloads))
            onClicked: clickCheckbox()

            function clickCheckbox() {
                App.settings.app.setValue(
                            AppSettings.WbInterceptDownloads,
                            App.settings.fromBool(checked));
            }
        }

        SettingsCheckBox {
            text: qsTr("Start downloading without confirmation") + App.loc.emptyString
            checked: App.settings.toBool(App.settings.app.value(AppSettings.SilentModeForNewDownloads))
            onClicked: {
                App.settings.app.setValue(
                            AppSettings.SilentModeForNewDownloads,
                            App.settings.fromBool(checked));
            }
        }

        Rectangle {
            width: parent.width
            height: skipDomains.height
            color: "transparent"
            SettingsCheckBox {
                id: skipDomains
                text: qsTr("Skip domains") + App.loc.emptyString
                checked: App.settings.toBool(App.settings.app.value(AppSettings.WbDontInterceptDownloadsFromUnwantedHosts))
                onClicked: {
                    App.settings.app.setValue(
                                AppSettings.WbDontInterceptDownloadsFromUnwantedHosts,
                                App.settings.fromBool(checked));
                    unwantedHostsList.visible = false;
                }
            }

            Rectangle {
                visible: !unwantedHostsList.visible
                anchors.left: skipDomains.right
                anchors.leftMargin: 5*appWindow.zoom
                anchors.verticalCenter: parent.verticalCenter
                width: 16*appWindow.zoom
                height: width
                color: "transparent"

                WaSvgImage {
                    zoom: appWindow.zoom
                    source: Qt.resolvedUrl("../../images/desktop/edit_list.svg")
                    opacity: skipDomains.checked ? 1 : 0.5
                    layer {
                        effect: ColorOverlay {
                            color: appWindow.theme.foreground
                        }
                        enabled: true
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: { if (skipDomains.checked) { unwantedHostsList.visible = true } }
                        onEntered: toolTipHosts.visible = true
                        onExited: toolTipHosts.visible = false

                        BaseToolTip {
                            id: toolTipHosts
                            text: qsTr("Edit list") + App.loc.emptyString
                        }
                    }
                }
            }
        }

        RowLayout {
            id: unwantedHostsList
            visible: false
            width: 320*appWindow.zoom
            anchors.left: parent.left

            ListEditor {
                myStr: App.settings.app.value(AppSettings.WbDownloadsUnwantedHostsList)
                Layout.leftMargin: qtbug.leftMargin(38*appWindow.zoom,0)
                Layout.rightMargin: qtbug.rightMargin(38*appWindow.zoom,0)
                errorMsg: qsTr("Are you sure this is a valid domain?") + App.loc.emptyString
                validationRegex: /^[\-\d\w\u0400-\u04FF]+(\.[\-\d\w\u0400-\u04FF]+)+$/i

                onCloseClicked: {
                    unwantedHostsList.visible = false
                }

                onListChanged: {
                    if (str != App.settings.dmcore.value(AppSettings.WbDownloadsUnwantedHostsList)) {
                        App.settings.app.setValue(AppSettings.WbDownloadsUnwantedHostsList, str);
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: skipCheckBox.height
            color: "transparent"
            SettingsCheckBox {
                id: skipCheckBox
                text: qsTr("Skip files with extensions") + App.loc.emptyString
                checked: App.settings.toBool(App.settings.app.value(AppSettings.WbDontInterceptDownloadsWithUnwantedExtensions))
                onClicked: {
                    App.settings.app.setValue(
                                AppSettings.WbDontInterceptDownloadsWithUnwantedExtensions,
                                App.settings.fromBool(checked));
                    extensionsList.visible = false;
                }
            }

            Rectangle {
                visible: !extensionsList.visible
                anchors.left: skipCheckBox.right
                anchors.leftMargin: 5*appWindow.zoom
                anchors.verticalCenter: parent.verticalCenter
                width: 16*appWindow.zoom
                height: width
                color: "transparent"
                WaSvgImage {
                    zoom: appWindow.zoom
                    source: Qt.resolvedUrl("../../images/desktop/edit_list.svg")
                    opacity: skipCheckBox.checked ? 1 : 0.5
                    layer {
                        effect: ColorOverlay {
                            color: appWindow.theme.foreground
                        }
                        enabled: true
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: { if (skipCheckBox.checked) {extensionsList.visible = true} }
                        onEntered: toolTipExtensions.visible = true
                        onExited: toolTipExtensions.visible = false

                        BaseToolTip {
                            id: toolTipExtensions
                            text: qsTr("Edit list") + App.loc.emptyString
                        }
                    }
                }
            }
        }

        RowLayout {
            id: extensionsList
            visible: false
            width: 220*appWindow.zoom
            anchors.left: parent.left

            ListEditor {
                myStr: App.settings.app.value(AppSettings.WbDownloadsUnwantedExtensionsList)
                Layout.leftMargin: qtbug.leftMargin(38*appWindow.zoom,0)
                Layout.rightMargin: qtbug.rightMargin(38*appWindow.zoom,0)
                errorMsg: qsTr("Are you sure this is a valid file extension?") + App.loc.emptyString
                validationRegex: /^[\d\w\+\-\!]+$/

                onCloseClicked: {
                    extensionsList.visible = false
                }

                onListChanged: {
                    if (str != App.settings.dmcore.value(AppSettings.WbDownloadsUnwantedExtensionsList)) {
                        App.settings.app.setValue(AppSettings.WbDownloadsUnwantedExtensionsList, str);
                    }
                }
            }
        }


        Rectangle {
            width: parent.width
            height: noCatchSmaller.height
            color: "transparent"
            SettingsCheckBox {
                id: noCatchSmaller
                text: qsTr("Don't catch downloads smaller than") + App.loc.emptyString
                checked: App.settings.toBool(App.settings.app.value(AppSettings.WbDontInterceptTooSmallDownloads))
                onClicked: {
                    App.settings.app.setValue(
                                AppSettings.WbDontInterceptTooSmallDownloads,
                                App.settings.fromBool(checked));
                }
            }

            SettingsTextField {
                id: smallSizeValue
                enabled: noCatchSmaller.checked
                anchors.left: noCatchSmaller.right
                anchors.leftMargin: 5*appWindow.zoom
                anchors.verticalCenter: parent.verticalCenter
                implicitWidth: 60*appWindow.zoom
                text: parseInt(App.settings.app.value(AppSettings.WbDownloadsTooSmallSizeValue)/AppConstants.BytesInKB/AppConstants.BytesInKB)
                onTextChanged: tryBrowserSettingsTimer.restart()
                inputMethodHints: Qt.ImhDigitsOnly
                validator: QtRegExpValidator { regExp: /\d+/ }
            }

            BaseLabel {
                anchors.left: smallSizeValue.right
                anchors.leftMargin: 5*appWindow.zoom
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Mbytes") + App.loc.emptyString
            }
        }

        SettingsCheckBox {
            text: qsTr("Use browser if you cancel download via %1").arg(App.shortDisplayName) + App.loc.emptyString
            checked: App.settings.toBool(App.settings.app.value(AppSettings.WbAbortedInterceptedDownloadForwardToBrowser))
            onClicked: {
                App.settings.app.setValue(
                            AppSettings.WbAbortedInterceptedDownloadForwardToBrowser,
                            App.settings.fromBool(checked));
            }
        }
    }

    Timer {
        id: tryBrowserSettingsTimer
        interval: 500
        repeat: false
        onTriggered: tryApplyBrowserSettings()
    }

    function smallSizeValueValid()
    {
        if (parseInt(smallSizeValue.text) == smallSizeValue.text)
            return true;
    }

    function extensionsListValueValid()
    {
        return true;
    }

    function unwantedHostsListValueValid()
    {
        return true;
    }

    function tryApplyBrowserSettings()
    {
        if (!smallSizeValueValid())
            return;

        if (!extensionsListValueValid())
            return;

        if (!unwantedHostsListValueValid())
            return;

        var small_size_value_format = smallSizeValue.text * AppConstants.BytesInKB * AppConstants.BytesInKB;
        if (small_size_value_format != App.settings.dmcore.value(AppSettings.WbDownloadsTooSmallSizeValue)) {
            App.settings.app.setValue(AppSettings.WbDownloadsTooSmallSizeValue,
                                         small_size_value_format);
        }
    }
}
