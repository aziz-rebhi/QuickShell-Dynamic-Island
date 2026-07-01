pragma Singleton
import QtQuick
QtObject {
  property color background: "#13121c"
  property color surface: "#13121c"
  property color surfaceBright: "#393843"
  property color surfaceDim: "#13121c"
  property color surfaceContainer: "#201e29"
  property color surfaceVariant: "#474551"
  property color primary: "#c6bfff"
  property color primaryFg: "#2700a0"
  property color secondary: "#d1bfe7"
  property color tertiary: "#e1b9ed"
  property color backgroundFg: "#e5e0ef"
  property color surfaceFg: "#e5e0ef"
  property color surfaceVariantFg: "#c8c4d3"
  property color outline: "#928f9c"
  property color outlineVariant: "#474551"
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
