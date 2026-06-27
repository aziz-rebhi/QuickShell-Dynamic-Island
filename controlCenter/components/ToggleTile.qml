import QtQuick
import QtQuick.Layouts

Rectangle {
  id: tile
  property string iconText: ""
  property string label: ""
  property string sublabel: ""
  property bool active: false
  property bool expandable: false
  signal tapped()
  signal expandTapped()

  Layout.fillWidth: true
  Layout.preferredHeight: 56
  radius: 16
  color: active ? "#3ba889" : "#1a2421"

  Behavior on color { ColorAnimation { duration: 150 } }

  RowLayout {
    anchors.fill: parent
    anchors.margins: 12
    spacing: 10

    Rectangle {
      width: 32; height: 32; radius: 16
      color: tile.active ? "#2f8f76" : "#0a1411"

      Text {
        anchors.centerIn: parent
        text: tile.iconText
        color: tile.active ? "#eae6dc" : "#3ba889"
        font { family: "JetBrainsMono Nerd Font"; pixelSize: 14 }
      }
    }
    ColumnLayout {
      spacing: 0
      Layout.fillWidth: true
      Text {
        text: tile.label
        color: tile.active ? "#000" : "#eae6dc"
        elide: Text.ElideRight
        Layout.fillWidth: true
        font { family: "Inter"; pixelSize: 13; weight: 700 }
      }
      Text {
        text: tile.sublabel
        color: tile.active ? "#000" : "#eae6dc"
        opacity: 0.7
        elide: Text.ElideRight
        Layout.fillWidth: true
        font { family: "Inter"; pixelSize: 10 }
      }
    }
    Text {
      visible: tile.expandable
      text: "󰅂"
      color: tile.active ? "#000" : "#eae6dc"
      opacity: 0.6
      font { family: "JetBrainsMono Nerd Font"; pixelSize: 14 }
    }
  }

  MouseArea {
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: tile.expandable ? parent.width * 0.72 : parent.width
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    onClicked: tile.tapped()
  }

  MouseArea {
    visible: tile.expandable
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: parent.width * 0.28
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    onClicked: tile.expandTapped()
  }
}
