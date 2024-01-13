//
//  QuotationAnalyzerTests.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-03-17.
//  Copyright © 2021-2023 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(tvOS)
import KeyboardKit
import MockingKit
import XCTest

class QuotationAnalyzerTests: XCTestCase {

    class Analyzer: QuotationAnalyzer {}

    var analyzer: Analyzer!
    var proxy: MockTextDocumentProxy!

    override func setUp() {
        analyzer = Analyzer()
        proxy = MockTextDocumentProxy()
    }


    // MARK: - Unclosed alternate quotation

    func hasUnclosedAlternateQuotation(_ text: String?, locale: KeyboardLocale) -> Bool {
        proxy.documentContextBeforeInput = text
        let analyzerCheck = analyzer.hasUnclosedAlternateQuotation(in: text ?? "", for: locale.locale)
        let instanceCheck = text?.hasUnclosedAlternateQuotation(for: locale.locale) ?? false
        let proxyCheck = proxy.hasUnclosedAlternateQuotationBeforeInput(for: locale.locale)
        return analyzerCheck && instanceCheck && proxyCheck
    }

    func testHasUnclosedAlternateQuotationIsFalseIfNoTextExists() {
        KeyboardLocale.allCases.forEach {
            XCTAssertFalse(hasUnclosedAlternateQuotation(nil, locale: $0))
        }
    }

    func testHasUnclosedAlternateQuotationIsFalseIfTextDoesNotContainDelimiters() {
        KeyboardLocale.allCases.forEach {
            let text = "I love coding"
            XCTAssertFalse(hasUnclosedAlternateQuotation(text, locale: $0))
        }
    }

    func testHasUnclosedAlternateQuotationIsTrueIfLastDelimiterIsBeginDelimiter() {
        KeyboardLocale.allCases.forEach {
            let begin = $0.locale.alternateQuotationBeginDelimiter ?? ""
            let end = $0.locale.alternateQuotationEndDelimiter ?? ""
            XCTAssertEqual(hasUnclosedAlternateQuotation("I love coding\(begin)", locale: $0), begin != end)
            XCTAssertFalse(hasUnclosedAlternateQuotation("I love coding\(end)", locale: $0))
            XCTAssertEqual(hasUnclosedAlternateQuotation("I love coding\(end)\(begin)", locale: $0), begin != end)
            XCTAssertFalse(hasUnclosedAlternateQuotation("I love coding\(begin)\(end)", locale: $0))
        }
    }


    // MARK: - Unclosed quotation

    func hasUnclosedQuotation(_ text: String?, locale: KeyboardLocale) -> Bool {
        proxy.documentContextBeforeInput = text
        let analyzerCheck = analyzer.hasUnclosedQuotation(in: text ?? "", for: locale.locale)
        let instanceCheck = text?.hasUnclosedQuotation(for: locale.locale) ?? false
        let proxyCheck = proxy.hasUnclosedQuotationBeforeInput(for: locale.locale)
        return analyzerCheck && instanceCheck && proxyCheck
    }

    func testHasUnclosedQuotationIsFalseIfNoTextExists() {
        KeyboardLocale.allCases.forEach {
            XCTAssertFalse(hasUnclosedQuotation(nil, locale: $0))
        }
    }

    func testHasUnclosedQuotationIsFalseIfTextDoesNotContainDelimiters() {
        KeyboardLocale.allCases.forEach {
            let text = "I love coding"
            XCTAssertFalse(hasUnclosedQuotation(text, locale: $0))
        }
    }

    func testHasUnclosedQuotationIsTrueIfLastDelimiterIsBeginDelimiter() {
        KeyboardLocale.allCases.forEach {
            let begin = $0.locale.quotationBeginDelimiter ?? ""
            let end = $0.locale.quotationEndDelimiter ?? ""
            XCTAssertEqual(hasUnclosedQuotation("I love coding\(begin)", locale: $0), begin != end)
            XCTAssertFalse(hasUnclosedQuotation("I love coding\(end)", locale: $0))
            XCTAssertEqual(hasUnclosedQuotation("I love coding\(end)\(begin)", locale: $0), begin != end)
            XCTAssertFalse(hasUnclosedQuotation("I love coding\(begin)\(end)", locale: $0))
        }
    }

