//
//  DemoLayoutProvider.swift
//  Keyboard
//
//  Created by Daniel Saidi on 2022-12-21.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import KeyboardKit

/**
 This demo-specific provider inherits the standard one, then
 adds a rocket button next to the space key.

 ``KeyboardViewController`` registers this class to show you
 how you can set up a custom layout provider.
 */
class DemoLayoutProvider: StandardKeyboardLayoutProvider {

    override func keyboardLayout(for context: KeyboardContext) -> KeyboardLayout {
        let layout = super.keyboardLayout(for: context)
        layout.tryInsertRocketButton()
        return layout
    }
}

private extension KeyboardLayout {

    func tryInsertRocketButton() {
        guard let button = tryCreateBottomRowItem(for:  .character("🚀")) else { return }
        itemRows.insert(button, after: .space, atRow: bottomRowIndex)
    }
}
