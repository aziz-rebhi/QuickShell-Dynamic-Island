pragma Singleton
import QtQuick
QtObject {
  property color background: "#151218"
  property color surface: "#151218"
  property color surfaceBright: "#3b383e"
  property color surfaceDim: "#151218"
  property color surfaceContainer: "#211e24"
  property color surfaceVariant: "#49454e"
  property color primary: "#d5bbfc"
  property color primaryFg: "#3a255b"
  property color secondary: "#cec2db"
  property color tertiary: "#f1b7c3"
  property color backgroundFg: "#e7e0e8"
  property color surfaceFg: "#e7e0e8"
  property color surfaceVariantFg: "#cbc4cf"
  property color outline: "#958e99"
  property color outlineVariant: "#49454e"
  property color error: "#ffb4ab"
  property color accent: primary
  property color surfaceLight: surfaceVariant
  property color surfaceHover: surfaceBright
  property color container: surfaceContainer
  property color text: backgroundFg
  property color muted: outline
  property color subtext: surfaceVariantFg
  property color border: outlineVariant
  property color warning: tertiary
  property color success: primary
  property color danger: error
  property color overlay: "#00000099"
}