    func testHasUnclosedQuotationHonorsLocalseSpecificCases() {
        XCTAssertTrue(hasUnclosedQuotation("This ‘Is me", locale: .dutch))
        XCTAssertTrue(hasUnclosedQuotation("This «Is me", locale: .italian))
        XCTAssertTrue(hasUnclosedQuotation("This «Is me", locale: .norwegian))
    }


    // MARK: - String quotation

    func quote(_ text: String, for locale: KeyboardLocale) -> String {
        analyzer.quote(text, for: locale.locale)
    }

    func alternateQuote(_ text: String, for locale: KeyboardLocale) -> String {
        analyzer.alternateQuote(text, for: locale.locale)
    }

    func testQuoteStringForLocale() {
        XCTAssertEqual(quote("Hello", for: .dutch), "‘Hello’")
        XCTAssertEqual(quote("Hello", for: .italian), "«Hello»")
        XCTAssertEqual(quote("Hello", for: .swedish), "”Hello”")
    }

    func testAlternateQuoteStringForLocale() {
        XCTAssertEqual(alternateQuote("Hello", for: .dutch), "“Hello”")
        XCTAssertEqual(alternateQuote("Hello", for: .italian), "“Hello”")
        XCTAssertEqual(alternateQuote("Hello", for: .swedish), "’Hello’")
    }


    // MARK: - Preferred quotation replacement

    func beginDelimiter(for locale: KeyboardLocale) -> String {
        locale.locale.quotationBeginDelimiter ?? ""
    }

    func altBeginDelimiter(for locale: KeyboardLocale) -> String {
        locale.locale.alternateQuotationBeginDelimiter ?? ""
    }

    func endDelimiter(for locale: KeyboardLocale) -> String {
        locale.locale.quotationEndDelimiter ?? ""
    }

    func altEndDelimiter(for locale: KeyboardLocale) -> String {
        locale.locale.alternateQuotationEndDelimiter ?? ""
    }

    func testPreferredQuotationReplacementWhenInsertingEndDelimiterWithoutUnclosedBeginDelimiter(for locale: KeyboardLocale, delimiter: String? = nil, expected: String?) {
        let text = "before"
        proxy.documentContextBeforeInput = text
        let delimiter = delimiter ?? endDelimiter(for: locale)
        let analyzerResult = analyzer.preferredQuotationReplacement(for: text, whenAppending: delimiter, for: locale.locale)
        let stringResult = text.preferredQuotationReplacement(whenAppending: delimiter, for: locale.locale)
        let proxyResult = proxy.preferredQuotationReplacement(whenInserting: delimiter, for: locale.locale)
        XCTAssertEqual(analyzerResult, expected)
        XCTAssertEqual(stringResult, expected)
        XCTAssertEqual(proxyResult, expected)
    }

    func testPreferredQuotationReplacementWhenInsertingEndDelimiterWithoutUnclosedBeginDelimiter() {
        testPreferredQuotationReplacementWhenInsertingEndDelimiterWithoutUnclosedBeginDelimiter(for: .danish, expected: beginDelimiter(for: .danish))
        testPreferredQuotationReplacementWhenInsertingEndDelimiterWithoutUnclosedBeginDelimiter(for: .dutch, expected: beginDelimiter(for: .dutch))
        testPreferredQuotationReplacementWhenInsertingEndDelimiterWithoutUnclosedBeginDelimiter(for: .english, expected: beginDelimiter(for: .english))
        testPreferredQuotationReplacementWhenInsertingEndDelimiterWithoutUnclosedBeginDelimiter(for: .finnish, expected: nil)
        testPreferredQuotationReplacementWhenInsertingEndDelimiterWithoutUnclosedBeginDelimiter(for: .german, delimiter: "”", expected: beginDelimiter(for: .german))
        testPreferredQuotationReplacementWhenInsertingEndDelimiterWithoutUnclosedBeginDelimiter(for: .german, expected: beginDelimiter(for: .german))
        testPreferredQuotationReplacementWhenInsertingEndDelimiterWithoutUnclosedBeginDelimiter(for: .norwegian, expected: beginDelimiter(for: .norwegian))
        testPreferredQuotationReplacementWhenInsertingEndDelimiterWithoutUnclosedBeginDelimiter(for: .swedish, expected: nil)
    }

