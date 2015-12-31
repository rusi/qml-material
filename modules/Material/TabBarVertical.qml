/*
 * QML Material - An application framework implementing Material Design.
 * Copyright (C) 2015 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.4
import QtQuick.Layouts 1.1

import Material 0.1
import Material.ListItems 0.1

Item {
    id: tabBar

    property bool centered: false

    property var tabs: []
    property int leftKeyline

    property int selectedIndex: 0

    property bool darkBackground

    property color highlightColor: Theme.tabHighlightColor
    property color textColor: darkBackground ? Theme.dark.textColor : Theme.light.accentColor

    property bool isTabView: String(tabs).indexOf("TabView") != -1

    visible: isTabView ? tabs.count > 0 : tabs.length > 0

    height: Units.dp(48)

    Item {
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: centered ? undefined : parent.left
            leftMargin: 0
            horizontalCenter: centered ? parent.horizontalCenter : undefined
        }

        width: tabCol.width

        Column {
            id: tabCol

            width: parent.width

            Repeater {
                id: repeaterCol
                model: isTabView ? tabs.count : tabs
                delegate: tabDelegate
            }
        }

        Rectangle {
            id: selectionIndicator
            anchors {
                left: parent.left
            }

            color: tabBar.highlightColor
            x: 0
            y: tabCol.children[tabBar.selectedIndex].y
            width: Units.dp(3)
            height: tabCol.children[tabBar.selectedIndex].height

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }

            Behavior on y {
                NumberAnimation { duration: 200 }
            }

            Behavior on height {
                NumberAnimation { duration: 200 }
            }
        }
    }

    Component {
        id: tabDelegate

        View {
            id: tabItem

            width: Units.dp(80)
            height: width

            property bool selected: index == tabBar.selectedIndex

            property var tab: isTabView ? tabs.getTab(index) : modelData

            Ink {
                anchors.fill: parent
                enabled: tab.enabled
                onClicked: tabBar.selectedIndex = index
            }

            Column {
                id: col

                anchors.centerIn: parent
                spacing: Units.dp(10)

                Icon {
                    anchors.horizontalCenter: parent.horizontalCenter

                    source: tabItem.tab.hasOwnProperty("iconSource")
                            ? tabItem.tab.iconSource : tabItem.tab.hasOwnProperty("iconName")
                            ? "icon://" + tabItem.tab.iconName : ""
                    color: tabItem.selected
                            ? darkBackground ? Theme.dark.iconColor : Theme.light.accentColor
                            : darkBackground ? Theme.dark.shade(tab.enabled ? 0.6 : 0.2) : Theme.light.shade(tab.enabled ? 0.6 : 0.2)

                    visible: source != "" && source != "icon://"

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Label {
                    id: label

                    text: typeof(tabItem.tab) == "string"
                            ? tabItem.tab : tabItem.tab.title
                    color: tabItem.selected
                            ? darkBackground ? Theme.dark.textColor : Theme.light.accentColor
                            : darkBackground ? Theme.dark.shade(tab.enabled ? 0.6 : 0.2) : Theme.light.shade(tab.enabled ? 0.6 : 0.2)

                    style: "body2"
                    font.capitalization: Font.AllUppercase
                    anchors.horizontalCenter: parent.horizontalCenter
                    maximumLineCount: 2

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
            }
        }
    }
}
