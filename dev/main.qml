import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2
import QtQuick.Layouts 1.2

import Material 0.1

ApplicationWindow {
    id: dev

    title: qsTr("DEV")

    // Necessary when loading the window from C++
    visible: true

/*
    theme {
        primaryColor: Palette.colors["blue"]["500"]
        primaryDarkColor: Palette.colors["blue"]["900"]
        accentColor: Palette.colors["blueGrey"]["400"]
        tabHighlightColor: "white"
    }
//*/

    property var sections: [ "ContentPage", "ContentPage", "ContentPage", "ContentPage" ]
    property var sectionColor: [ "blue", "red", "yellow", "green"]
    property var sectionTitles: [ "Welcome", "Edit", "Design", "Projects" ]
    property var sectionIcons: [ "image/wb_iridescent", "action/view_module", "editor/format_align_justify", "social/group" ]
    property var sectionEnabled: [ true, true, false, true ]

    initialPage: TabbedPage {
        id: page
        title: qsTr("DEV")

//        tabbarOrientation: Qt.Horizontal
        tabbarOrientation: Qt.Vertical

//        backAction: navDrawer.action

        actions: [
            Action {
                iconName: "image/color_lens"
                name: "Colors"
                onTriggered: colorPicker.show()
            }
        ]

        Repeater {
//            model: !navDrawer.enabled ? sections : 0
            model: sections

            delegate: Tab {
                title: sectionTitles[index]

                enabled: sectionEnabled[index]
                iconName: sectionIcons[index]
                property color selectedColor: sectionColor[index]
                property string selectedComponent: modelData

                sourceComponent: tabDelegate
            }
        }
    }

    Component {
        id: tabDelegate

        Item {
            Flickable {
                id: flickable
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                clip: true
                contentHeight: Math.max(page.implicitHeight + 40, height)
                Loader {
                    id: pageLoader
                    anchors.fill: parent
                    asynchronous: true
                    visible: status == Loader.Ready

                    property color itemColor: selectedColor
                    // selectedComponent will always be valid, as it defaults to the first component
                    source: {
                        console.log(selectedColor)
//                        if (navDrawer.enabled) {
//                            return Qt.resolvedUrl("%.qml").arg(page.selectedComponent.replace(" ", ""))
//                        } else {
                            return Qt.resolvedUrl("%.qml").arg(selectedComponent.replace(" ", ""))
//                        }
                    }
                }

                ProgressCircle {
                    anchors.centerIn: parent
                    visible: page.status === Loader.Loading
                }
            }
            Scrollbar {
                flickableItem: flickable
            }
        }
    }

    // copied from demo/main.qml
    Dialog {
        id: colorPicker
        title: "Pick color"

        positiveButtonText: "Done"

        MenuField {
            id: selection
            model: ["Primary color", "Accent color", "Background color"]
            width: Units.dp(160)
        }

        Grid {
            columns: 7
            spacing: Units.dp(8)

            Repeater {
                model: [
                    "red", "pink", "purple", "deepPurple", "indigo",
                    "blue", "lightBlue", "cyan", "teal", "green",
                    "lightGreen", "lime", "yellow", "amber", "orange",
                    "deepOrange", "grey", "blueGrey", "brown", "black",
                    "white"
                ]

                Rectangle {
                    width: Units.dp(30)
                    height: Units.dp(30)
                    radius: Units.dp(2)
                    color: Palette.colors[modelData]["500"]
                    border.width: modelData === "white" ? Units.dp(2) : 0
                    border.color: Theme.alpha("#000", 0.26)

                    Ink {
                        anchors.fill: parent

                        onPressed: {
                            switch(selection.selectedIndex) {
                                case 0:
                                    theme.primaryColor = parent.color
                                    break;
                                case 1:
                                    theme.accentColor = parent.color
                                    break;
                                case 2:
                                    theme.backgroundColor = parent.color
                                    break;
                            }
                        }
                    }
                }
            }
        }

        onRejected: {
            // TODO set default colors again but we currently don't know what that is
        }
    }
}

