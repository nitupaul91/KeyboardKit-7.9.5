//
//  KeyboardLocale.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-02-01.
//  Copyright © 2021-2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This enum defines KeyboardKit-supported locales.
 
 Each keyboard locale refers to a native ``locale`` that can
 provide locale-specific information. A keyboard locale also
 has localized assets that can be translated with ``KKL10n``.
 */
public enum KeyboardLocale: String,
                            CaseIterable,
                            Codable,
                            Identifiable,
                            LocaleFlagProvider {
    
    case english = "en"
    
    case albanian = "sq"
    case arabic = "ar"
    case armenian = "hy"
    case belarusian = "be"
    case bulgarian = "bg"
    case catalan = "ca"
    case cherokee = "chr"
    case croatian = "hr"
    case czech = "cs"
    case danish = "da"
    case dutch = "nl"
    case dutch_belgium = "nl_BE"
    case english_gb = "en_GB"
    case english_us = "en_US"
    case estonian = "et"
    case faroese = "fo"
    case filipino = "fil"
    case finnish = "fi"
    case french = "fr"
    case french_belgium = "fr_BE"
    case french_switzerland = "fr_CH"
    case georgian = "ka"
    case german = "de"
    case german_austria = "de_AT"
    case german_switzerland = "de_CH"
    case greek = "el"
    case hawaiian = "haw"
    case hebrew = "he_IL"
    case hungarian = "hu"
    case icelandic = "is"
    case indonesian = "id"
    case irish = "ga_IE"
    case italian = "it"
    case kazakh = "kk"
    case kurdish_sorani = "ckb"
    case kurdish_sorani_arabic = "ckb_IQ"
    case kurdish_sorani_pc = "ckb_PC"
    case latvian = "lv"
    case lithuanian = "lt"
    case macedonian = "mk"
    case malay = "ms"
    case maltese = "mt"
    case mongolian = "mn"
    case norwegian = "nb"
    case persian = "fa"
    case polish = "pl"
    case portuguese = "pt_PT"
    case portuguese_brazil = "pt_BR"
    case romanian = "ro"
    case russian = "ru"
    case serbian = "sr"
    case serbian_latin = "sr-Latn"
    case slovak = "sk"
    case slovenian = "sl"
    case spanish = "es"
    case swedish = "sv"
    case swahili = "sw"
    case turkish = "tr"
    case ukrainian = "uk"
    case uzbek = "uz"
    case korean = "ko"
}

public extension KeyboardLocale {

    /// Get all LTR locales.
    static var allLtr: [KeyboardLocale] {
        allCases.filter { $0.locale.isLeftToRight }
    }

    /// Get all RTL locales.
    static var allRtl: [KeyboardLocale] {
        allCases.filter { $0.locale.isRightToLeft }
    }
    
    /// The locale's unique identifier.
    var id: String { rawValue }
    
    /// The raw locale that is used by the keyboard locale.
    var locale: Locale { .init(identifier: localeIdentifier) }
    
    /// The raw locale identifier.
    var localeIdentifier: String { id }


    /// The corresponding flag emoji for the locale.
    var flag: String {
        switch self {
        case .albanian: return "🇦🇱"
        case .arabic: return "🇦🇪"
        case .armenian: return "🇦🇲"
        case .belarusian: return "🇧🇾"
        case .bulgarian: return "🇧🇬"
        case .catalan: return "🇦🇩"
        case .cherokee: return "🏳️"
        case .croatian: return "🇭🇷"
        case .czech: return "🇨🇿"
        case .danish: return "🇩🇰"

        case .dutch: return "🇳🇱"
        case .dutch_belgium: return "🇧🇪"
        case .english: return "🇺🇸"
        case .english_gb: return "🇬🇧"
        case .english_us: return "🇺🇸"
        case .estonian: return "🇪🇪"
        case .faroese: return "🇫🇴"
        case .filipino: return "🇵🇭"
        case .finnish: return "🇫🇮"
        case .french: return "🇫🇷"

        case .french_belgium: return "🇧🇪"
        case .french_switzerland: return "🇨🇭"
        case .georgian: return "🇬🇪"
        case .german: return "🇩🇪"
        case .german_austria: return "🇦🇹"
        case .german_switzerland: return "🇨🇭"
        case .greek: return "🇬🇷"
        case .hawaiian: return "🇺🇸"
        case .hebrew: return "🇮🇱"
        case .hungarian: return "🇭🇺"

        case .icelandic: return "🇮🇸"
        case .indonesian: return "🇮🇩"
        case .irish: return "🇮🇪"
        case .italian: return "🇮🇹"
        case .kazakh: return "🇰🇿"
        case .kurdish_sorani: return "🇹🇯"
        case .kurdish_sorani_arabic: return "🇹🇯"
        case .kurdish_sorani_pc: return "🇹🇯"
        case .korean: return "🇰🇷"
        case .latvian: return "🇱🇻"
        case .lithuanian: return "🇱🇹"
        case .macedonian: return "🇲🇰"

        case .malay: return "🇲🇾"
        case .maltese: return "🇲🇹"
        case .mongolian: return "🇲🇳"
        case .norwegian: return "🇳🇴"
        case .persian: return "🇮🇷"
        case .polish: return "🇵🇱"
        case .portuguese: return "🇵🇹"
        case .portuguese_brazil: return "🇧🇷"
        case .romanian: return "🇷🇴"
        case .russian: return "🇷🇺"

        case .serbian: return "🇷🇸"
        case .serbian_latin: return "🇷🇸"
        case .slovenian: return "🇸🇮"
        case .slovak: return "🇸🇰"
        case .spanish: return "🇪🇸"
        case .swedish: return "🇸🇪"
        case .swahili: return "🇰🇪"
        case .turkish: return "🇹🇷"
        case .ukrainian: return "🇺🇦"
        case .uzbek: return "🇺🇿"
        }
    }
    
    /**
     Whether or not the locale prefers to replace any single
     alternate ending quotation delimiters with begin ones.
     */
    var prefersAlternateQuotationReplacement: Bool {
        locale.prefersAlternateQuotationReplacement
    }

    /// Whether or not the locale matches a certain locale.
    func matches(_ locale: Locale) -> Bool {
        self.locale == locale
    }
}

public extension Locale {

    /// Whether or not the locale matches a keyboard locale.
    func matches(_ locale: KeyboardLocale) -> Bool {
        self == locale.locale
    }
}

public extension Collection where Element == KeyboardLocale {

    /// Get all LTR locales.
    static var allLtr: [KeyboardLocale] {
        KeyboardLocale.allLtr
    }

    /// Get all RTL locales.
    static var allRtl: [KeyboardLocale] {
        KeyboardLocale.allRtl
    }
}

public extension Collection where Element == KeyboardLocale {

    /// Insert a certain a locale first in the collection.
    func insertingFirst(_ locale: Element) -> [Element] {
        [locale] + removing(locale)
    }

    /// Remove a certain a locale from the collection.
    func removing(_ locale: Element) -> [Element] {
        filter { $0 != locale }
    }

    /// Sort the collection by the items's localized names.
    func sorted() -> [Element] {
        sorted { $0.sortName < $1.sortName }
    }

    /// Sort the collection by the locale's localized names.
    func sorted(in locale: Locale) -> [Element] {
        sorted { $0.sortName(in: locale) < $1.sortName(in: locale) }
    }
}

private extension KeyboardLocale {

    var sortName: String {
        locale.localizedName.lowercased()
    }

    func sortName(in locale: Locale) -> String {
        locale.localizedName(in: locale).lowercased()
    }
}
