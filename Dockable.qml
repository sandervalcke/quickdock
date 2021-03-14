import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.12


Item {
    id: root
    default property alias contents: placeholder.data
    property alias title: titleLabel.text

    implicitWidth:  content.implicitWidth
    implicitHeight: content.implicitHeight

    // Dragged window always on top
    z: dragMouseArea.pressed && content.state === "docked" ? 1 : 0

    ColumnLayout {
        id: content
        width:  250
        state: "docked"

        spacing: 0

        opacity: dragMouseArea.pressed ? 0.5 : 1
        Behavior on opacity { NumberAnimation { duration: 100 } }

        ToolBar {
            id: toolBar

            Layout.fillWidth: true
            Label {
                id: titleLabel
                anchors { left: parent.left; leftMargin: 8; verticalCenter: parent.verticalCenter }
            }
            MouseArea {
                id: dragMouseArea
                anchors.fill: parent
                property point clickPos: Qt.point(1,1)

                onPressed: {
                    clickPos = Qt.point(mouse.x,mouse.y)
                }

                onPositionChanged: {
                    const delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)

                    if (content.state === "docked")
                    {
                        root.x = Math.max(0,
                                          Math.min(root.parent.width - content.width,
                                                   root.x + delta.x));
                        // Clip to toolBar height to allow putting the actual content
                        // area out of sight, if it's very long this could be desired...?
                        // If we don't allow this we need to adjust window position on unminimize,
                        // the content could be going over the lower border
                        root.y = Math.max(0,
                                          Math.min(root.parent.height - toolBar.height,
                                                   root.y + delta.y));
                    } else
                    {
                        const new_x = window.x + delta.x;
                        const new_y = window.y + delta.y;
                        window.x = new_x;
                        window.y = new_y;
                    }
                }
            }

            Row {
                anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 8 }
                ToolButton {
                    text: "_"
                    onClicked: {
                        placeholder.visible = ! placeholder.visible
                    }
                }

                ToolButton {
                    text: content.state == "docked" ? "U"
                                                    : "D"
                    onClicked: {
                        if(content.state == "docked")
                            content.state = "undocked"
                        else
                            content.state = "docked"
                    }
                }
            }
        }

        Rectangle {
            id: placeholder

            Layout.fillWidth:  true
            color: "#cfcfcf"
            Layout.preferredHeight: childrenRect.height
        }

        states: [
            State {
                name: "undocked"
                PropertyChanges { target: root; height: 0; x: 0; y: 0 }
                PropertyChanges { target: window; visible: true }
                ParentChange { target: content; parent: undockedContainer }
            },
            State {
                name: "docked"
                PropertyChanges { target: root; height: implicitHeight }
                PropertyChanges { target: window; visible: false }
                ParentChange { target: content; parent: root }
            }
        ]
    }
    Window {
        id: window
        width:  undockedContainer.childrenRect.width
        height: undockedContainer.childrenRect.height
        flags: Qt.FramelessWindowHint

        Item {
            id: undockedContainer
        }

        onClosing: {
            content.state = "docked"
        }
    }
}
