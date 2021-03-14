import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15


ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: qsTr("Docking Example")

    Item {
        anchors { centerIn: parent }
        Label {
            anchors.centerIn: parent
            text: "Content"
            font.pointSize: 48
        }
    }

    Dockable {
        title: qsTr("Dockable A")
        contents: Label {
            anchors.centerIn: parent
            text: "A"
            font.pointSize: 48
        }
    }
    Dockable {
        title: qsTr("Dockable B")
        contents: Label {
            anchors.centerIn: parent
            text: "B"
            font.pointSize: 48
        }
    }
    Dockable {
        title: qsTr("Dockable C")
        contents: Label {
            anchors.centerIn: parent
            text: "C"
            font.pointSize: 48
        }
    }
}
