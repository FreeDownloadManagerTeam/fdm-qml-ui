import QtQuick 2.12
import QtQuick.Layouts 1.3
import "../BaseElements"
import "../../common"
import org.freedownloadmanager.fdm 1.0

RowLayout
{
    readonly property bool hasError:
        !App.plugins.depsInstaller.running &&
        App.plugins.depsInstaller.error

    visible: App.plugins.depsInstaller.componentName

    WaSvgImage
    {
        source: App.plugins.depsInstaller.componentIconUrl
        visible: source.toString()
        zoom: appWindow.zoom
        Layout.preferredHeight: 64*zoom
        Layout.preferredWidth: Layout.preferredHeight
    }

    ColumnLayout
    {
        Layout.leftMargin: qtbug.leftMargin(15*appWindow.zoom, 0)
        Layout.rightMargin: qtbug.rightMargin(15*appWindow.zoom, 0)

        BaseLabel
        {
            text: App.plugins.depsInstaller.componentName
            font.bold: true
        }

        RowLayout
        {
            WaSvgImage
            {
                visible: hasError
                source: Qt.resolvedUrl("../../images/warning.svg")
                zoom: appWindow.zoom
                Layout.preferredHeight: msg.height
                Layout.preferredWidth: Layout.preferredHeight
            }

            BaseLabel
            {
                id: msg

                text: App.plugins.depsInstaller.running ?
                          App.plugins.depsInstaller.stage :
                          (hasError ? App.plugins.depsInstaller.error :
                                      qsTr("Installed.") + App.loc.emptyString)
                color: hasError ? appWindow.theme.errorMessage :
                                  appWindow.theme.foreground
            }
        }

        ProgressIndicator
        {
            visible: App.plugins.depsInstaller.running
            infinityIndicator: App.plugins.depsInstaller.progress === -1
            percent: App.plugins.depsInstaller.progress
            Layout.preferredHeight: (small ? 6 : 10)*appWindow.zoom
            Layout.preferredWidth: 150*appWindow.zoom
        }
    }
}
