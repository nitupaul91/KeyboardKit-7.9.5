# ``KeyboardKit``

KeyboardKit helps you build custom keyboards with Swift and SwiftUI.


## Overview

![KeyboardKit logo](Logo.png)

KeyboardKit helps you create custom keyboards for iOS and iPadOS, using Swift and SwiftUI. It extends Apple's native keyboard APIs and provides you with more functionality. 

KeyboardKit lets you create keyboards that mimic the native iOS keyboards in a few lines of code. These keyboards can be customized to change input keys, layout, design, behavior etc.

KeyboardKit also lets you use completely custom views together with the features that the library provides. Most of the library can be used on all major Apple platforms.

KeyboardKit supports `iOS 14`, `macOS 11`, `tvOS 14` and `watchOS 7`, although some features are unavailable on some platforms.



## Installation

KeyboardKit can be installed with the Swift Package Manager:

```
https://github.com/KeyboardKit/KeyboardKit.git
```

You can add the library to the main app, the keyboard extension and any targets that need it.



## Supported Locales

KeyboardKit is localized in **60+** keyboard-specific locales:

🇦🇱 🇦🇪 🇦🇲 🇧🇾 🇧🇬 🇦🇩 🏳️ 🇭🇷 🇨🇿 🇩🇰 <br />
🇳🇱 🇧🇪 🇺🇸 🇬🇧 🇺🇸 🇪🇪 🇫🇴 🇵🇭 🇫🇮 🇫🇷 <br />
🇧🇪 🇨🇭 🇬🇪 🇩🇪 🇦🇹 🇨🇭 🇬🇷 🇺🇸 🇮🇱 🇭🇺 <br />
🇮🇸 🇮🇩 🇮🇪 🇮🇹 🇰🇿 🇹🇯 🇹🇯 🇹🇯 🇱🇻 🇱🇹 <br />
🇲🇰 🇲🇾 🇲🇹 🇲🇳 🇳🇴 🇮🇷 🇵🇱 🇵🇹 🇧🇷 🇷🇴 <br />
🇷🇺 🇷🇸 🇷🇸 🇸🇰 🇸🇮 🇪🇸 🇰🇪 🇸🇪 🇹🇷 🇺🇦 <br />
🇺🇿 <br />



## About this documentation

The online documentation is currently iOS-specific. To generate documentation for other platforms, open the package in Xcode, select a simulator then run `Product/Build Documentation`.



## License

KeyboardKit is available under the MIT license.



[KeyboardKit]: https://github.com/KeyboardKit/KeyboardKit
[KeyboardKitPro]: https://github.com/KeyboardKit/KeyboardKitPro



## Topics

### Getting Started

- <doc:Getting-Started>

### Essentials

- <doc:Essentials>

### Articles

- <doc:Actions>
- <doc:Autocomplete>
- <doc:Callouts>
- <doc:Dictation>
- <doc:Emojis>
- <doc:External-Keyboards>
- <doc:Feedback>
- <doc:Gestures>
- <doc:Layout>
- <doc:Localization>
- <doc:Previews>
- <doc:Proxy-Extensions>
- <doc:Routing>
- <doc:Settings>
- <doc:Styling>

### Essentials

- ``Keyboard``
- ``KeyboardBehavior``
- ``KeyboardContext``
- ``KeyboardController``
- ``KeyboardEnabledContext``
- ``KeyboardEnabledLabel``
- ``KeyboardEnabledLabelStyle``
- ``KeyboardEnabledStateInspector``
- ``KeyboardInputViewController``
- ``KeyboardTextContext``
- ``NextKeyboardButton``
- ``StandardKeyboardBehavior``

### Actions

- ``KeyboardAction``
- ``KeyboardActionHandler``
- ``StandardKeyboardActionHandler``

### Autocomplete

- ``AutocompleteContext``
- ``AutocompleteProvider``
- ``AutocompleteSuggestion``
- ``AutocompleteToolbar``
- ``AutocompleteToolbarItem``
- ``AutocompleteToolbarItemSubtitle``
- ``AutocompleteToolbarItemTitle``
- ``AutocompleteToolbarSeparator``

