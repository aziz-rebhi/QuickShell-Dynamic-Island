import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ScrollView {
  id: sv
  padding: 0
  ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
  ScrollBar.vertical.policy: ScrollBar.AsNeeded
  contentWidth: width

  property bool wifiEnabled: false
  property string wifiName: ""
  property string wifiSecurity: ""
  property var wifiNetworks: []
  property bool wifiScanning: false
  property bool wifiConnecting: false
  property string wifiQrPath: ""
  property string wifiCurrentPassword: ""
  property bool wifiPasswordRevealed: false

  signal toggleWifi()
  signal scanWifi()
  signal connectToWifi(string ssid, string security, string password)
  signal loadCurrentWifiPassword()
  signal backRequested()
  signal disconnectWifi()
  signal generateWifiQr()
  signal showQrCode(string path)
  signal requestPassword(string ssid)

  ColumnLayout {
    width: parent.width
    spacing: 10

    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 52
      radius: 14
      color: "#1a2421"

      RowLayout {
        anchors.fill: parent
        anchors.margins: 14
        Text { text: "Wi-Fi"; color: "#eae6dc"; font { family: "Inter"; pixelSize: 14; weight: 700 } }
        Item { Layout.fillWidth: true }
        Rectangle {
          width: 46; height: 26; radius: 13
          color: wifiEnabled ? "#3ba889" : "#33403c"
          Rectangle {
            width: 20; height: 20; radius: 10; color: "#fff"
            anchors.verticalCenter: parent.verticalCenter
            x: wifiEnabled ? parent.width - width - 3 : 3
            Behavior on x { NumberAnimation { duration: 120 } }
          }
          MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: toggleWifi() }
        }
      }
    }

    Rectangle {
      Layout.fillWidth: true
      visible: wifiEnabled && wifiName !== "No network" && wifiName !== "Off"
      Layout.preferredHeight: connectedCol.implicitHeight + 28
      radius: 16
      color: "#13201c"
      border.color: "#3ba889"
      border.width: 1

      ColumnLayout {
        id: connectedCol
        anchors.fill: parent
        anchors.margins: 14
        spacing: 8

        RowLayout {
          Layout.fillWidth: true
          Text { text: ""; color: "#3ba889"; font { family: "JetBrainsMono Nerd Font"; pixelSize: 16 } }
          ColumnLayout {
            spacing: 0
            Layout.fillWidth: true
            Text { text: wifiName; color: "#fff"; font { family: "Inter"; pixelSize: 14; weight: 700 } }
            Text { text: "Connected"; color: "#3ba889"; font { family: "Inter"; pixelSize: 11 } }
          }
          Item { Layout.fillWidth: true }
          Text {
            text: "Disconnect"
            color: "#eae6dc"; opacity: 0.7
            font { family: "Inter"; pixelSize: 11; weight: 600 }
            MouseArea { anchors.fill: parent; anchors.margins: -6; cursorShape: Qt.PointingHandCursor; onClicked: disconnectWifi() }
          }
        }

        RowLayout {
          Layout.fillWidth: true
          visible: wifiCurrentPassword.length > 0
          spacing: 8

          Text { text: "Password:"; color: "#eae6dc"; opacity: 0.7; font { family: "Inter"; pixelSize: 12 } }
          Text {
            text: wifiPasswordRevealed ? wifiCurrentPassword : "•".repeat(Math.max(6, wifiCurrentPassword.length))
            color: "#fff"
            font { family: "JetBrainsMono Nerd Font"; pixelSize: 12 }
            Layout.fillWidth: true
          }
          Text {
            text: wifiPasswordRevealed ? "󰋭" : "󰋬"
            color: "#eae6dc"
            font { family: "JetBrainsMono Nerd Font"; pixelSize: 14 }
            MouseArea {
              anchors.fill: parent; anchors.margins: -8
              cursorShape: Qt.PointingHandCursor
              onClicked: {
                wifiPasswordRevealed = !wifiPasswordRevealed;
                if (wifiPasswordRevealed && !wifiQrPath) generateWifiQr();
              }
            }
          }
        }

        Image {
          visible: wifiPasswordRevealed && wifiQrPath.length > 0
          source: wifiQrPath
          Layout.preferredWidth: 140
          Layout.preferredHeight: 140
          Layout.alignment: Qt.AlignHCenter
          fillMode: Image.PreserveAspectFit
          smooth: false
        }

        Text {
          visible: wifiPasswordRevealed && wifiCurrentPassword.length === 0
          text: "No saved password found for this network."
          color: "#eae6dc"; opacity: 0.5
          font { family: "Inter"; pixelSize: 11 }
        }
      }
    }

    RowLayout {
      Layout.fillWidth: true
      Layout.topMargin: 4
      Text { text: "Networks"; color: "#eae6dc"; opacity: 0.7; font { family: "Inter"; pixelSize: 12; weight: 700 } }
      Item { Layout.fillWidth: true }
      Text {
        text: wifiScanning ? "Scanning…" : "Refresh"
        color: "#3ba889"
        font { family: "Inter"; pixelSize: 11; weight: 600 }
        MouseArea { anchors.fill: parent; anchors.margins: -6; cursorShape: Qt.PointingHandCursor; onClicked: scanWifi() }
      }
    }

    Repeater {
      model: wifiNetworks

      delegate: Rectangle {
        required property var modelData
        Layout.fillWidth: true
        Layout.preferredHeight: 52
        radius: 14
        color: modelData.active ? "#16241f" : "#1a2421"

        RowLayout {
          anchors.fill: parent
          anchors.margins: 14
          spacing: 10

          Text {
            text: modelData.signal > 66 ? "" : modelData.signal > 33 ? "" : ""
            color: "#eae6dc"
            font { family: "JetBrainsMono Nerd Font"; pixelSize: 15 }
          }

          ColumnLayout {
            spacing: 0
            Layout.fillWidth: true
            Text { text: modelData.ssid; color: "#fff"; elide: Text.ElideRight; Layout.fillWidth: true; font { family: "Inter"; pixelSize: 13; weight: 600 } }
            Text {
              text: modelData.active ? "Connected" : (modelData.security && modelData.security !== "--" ? "Secured" : "Open")
              color: modelData.active ? "#3ba889" : "#eae6dc"
              opacity: modelData.active ? 1 : 0.6
              font { family: "Inter"; pixelSize: 10 }
            }
          }

          Text {
            visible: modelData.security && modelData.security !== "--"
            text: "󰲛"
            color: "#eae6dc"; opacity: 0.5
            font { family: "JetBrainsMono Nerd Font"; pixelSize: 13 }
          }
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            if (modelData.active) return;
            if (modelData.security && modelData.security !== "--") {
              requestPassword(modelData.ssid);
            } else {
              connectToWifi(modelData.ssid, modelData.security || "", "");
            }
          }
        }
      }
    }

    Text {
      visible: wifiNetworks.length === 0 && !wifiScanning
      text: "No networks found"
      color: "#eae6dc"; opacity: 0.4
      Layout.alignment: Qt.AlignHCenter
      Layout.topMargin: 12
      font { family: "Inter"; pixelSize: 12 }
    }

    Item { Layout.preferredHeight: 4 }
  }
}
