# fdm-qml-ui
Create your custom user interfaces for Free Download Manager 6, or make improvements for existing ones and share your work with all FDM6 users.

FDM6 supports loading of custom interfaces and uses the special command line argument for this.

1. Clone this repository.

2. Make your changes.

3. Test your changes by launching FDM6 using the following parameters:

    fdm --qurl file:///PATH_TO_MAIN_QML_INSIDE_OF_LOCAL_REPOSITORY

    E.g. for Windows OS, this could be:
    fdm.exe --qurl file:///C:/fdm-qml-ui/qml_ui/desktop/main.qml

4. Share your changes with all FDM6 users on our forum or by creating pull requests to our main repository.

We'll publish some documentation regarding FDM's API used in the UI code if it's interesting for our users.

We use [QML](https://doc.qt.io/qt-5/qtqml-index.html). Not familiar with QML? Please read [this book](https://qmlbook.github.io/).

If there are any issues, please [visit our forum's topic](https://www.freedownloadmanager.org/board/viewtopic.php?f=1&t=18517).

Known issue: currently there is no way to launch FDM6 with custom interface under Android. Please let us know if you're interested in this.