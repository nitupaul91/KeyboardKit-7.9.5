//
//  SystemKeyboardLayoutProvider.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-02-02.
//  Copyright © 2021-2023 Daniel Saidi. All rights reserved.
//

import CoreGraphics
import SwiftUI

/**
 This is a base class for any keyboard layout providers that
 need basic functionality for system keyboard layouts.

 The class is used by the ``iPadKeyboardLayoutProvider`` and
 and the ``iPhoneKeyboardLayoutProvider``, since they aim to
 create platforms-specific system keyboard layouts.
 
 Since keyboard extensions don't support `dictation` without
 having to jump through hoops (see SwiftKey) the initializer
 has a `dictationReplacement` parameter, that can be used to
 place another action where the dictation key would go.
 
 If you want to create an entirely custom layout, you should
 just implement `KeyboardLayoutProvider`.
 */
open class SystemKeyboardLayoutProvider: KeyboardLayoutProvider {
    
    /**
     Create a system keyboard layout provider.
     
     - Parameters:
       - alphabeticInputSet: The alphabetic input set to use.
       - numericInputSet: The numeric input set to use.
       - symbolicInputSet: The symbolic input set to use.
     */
    public init(
        alphabeticInputSet: AlphabeticInputSet,
        numericInputSet: NumericInputSet,
        symbolicInputSet: SymbolicInputSet
    ) {
        self.alphabeticInputSet = alphabeticInputSet
        self.numericInputSet = numericInputSet
        self.symbolicInputSet = symbolicInputSet
    }
    
    @available(*, deprecated, message: "Use the input set-based initializer instead")
    public init(inputSetProvider: InputSetProvider) {
        self.inputSetProvider = inputSetProvider
        self.alphabeticInputSet = inputSetProvider.alphabeticInputSet
        self.numericInputSet = inputSetProvider.numericInputSet
        self.symbolicInputSet = inputSetProvider.symbolicInputSet
    }
    
    
    /// The alphabetic input set to use.
    public private(set) var alphabeticInputSet: AlphabeticInputSet
    
    /// The numeric input set to use.
    public private(set) var numericInputSet: NumericInputSet
    
    /// The symbolic input set to use.
    public private(set) var symbolicInputSet: SymbolicInputSet
    
    @available(*, deprecated, message: "Use the input set properties instead")
    public var inputSetProvider: InputSetProvider = EnglishInputSetProvider()
    
    
    /**
     Get a keyboard layout for a certain keyboard `context`.
     */
    open func keyboardLayout(for context: KeyboardContext) -> KeyboardLayout {
        let inputs = self.inputRows(for: context)
        let actions = self.actions(for: inputs, context: context)
        let items = self.items(for: actions, context: context)
        return KeyboardLayout(itemRows: items)
    }

    @available(*, deprecated, message: "Use input sets directly instead.")
    open func register(inputSetProvider: InputSetProvider) {
        self.inputSetProvider = inputSetProvider
        self.alphabeticInputSet = inputSetProvider.alphabeticInputSet
        self.numericInputSet = inputSetProvider.numericInputSet
        self.symbolicInputSet = inputSetProvider.symbolicInputSet
    }
    
    
    // MARK: - Overridable helper functions
    
    /**
     Get keyboard actions for the `inputs` and `context`.
     */
    open func actions(
        for rows: InputSetRows,
        context: KeyboardContext
    ) -> KeyboardAction.Rows {
        let characters = actionCharacters(for: rows, context: context)
        return .init(characters: characters)
    }
    
    /**
     Get actions characters for the `inputs` and `context`.
     */
    open func actionCharacters(
        for rows: InputSetRows,
        context: KeyboardContext
    ) -> [[String]] {
        switch context.keyboardType {
        case .alphabetic(let casing): return rows.characters(for: casing)
        default: return rows.characters()
        }
    }
    
    /**
     Get input set rows for the provided `context`.
     */
    open func inputRows(for context: KeyboardContext) -> InputSetRows {
        switch context.keyboardType {
        case .numeric: return numericInputSet.rows
        case .symbolic: return symbolicInputSet.rows
        default: return alphabeticInputSet.rows
        }
    }
    
