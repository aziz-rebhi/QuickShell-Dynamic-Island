import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
  id: root

  property string pendingSsid: ""
  property string connectError: ""
  property bool connecting: false

  signal dismiss()
  signal connectRequested(string ssid, string password)

  Rectangle {
    anchors.fill: parent
    visible: root.visible
    color: "#000"
    opacity: 0.5

    MouseArea { anchors.fill: parent; onClicked: root.dismiss() }
  }

  Rectangle {
    visible: root.visible
    anchors.centerIn: parent
    width: 320
    height: pwCol.implicitHeight + 32
    radius: 18
    color: "#101a17"
    border.color: "#1a2421"
    border.width: 1

    ColumnLayout {
      id: pwCol
      anchors.fill: parent
      anchors.margins: 16
      spacing: 10

      Text {
        text: "Connect to " + root.pendingSsid
        color: "#fff"
        font { family: "Inter"; pixelSize: 14; weight: 700 }
        Layout.fillWidth: true
        elide: Text.ElideRight
      }

      Rectangle {
        Layout.fillWidth: true
        height: 40
        radius: 10
        color: "#1a2421"

        TextField {
          id: pwField
          anchors.fill: parent
          anchors.margins: 4
          color: "#fff"
          echoMode: revealBtn.checked ? TextInput.Normal : TextInput.Password
          placeholderText: "Password"
          placeholderTextColor: "#888"
          background: null
          font { family: "Inter"; pixelSize: 13 }
        }
      }

      RowLayout {
        Layout.fillWidth: true
        CheckBox {
          id: revealBtn
          text: "Show password"
          contentItem: Text { text: revealBtn.text; color: "#eae6dc"; opacity: 0.7; leftPadding: revealBtn.indicator.width + 6; font { family: "Inter"; pixelSize: 11 } }
        }
      }

      Text {
        visible: root.connectError.length > 0
        text: root.connectError
        color: "#e06c75"
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
        font { family: "Inter"; pixelSize: 11 }
      }

      RowLayout {
        Layout.fillWidth: true
        spacing: 10
        Layout.topMargin: 4

        Rectangle {
          Layout.fillWidth: true
          height: 36
          radius: 10
          color: "#1a2421"
          Text { anchors.centerIn: parent; text: "Cancel"; color: "#eae6dc"; font { family: "Inter"; pixelSize: 12; weight: 600 } }
          MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: { root.dismiss(); pwField.text = ""; } }
        }
        Rectangle {
          Layout.fillWidth: true
          height: 36
          radius: 10
          color: "#3ba889"
          Text { anchors.centerIn: parent; text: root.connecting ? "Connecting…" : "Connect"; color: "#000"; font { family: "Inter"; pixelSize: 12; weight: 700 } }
          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            enabled: !root.connecting
            onClicked: {
              root.connectRequested(root.pendingSsid, pwField.text);
            }
          }
        }
      }
    }
  }
}
