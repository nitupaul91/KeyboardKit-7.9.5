//
//  File.swift
//
//
//  Created by Paul Nitu on 12.05.2024.
//

import Foundation
import UIKit

public class RealAutocompleteProvider: AutocompleteProvider {
    
    private let textChecker = UITextChecker()
    public var locale: Locale = .current
    weak var viewController: KeyboardInputViewController?
    private var lexicon: UILexicon?
    
    public var canIgnoreWords: Bool { true }
    public var canLearnWords: Bool { true }
    public  var ignoredWords: [String] = []
    public var learnedWords: [String] = []
    
    init(viewController: KeyboardInputViewController) {
        self.viewController = viewController
        Task {
         await requestLexicon()
        }
    }
    
    private func requestLexicon() async {
       let lexicon = await viewController?.requestSupplementaryLexicon()
        self.lexicon = lexicon
    }
    
    // Check if a word has been ignored
    public func hasIgnoredWord(_ word: String) -> Bool {
        return ignoredWords.contains(word)
    }
    
    // Check if a word has been learned
    public func hasLearnedWord(_ word: String) -> Bool {
        return UITextChecker.hasLearnedWord(word)
    }
    
    // Ignore a specific word
    public func ignoreWord(_ word: String) {
        ignoredWords.append(word)
    }
    
    // Learn a new word
    public func learnWord(_ word: String) {
        UITextChecker.learnWord(word)
    }
    
    // Remove an ignored word
    public func removeIgnoredWord(_ word: String) {
        if let index = ignoredWords.firstIndex(of: word) {
            ignoredWords.remove(at: index)
        }
    }
    
    // Unlearn a specific word
    public func unlearnWord(_ word: String) {
        UITextChecker.unlearnWord(word)
    }
    
    // Provide autocomplete suggestions
    public func autocompleteSuggestions(
        for text: String,
        completion: AutocompleteProvider.Completion
    ) {
        guard !text.isEmpty else {
            completion(.success([]))
            return
        }
        
        let language: String
        if #available(iOS 16, *) {
            language = String(describing: viewController?.keyboardContext.locale.language.languageCode ?? "en")
        } else {
            language = "en"
        }
        let range = NSRange(location: 0, length: text.utf16.count)
        
        // Get completions from UITextChecker
        if let completions = textChecker.completions(forPartialWordRange: range, in: text, language: language) {
            // Limit to top 3 suggestions
            let topCompletions = completions.prefix(3)
            let suggestions = topCompletions.map { AutocompleteSuggestion(text: $0) }
            completion(.success(suggestions))
        } else {
            completion(.success([]))
        }
    }
    
}
