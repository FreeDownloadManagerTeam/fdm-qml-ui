import QtQuick 2.12

Item
{
    signal loaded

    property var source: null // url for the component to load (recommended to use Qt.resolvedUrl("..."))
    property var c: null // loaded component
    property bool active: true

    // is component loaded
    function isLoaded()
    {
        return c !== null && c.status === Component.Ready;
    }

    // load / destroy loaded component
    function load(doLoad)
    {
        if (doLoad)
        {
            if (isLoaded())
                return;
            if (!c)
            {
                c = Qt.createComponent(source);
                if (c.status !== Component.Ready && c.status !== Component.Error)
                {
                    c.statusChanged.connect(continueLoad);
                    return;
                }
            }
            continueLoad();
        }
        else if (c)
        {
            c.destroy();
            c = null;
        }
    }

    function createObject(parent, properties)
    {
        if (!isLoaded())
            return null;
        return c.createObject(parent, properties);
    }

    // private function, do not use it
    function continueLoad()
    {
        if (!c)
            return;
        if (c.status !== Component.Ready)
        {
            if (c.status === Component.Error)
                console.error(c.errorString());
            return;
        }
        if (isLoaded())
            loaded();
    }

    function reload()
    {
        load(false);
        load(true);
    }

    onActiveChanged: load(active)

    onSourceChanged: {
        if (active)
            reload();
    }

    Component.onCompleted: {
        if (active)
            load(true);
    }
}
