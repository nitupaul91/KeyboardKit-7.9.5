//
//  File.swift
//
//
//  Created by Paul Nitu on 14.01.2024.
//

import Foundation
/**
 This keyboard layout provider implementation can be used to
 create standard English keyboard layouts.
 */
open class SpanishKeyboardLayoutProvider: SystemKeyboardLayoutProvider, KeyboardLayoutProviderProxy, LocalizedService {

    /**
     Create an English keyboard layout provider.
     */
    public override init(
        alphabeticInputSet: AlphabeticInputSet = .spanish,
        numericInputSet: NumericInputSet = .standardNumeric(currency: "€"),
        symbolicInputSet: SymbolicInputSet = .standardSymbolic(currencies: ["€", "$", "£", "¥"])
    ) {
        super.init(
            alphabeticInputSet: alphabeticInputSet,
            numericInputSet: numericInputSet,
            symbolicInputSet: symbolicInputSet
        )
    }
    
    @available(*, deprecated, message: "Use the input set-based initializer instead.")
    public override init(inputSetProvider: InputSetProvider) {
        super.init(inputSetProvider: inputSetProvider)
    }

    /**
     The locale identifier.
     */
    public var localeKey = KeyboardLocale.german.id

    /**
     The layout provider to use for iPad devices.
     */
    public lazy var iPadProvider: KeyboardLayoutProvider = iPadKeyboardLayoutProvider(
        alphabeticInputSet: alphabeticInputSet,
        numericInputSet: numericInputSet,
        symbolicInputSet: symbolicInputSet
    )

    /**
     The layout provider to use for iPhone devices.
     */
    public lazy var iPhoneProvider: KeyboardLayoutProvider = iPhoneKeyboardLayoutProvider(
        alphabeticInputSet: alphabeticInputSet,
        numericInputSet: numericInputSet,
        symbolicInputSet: symbolicInputSet
    )

    /**
     The layout keyboard to use for a given keyboard context.
     */
    open override func keyboardLayout(for context: KeyboardContext) -> KeyboardLayout {
        keyboardLayoutProvider(for: context)
            .keyboardLayout(for: context)
    }
}
