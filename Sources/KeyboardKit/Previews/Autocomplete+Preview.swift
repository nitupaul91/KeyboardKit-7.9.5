//
//  Autocomplete+Preview.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2023-06-09.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension AutocompleteContext {

    /// This context can be used in SwiftUI previews.
    static var preview: AutocompleteContext = {
        let context = AutocompleteContext()
        context.suggestions = .preview
        return context
    }()
}

public extension AutocompleteProvider where Self == PreviewAutocompleteProvider {

    /// This provider can be used in SwiftUI previews.
    static var preview: AutocompleteProvider {
        preview()
    }

    /// This provider can be used in SwiftUI previews.
    static func preview(
        suggestions: [AutocompleteSuggestion] = .preview
    ) -> AutocompleteProvider {
        PreviewAutocompleteProvider(suggestions: suggestions)
    }
}

/// This provider can be used in SwiftUI previews.
public class PreviewAutocompleteProvider: AutocompleteProvider {

    public init(
        suggestions: [AutocompleteSuggestion]
    ) {
        self.suggestions = suggestions
    }
    
    public var locale: Locale = .current
    public let suggestions: [AutocompleteSuggestion]

    public func autocompleteSuggestions(
        for text: String,
        completion: Completion
    ) {
        completion(.success(suggestions))
    }
    
    public var canIgnoreWords: Bool { false }
    public var canLearnWords: Bool { false }
    public var ignoredWords: [String] = []
    public var learnedWords: [String] = []
    
    public func hasIgnoredWord(_ word: String) -> Bool { false }
    public func hasLearnedWord(_ word: String) -> Bool { false }
    public func ignoreWord(_ word: String) {}
    public func learnWord(_ word: String) {}
    public func removeIgnoredWord(_ word: String) {}
    public func unlearnWord(_ word: String) {}
}

public extension Collection where Element == AutocompleteSuggestion {
    
    /// These suggestions can be used in SwiftUI previews.
    static var preview: [AutocompleteSuggestion] {
        [
            .init(text: "One", isUnknown: true),
            .init(text: "Two", isAutocorrect: true),
            .init(text: "Three")
        ]
    }
}
