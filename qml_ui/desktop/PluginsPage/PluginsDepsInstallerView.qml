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
        Layout.preferredHeight: 64
        Layout.preferredWidth: Layout.preferredHeight
    }

    ColumnLayout
    {
        Layout.leftMargin: 15

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

        DownloadsItemProgressIndicator
        {
            visible: App.plugins.depsInstaller.running
            infinityIndicator: App.plugins.depsInstaller.progress === -1
            percent: App.plugins.depsInstaller.progress
            Layout.preferredHeight: small ? 6 : 10
            Layout.preferredWidth: 150
        }
    }
}