    /**
     Get layout item rows for the `actions` and `context`.
     */
    open func items(
        for actions: KeyboardAction.Rows,
        context: KeyboardContext
    ) -> KeyboardLayoutItem.Rows {
        actions.enumerated().map { row in
            row.element.enumerated().map { action in
                item(for: action.element, row: row.offset, index: action.offset, context: context)
            }
        }
    }
    
    /**
     Get a layout item for the provided parameters.
     */
    open func item(for action: KeyboardAction, row: Int, index: Int, context: KeyboardContext) -> KeyboardLayoutItem {
        let size = itemSize(for: action, row: row, index: index, context: context)
        let insets = itemInsets(for: action, row: row, index: index, context: context)
        return KeyboardLayoutItem(action: action, size: size, insets: insets)
    }
    
    /**
     Get layout item insets for the provided parameters.
     */
    open func itemInsets(for action: KeyboardAction, row: Int, index: Int, context: KeyboardContext) -> EdgeInsets {
        let config = KeyboardLayoutConfiguration.standard(for: context)
        switch action {
        case .characterMargin, .none: return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        default: return config.buttonInsets
        }
    }
    
    /**
     Get a layout item size for the provided parameters.
     */
    open func itemSize(
        for action: KeyboardAction,
        row: Int,
        index: Int,
        context: KeyboardContext
    ) -> KeyboardLayoutItem.Size {
        let width = itemSizeWidth(for: action, row: row, index: index, context: context)
        let height = itemSizeHeight(for: action, row: row, index: index, context: context)
        return KeyboardLayoutItem.Size(width: width, height: height)
    }
    
    /**
     Get a layout item height for the provided parameters.
     */
    open func itemSizeHeight(
        for action: KeyboardAction,
        row: Int,
        index: Int,
        context: KeyboardContext
    ) -> CGFloat {
        let config = KeyboardLayoutConfiguration.standard(for: context)
        return config.rowHeight
    }
    
    /**
     Get a layout item width for the provided parameters.
     */
    open func itemSizeWidth(
        for action: KeyboardAction,
        row: Int,
        index: Int,
        context: KeyboardContext
    ) -> KeyboardLayoutItem.Width {
        switch action {
        case .character: return .input
        case .backspace:
            if context.hasKeyboardLocale(.ukrainian) || context.hasKeyboardLocale(.russian) { return .input } else { return .available}
        case .shift(currentCasing: .auto):
            if context.hasKeyboardLocale(.ukrainian) || context.hasKeyboardLocale(.russian) { return .input } else { return .available}
        default: return .available
        }
    }
    
    /**
     The return action to use for the provided `context`.
     */
    open func keyboardReturnAction(for context: KeyboardContext) -> KeyboardAction {
        #if os(iOS) || os(tvOS)
        let proxy = context.textDocumentProxy
        let returnType = proxy.returnKeyType?.keyboardReturnKeyType
        if let returnType { return .primary(returnType) }
        #endif
        return .primary(.return)
    }
    
    /**
     The keyboard switch action that should be on the bottom
     input row, which is the row above the bottommost row.
     */
    open func keyboardSwitchActionForBottomInputRow(for context: KeyboardContext) -> KeyboardAction? {
        switch context.keyboardType {
        case .alphabetic(let casing): return .shift(currentCasing: casing)
        case .numeric: return .keyboardType(.symbolic)
        case .symbolic: return .keyboardType(.numeric)
        default: return .shift(currentCasing: .lowercased)
        }
    }
    
    /**
     The keyboard switch action that should be on the bottom
     keyboard row, which is the row with the space button.
     */
    open func keyboardSwitchActionForBottomRow(for context: KeyboardContext) -> KeyboardAction? {
        switch context.keyboardType {
        case .alphabetic: return .keyboardType(.numeric)
        case .numeric: return .keyboardType(.alphabetic(.auto))
        case .symbolic: return .keyboardType(.alphabetic(.auto))
        default: return .keyboardType(.numeric)
        }
    }
}
