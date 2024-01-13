//
//  EmojiCategoryKeyboard.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-01-17.
//  Copyright © 2021-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This keyboard lists all emojis from a selected category, as
 well as a menu that lets the user select a new category and
 change back to an alphabetic keyboard.
 
 As long as the view requires iOS 14, the extensions must be
 kept in the main struct body for the previews to compile.
 */
public struct EmojiCategoryKeyboard: View {
    
    /**
     Create an emoji category keyboard.
     
     - Parameters:
       - selection: The currently selected category.
       - categories: The categories to show in the menu.
       - actionHandler: The action handler to use.
       - keyboardContext: The context to use when rendering the view.
       - calloutContext: The callout context to affect, if any.
       - style: The style to apply to the keyboard, by default `.standardPhonePortrait`.
       - styleProvider: The style provider to apply to the menu.
       - categoryTitle: A category title provider, by default category title.
     */
    public init(
        selection: EmojiCategory? = nil,
        categories: [EmojiCategory] = EmojiCategory.all,
        actionHandler: KeyboardActionHandler,
        keyboardContext: KeyboardContext,
        calloutContext: CalloutContext?,
        style: EmojiKeyboardStyle = .standardPhonePortrait,
        styleProvider: KeyboardStyleProvider,
        categoryTitle: @escaping CategoryTitleProvider = { $0.title }
    ) {
        self.initialSelection = selection
        self.categories = categories.filter { $0.emojis.count > 0 }
        self.actionHandler = actionHandler
        self.keyboardContext = keyboardContext
        self.calloutContext = calloutContext
        self.styleProvider = styleProvider
        self.style = style
        self.categoryTitle = categoryTitle
    }
    
    private let initialSelection: EmojiCategory?
    private let categories: [EmojiCategory]
    private let actionHandler: KeyboardActionHandler
    private let keyboardContext: KeyboardContext
    private let calloutContext: CalloutContext?
    private let style: EmojiKeyboardStyle
    private let styleProvider: KeyboardStyleProvider
    private let categoryTitle: CategoryTitleProvider
    
    @State
    private var isInitialized = false

    @State
    private var isSearchFocused = false

    @State
    private var query = ""

    @State
    private var selection = EmojiCategory.smileys
    
    
    // MARK: - Typealiases
    
    /**
     This is a typealias for a function that can be used for
     providing a title for an emoji category.
     */
    public typealias CategoryTitleProvider = (EmojiCategory) -> String

    
    // MARK: - Public Static Builders
    
    /**
     This function returns the standard title for a category.
     */
    public static func standardCategoryTitle(for category: EmojiCategory) -> String {
        category.title
    }
    

    // MARK: - Private Functions
    
    private var defaults: UserDefaults { .standard }
    
    private let defaultsKey = "com.keyboardkit.EmojiCategoryKeyboard.category"
    
    private var persistedCategory: EmojiCategory {
        let name = defaults.string(forKey: defaultsKey) ?? ""
        return categories.first { $0.rawValue == name } ?? .smileys
    }
    
    private func initialize() {
        if isInitialized { return }
        selection = initialSelection ?? persistedCategory
        isInitialized = true
    }
    
    private func saveCurrentCategory() {
        guard isInitialized else { return }
        defaults.set(selection.rawValue, forKey: defaultsKey)
    }
    
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: style.verticalCategoryStackSpacing) {
            title
            keyboard
            menu
        }
        .onAppear(perform: initialize)
        .onChange(of: selection) { _ in saveCurrentCategory() }
    }
}


// MARK: - Private View Extensions

private extension EmojiCategoryKeyboard {

    var title: some View {
        EmojiCategoryTitle(
            title: selection.title,
            style: style
        )
        .padding(.horizontal)
        .padding(style.categoryTitlePadding)
    }

    var keyboard: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            EmojiKeyboard(
                emojis: selection.emojis.matching(query, for: keyboardContext.locale),
                actionHandler: actionHandler,
                calloutContext: calloutContext,
                style: style
            )
        }.id(selection)

    }
    
    var menu: some View {
        EmojiCategoryKeyboardMenu(
            selection: $selection,
            categories: categories,
            keyboardContext: keyboardContext,
            actionHandler: actionHandler,
            style: style,
            styleProvider: styleProvider
        )
    }
}

@available(iOS 15.0, *)
struct EmojiCategoryKeyboard_Previews: PreviewProvider {

    struct Preview: View {

        var body: some View {
            EmojiCategoryKeyboard(
                selection: .smileys,
                actionHandler: .preview,
                keyboardContext: .preview,
                calloutContext: .preview,
                style: .standardPhonePortrait,
                styleProvider: .preview
            ).background(Color.standardKeyboardBackground)
        }
    }

    static var previews: some View {
        Preview()
            // .previewInterfaceOrientation(.landscapeLeft)
    }
}
