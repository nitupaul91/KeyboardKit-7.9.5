//
//  EmojiCategoryKeyboardMenu.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-01-17.
//  Copyright © 2021-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 [DEPRECATED] This will be made internal in KeyboardKit 8.0.
 
 This menu can be used to list a set of emoji categories and
 let each category button toggle a category selection.
 
 The menu buttons are also surrounded by a keyboard switcher
 and a backspace.
 
 As long as the view requires iOS 14, the extensions must be
 kept in the main struct body for the previews to compile.
 */
public struct EmojiCategoryKeyboardMenu: View {
    
    /**
     Create an emoji category keyboard menu.
     
     - Parameters:
       - selection: The current selection.
       - categories: The categories to include in the menu.
       - keyboardContext: The context to bind the buttons to.
       - actionHandler: The action handler to use, by default the shared one.
       - style: The style to apply to the menu.
       - styleProvider: The style provider to apply to the menu.
     */
    public init(
        selection: Binding<EmojiCategory>,
        categories: [EmojiCategory] = EmojiCategory.all,
        keyboardContext: KeyboardContext,
        actionHandler: KeyboardActionHandler,
        style: EmojiKeyboardStyle,
        styleProvider: KeyboardStyleProvider
    ) {
        self.categories = categories.filter { $0.emojis.count > 0 }
        self.keyboardContext = keyboardContext
        self.actionHandler = actionHandler
        self._selection = selection
        self.style = style
        self.styleProvider = styleProvider
    }

    @Binding
    private var selection: EmojiCategory
    
    private let categories: [EmojiCategory]
    private let keyboardContext: KeyboardContext
    private let actionHandler: KeyboardActionHandler
    private let style: EmojiKeyboardStyle
    private let styleProvider: KeyboardStyleProvider
    
    @State
    private var isInitialized = false
        
    public var body: some View {
        HStack(spacing: 0) {
            Spacer()
            keyboardSwitchButton.font(style.abcFont)
            Spacer()
            buttonList.font(style.categoryEmojiFont)
            Spacer()
            backspaceButton.font(style.backspaceFont)
            Spacer()
        }
    }
    
    
    // MARK: - Private Extensions
    
    private var backspaceButton: some View {
        let action = KeyboardAction.backspace
        let image = styleProvider.buttonImage(for: action)
        return image.keyboardButtonGestures(
            for: action,
            actionHandler: actionHandler,
            calloutContext: nil
        ).scaledToFill()
    }
    
    private var keyboardSwitchButton: some View {
        let action = KeyboardAction.keyboardType(.alphabetic(.lowercased))
        let text = styleProvider.buttonText(for: action) ?? "ABC"
        return Text(text).keyboardButtonGestures(
            for: action,
            actionHandler: actionHandler,
            calloutContext: nil
        ).scaledToFill()
    }
    
    private var buttonList: some View {
        ForEach(categories) {
            buttonListItem(for: $0)
        }
    }
    
    private func buttonListItem(for category: EmojiCategory) -> some View {
        Button(action: { selection = category }, label: {
            Text(category.fallbackDisplayEmoji.char)
                .padding(6)
                .background(selection == category ? style.selectedCategoryColor : Color.clear)
                .clipShape(Circle())
                .padding(.vertical, 5)
        }).buttonStyle(.plain)
    }
}

struct EmojiCategoryKeyboardMenu_Previews: PreviewProvider {
    
    static var previews: some View {
        EmojiCategoryKeyboardMenu(
            selection: .constant(.activities),
            categories: .all,
            keyboardContext: .preview,
            actionHandler: .preview,
            style: .standardPhonePortrait,
            styleProvider: .preview
        ).background(Color.gray)
    }
}
