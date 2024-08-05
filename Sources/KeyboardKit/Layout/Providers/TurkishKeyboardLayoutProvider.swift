//
//  File.swift
//  
//
//  Created by Paul Nitu on 05.08.2024.
//

import Foundation

open class TurkishKeyboardLayoutProvider: SystemKeyboardLayoutProvider, KeyboardLayoutProviderProxy, LocalizedService {

    /**
     Create a Turkish keyboard layout provider.
     */
    public override init(
        alphabeticInputSet: AlphabeticInputSet = .turkish,
        numericInputSet: NumericInputSet = .standardNumeric(currency: "₺"),
        symbolicInputSet: SymbolicInputSet = .turkishSymbolic
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
    public var localeKey = KeyboardLocale.turkish.id

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
