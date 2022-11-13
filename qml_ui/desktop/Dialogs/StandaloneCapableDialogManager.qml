import QtQuick 2.12
import "../../common"

Item
{
    id: root

    property bool standalone: false
    property url componentSource
    property var componentProperties
    property var dialog: null
    property var hostWindow: null

    property bool opened: dialog && dialog.opened

    onStandaloneChanged: {
        let d = dialog;
        let w = hostWindow;
        dialog = null;
        hostWindow = null;
        if (d)
            d.destroy();
        if (w)
            w.destroy();
        makeSureDialogCreated();
    }

    ComponentLoader
    {
        id: dialogComponent
        source: componentSource
        onLoaded: makeSureDialogCreated()
    }

    ComponentLoader
    {
        id: hostWindowComponent
        active: root.standalone
        source: Qt.resolvedUrl("StandaloneCapableDialogHostWindow.qml")
        onLoaded: makeSureDialogCreated()
    }

    function makeSureDialogCreated()
    {
        if (!dialog)
        {
            console.assert(componentSource.toString(), "[StandaloneCapableDialogManager]: error: componentSource is not defined");

            if (standalone && !hostWindowComponent.c)
                return;
            if (!dialogComponent.c)
                return;

            if (standalone)
                hostWindow = hostWindowComponent.c.createObject(null);

            let properties = componentProperties;
            if (!properties)
                properties = {};
            properties['standalone'] = standalone;

            dialog = dialogComponent.c.createObject(
                        standalone ? hostWindow : appWindow,
                        properties);

            if (hostWindow)
            {
                hostWindow.maximumWidth = Qt.binding(() => dialog ? dialog.width : 0);
                hostWindow.maximumHeight = Qt.binding(() => dialog ? dialog.height : 0);

                hostWindow.minimumWidth = Qt.binding(() => dialog ? dialog.width : 0);
                hostWindow.minimumHeight = Qt.binding(() => dialog ? dialog.height : 0);

                hostWindow.width = Qt.binding(() => dialog ? dialog.width : 0);
                hostWindow.height = Qt.binding(() => dialog ? dialog.height : 0);

                hostWindow.visible = Qt.binding(() => dialog ? dialog.opened : false);
                hostWindow.closeClicked.connect(() => dialog.close());
            }
        }
    }
}
