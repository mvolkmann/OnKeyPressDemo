import SwiftUI

struct ContentView: View {
    @FocusState private var focused: Bool
    @State private var lastKey = ""
    @State private var x = 0.0
    @State private var y = 0.0

    private let arrowKeys: Set<KeyEquivalent> = [
        .leftArrow, .rightArrow, .upArrow, .downArrow
    ]

    var body: some View {
        VStack {
            Text("Press arrow keys to move the icon.")
            Text(lastKey.isEmpty ? "press a key" : "got \(lastKey)")
                // The onKeyPress modifier only works when
                // the view to which it is attached has focus.
                .focusable()
                .focused($focused)

                // The onKeyPress modifier can listen for
                // specific characters (CharacterSet),
                // keys (Set<KeyEquivalent>), or phases (KeyPress.Phases).
                // Phases include .down, .up, and .repeat.
                // By default onKeyPress listens for the down and repeat phases.

                // TODO: Why doesn't this work?
                .onKeyPress(.leftArrow) {
                    print("got left arrow")
                    return .ignored
                }

                // TODO: Why doesn't this work?
                // .onKeyPress(keys: arrowKeys) { press in

                // TODO: In iOS key repeats do not trigger this.
                .onKeyPress { press in
                    print("key =", press.key)
                    print("characters =", press.characters)

                    let commandDown = press.modifiers.contains(.command)
                    let controlDown = press.modifiers.contains(.control)
                    let optionDown = press.modifiers.contains(.option)
                    let shiftDown = press.modifiers.contains(.shift)

                    lastKey = ""
                    if commandDown { lastKey += "command-" }
                    if controlDown { lastKey += "control-" }
                    if optionDown { lastKey += "option-" }
                    if shiftDown { lastKey += "shift-" }
                    lastKey += press.characters

                    // TODO: Why can't you check for arrow keys like this?
                    // if press.key == .leftArrow {

                    if press.characters.hasSuffix("LeftArrow") {
                        x = max(0, x - 10)
                    }
                    if press.characters.hasSuffix("RightArrow") {
                        x = min(360, x + 10)
                    }
                    if press.characters.hasSuffix("UpArrow") {
                        y = max(0, y - 10)
                    }
                    if press.characters.hasSuffix("DownArrow") {
                        y = min(600, y + 10)
                    }

                    return .handled // or .ignored
                }
                .onAppear { focused = true }

            Text("x = \(x), y = \(y)")

            Image(systemName: "person.circle")
                .position(x: x, y: y)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
