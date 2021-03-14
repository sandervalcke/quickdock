import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15


ApplicationWindow {
    visible: true
    width: 800
    height: 800
    title: qsTr("Docking Example")

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#222222"
    }

    Item {
        id: ribbon

        width:  0.9 * parent.width
        height: 80
        y: ribbonSearch.height - height + 10
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            id: ribbonBackground
            anchors.fill: parent
            color: "#333333"
            opacity: 0.1
            radius: 10

            Behavior on opacity { NumberAnimation { duration: 100 } }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: ribbon.state = "shown";
            }
        }

        Behavior on y { NumberAnimation { duration: 100 } }

        TextField {
            id: ribbonSearch
            hoverEnabled: true
            placeholderText: "Search command..."
            anchors.right: parent.right
            opacity: focus || ribbon.state === "shown" ? 0.8 : 0.2
            y: - ribbon.y + 10

            onTextEdited: {
                print("text:", text, text.length, text.length >= 0);
                if (text.length > 0)
                    ribbon.state = "shown";
                else
                    ribbon.state = "";
            }
        }

        states: [
            State {
                name: "shown"
                PropertyChanges {
                    target: ribbonBackground; opacity: 1.
                }
                PropertyChanges {
                    // 5 to hide the top rounded corners
                    target: ribbon; y: 10
                }
            }
        ]
    }

    Item {
        anchors { centerIn: parent }
        Label {
            anchors.centerIn: parent
            text: "Content"
            font.pointSize: 48
        }
    }

    Dockable {
        x: 300
        y: 75

        title: qsTr("Dockable A")
        contents: Label {
            anchors.centerIn: parent
            text: "A"
            font.pointSize: 48
        }
    }
    Dockable {
        title: qsTr("Dockable B")
        x: 50
        y: 400
        contents: Label {
            anchors.centerIn: parent
            text: "B"
            font.pointSize: 48
        }
    }
    Dockable {
        y: 150
        title: qsTr("Dockable C")
        contents: Label {
            anchors.centerIn: parent
            text: "C"
            font.pointSize: 48
        }
    }
}