- ``DisabledAutocompleteProvider``

### Callouts

- ``ActionCallout``
- ``CalloutActionProvider``
- ``InputCallout``
- ``StandardCalloutActionProvider``

- ``BaseCalloutActionProvider``
- ``DisabledCalloutActionProvider``

### Device

- ``DeviceType``
- ``InterfaceOrientation``

### Dictation

- ``DictationAuthorizationStatus``
- ``DictationConfiguration``
- ``DictationContext``
- ``DictationService``
- ``DictationServiceError``
- ``KeyboardDictationConfiguration``
- ``KeyboardDictationService``

- ``DisabledDictationService``
- ``DisabledKeyboardDictationService``

### Emojis

- ``Emoji``
- ``EmojiCategory``
- ``EmojiCategoryKeyboard``
- ``EmojiKeyboard``
- ``EmojiKeyboardItem``
- ``EmojiKeyboardStyle``
- ``EmojiProvider``
- ``FrequentEmojiProvider``
- ``MostRecentEmojiProvider``

### External

- ``ExternalKeyboardContext``

### Features

- ``FeatureToggle``

### Feedback

- ``AudioFeedback``
- ``AudioFeedbackConfiguration``
- ``AudioFeedbackEngine``
- ``HapticFeedback``
- ``HapticFeedbackConfiguration``
- ``HapticFeedbackEngine``
- ``KeyboardFeedbackSettings``

### Gestures

- ``DragGestureHandler``
- ``GestureButton``
- ``GestureButtonDefaults``
- ``KeyboardGesture``
- ``RepeatGestureTimer``
- ``ScrollViewGestureButton``
- ``SpaceLongPressBehavior``
- ``SpaceCursorDragGestureHandler``
- ``SpaceDragSensitivity``

### Layout

- ``InputSet``
- ``InputSetItem``
- ``InputSetRow``
- ``InputSetRows``
- ``AlphabeticInputSet``
- ``NumericInputSet``
- ``SymbolicInputSet``

- ``KeyboardLayout``
- ``KeyboardLayoutConfiguration``
- ``KeyboardLayoutItem``
- ``KeyboardLayoutProvider``
- ``KeyboardLayoutProviderProxy``
- ``KeyboardRowItem``

- ``StandardKeyboardLayoutProvider``
- ``iPadKeyboardLayoutProvider``
- ``iPhoneKeyboardLayoutProvider``
- ``StaticKeyboardLayoutProvider``
- ``SystemKeyboardLayoutProvider``

- ``EnglishKeyboardLayoutProvider``

### Localization

- ``KeyboardLocale``
- ``KKL10n``
- ``LocaleContextMenu``
- ``LocaleDictionary``
- ``LocaleDirectionAnalyzer``
- ``LocaleFlagProvider``
- ``LocaleNameProvider``
- ``LocalizedService``

### Navigation

- ``KeyboardUrlOpener``

### Previews

- ``KeyboardPreviews``

### Routing

- ``TextInputProxy``
- ``KeyboardInputComponent``
- ``KeyboardInputView``
- ``KeyboardTextField``
- ``KeyboardTextView``

### Settings

- ``KeyboardSettingsLink``
- ``KeyboardSettingsUrlProvider``

### Styling

- ``KeyboardAppearanceViewModifier``
- ``KeyboardColorReader``
- ``KeyboardFont``
- ``KeyboardImageReader``
- ``KeyboardStyle``
- ``KeyboardStyleProvider``
- ``StandardKeyboardStyleProvider``

### System Keyboard

- ``SystemKeyboard``
- ``SystemKeyboardButton``
- ``SystemKeyboardButtonBody``
- ``SystemKeyboardButtonContent``
- ``SystemKeyboardButtonRowItem``
- ``SystemKeyboardButtonShadow``
- ``SystemKeyboardButtonText``
- ``SystemKeyboardSpaceContent``

### Text

- ``CasingAnalyzer``
- ``KeyboardCharacterProvider``
- ``QuotationAnalyzer``
- ``SentenceAnalyzer``
- ``WordAnalyzer``

### Toolbar

- ``ToggleToolbar``
- ``ToggleToolbarAnimation``