    func testPreferredQuotationReplacementWhenInsertingAlternateEndDelimiterWithoutUnclosedBeginDelimiter(for locale: KeyboardLocale, delimiter: String? = nil, expected: String?) {
        let text = "before"
        proxy.documentContextBeforeInput = text
        let delimiter = delimiter ?? altEndDelimiter(for: locale)
        let analyzerResult = analyzer.preferredQuotationReplacement(for: text, whenAppending: delimiter, for: locale.locale)
        let stringResult = text.preferredQuotationReplacement(whenAppending: delimiter, for: locale.locale)
        let proxyResult = proxy.preferredQuotationReplacement(whenInserting: delimiter, for: locale.locale)
        XCTAssertEqual(analyzerResult, expected)
        XCTAssertEqual(stringResult, expected)
        XCTAssertEqual(proxyResult, expected)
    }

    func testPreferredQuotationReplacementWhenInsertingAlternateEndDelimiterWithoutUnclosedBeginDelimiter() {
        testPreferredQuotationReplacementWhenInsertingAlternateEndDelimiterWithoutUnclosedBeginDelimiter(for: .danish, expected: altBeginDelimiter(for: .danish))
        testPreferredQuotationReplacementWhenInsertingAlternateEndDelimiterWithoutUnclosedBeginDelimiter(for: .dutch, expected: altBeginDelimiter(for: .dutch))
        testPreferredQuotationReplacementWhenInsertingAlternateEndDelimiterWithoutUnclosedBeginDelimiter(for: .english, expected: nil)
        testPreferredQuotationReplacementWhenInsertingAlternateEndDelimiterWithoutUnclosedBeginDelimiter(for: .finnish, expected: nil)
        testPreferredQuotationReplacementWhenInsertingAlternateEndDelimiterWithoutUnclosedBeginDelimiter(for: .german, expected: altBeginDelimiter(for: .german))
        testPreferredQuotationReplacementWhenInsertingAlternateEndDelimiterWithoutUnclosedBeginDelimiter(for: .german, expected: altBeginDelimiter(for: .german))
        testPreferredQuotationReplacementWhenInsertingAlternateEndDelimiterWithoutUnclosedBeginDelimiter(for: .swedish, expected: nil)
    }

    func testPreferredQuotationReplacementWhenInsertingEndDelimiterAfterUnclosedBeginDelimiter() {
        KeyboardLocale.allCases.forEach {
            let text = "text with some \(beginDelimiter(for: $0))quoted text"
            let insert = endDelimiter(for: $0)
            proxy.documentContextBeforeInput = text
            XCTAssertNil(analyzer.preferredQuotationReplacement(for: text, whenAppending: insert, for: $0.locale))
            XCTAssertNil(text.preferredQuotationReplacement(whenAppending: insert, for: $0.locale))
            XCTAssertNil(proxy.preferredQuotationReplacement(whenInserting: insert, for: $0.locale))
        }
    }

    func testPreferredQuotationReplacementWhenInsertingAlternateEndDelimiterAfterUnclosedBeginDelimiter() {
        KeyboardLocale.allCases.forEach {
            let text = "text with some \(altBeginDelimiter(for: $0))quoted text"
            let insert = altEndDelimiter(for: $0)
            proxy.documentContextBeforeInput = text
            XCTAssertNil(analyzer.preferredQuotationReplacement(for: text, whenAppending: insert, for: $0.locale))
            XCTAssertNil(text.preferredQuotationReplacement(whenAppending: insert, for: $0.locale))
            XCTAssertNil(proxy.preferredQuotationReplacement(whenInserting: insert, for: $0.locale))
        }
    }
}
#endif
