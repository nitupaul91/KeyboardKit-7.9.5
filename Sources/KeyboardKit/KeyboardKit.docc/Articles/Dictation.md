# Dictation [BETA]

This article describes the KeyboardKit dictation engine.

In KeyboardKit, a ``DictationService`` can be used to perform dictation where microphone access is available, while a ``KeyboardDictationService`` can be used to perform dictation where microphone access is *not* available, such as in a keyboard extension.

KeyboardKit will use the ``KeyboardInputViewController`` ``KeyboardInputViewController/dictationService`` as the standard dictation service, which can use ``KeyboardInputViewController/dictationContext`` to manage shared state. 

KeyboardKit doesn't have a standard provider service as it has for most other services. Instead, it will use a ``DisabledDictationService`` until you register a real one.

[KeyboardKit Pro][Pro] unlocks standard dictation service implementations when you register a valid license. Information about these services can be found at the end of this article.



## How to perform dictation in an app.

You can use a ``DictationService`` to perform dictation where microphone access is available, such as in an app.

Since dictation may stop at any time, for instance by silence, a dictation service must describe how to access the result. For instance, the `StandardDictationService` will continously update a ``DictationContext`` to let you observe and display the current dictation state.

A dictation service can call ``DictationService/requestDictationAuthorization()`` to ask the user for the required permissions before starting a dictation operation. You can call this function manually as well, to avoid interrupting the first dictation operation with alerts.



## How to perform dictation from a keyboard extension

You can use a ``KeyboardDictationService`` to perform dictation where microphone access is *not* available, such as in a keyboard extension. 

A keyboard dictation service should open the app and make it perform dictation, then write the text to shared storage and return to the keyboard extension to let it process the result.

This can be tricky to set up, but KeyboardKit Pro lets you configure this in a few simple steps.



## 👑 Pro features

[KeyboardKit Pro][Pro] unlocks a `StandardDictationService` and a `StandardKeyboardDictationService` when you register a valid license. 

KeyboardKit Pro also unlocks additional tools that make keyboard dictation effortless, which means that you can setup keyboard dictation with just a few steps:


### 1. Set up required permissions

Before you can use dictation, you must add these keys to your app's' `Info.plist`:

```
<key>NSMicrophoneUsageDescription</key>
<string>Describe why you need microphone access.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>Describe why you need speech recognition.</string>
```

If you don't add these keys, your app will crash when you try to start dictation.


### 2. Create an App Group

To share data between the app and its keyboard, you must create an app group and enable it for both the main app and the keyboard extension: 

![Set up an App Group for the app](dictation-appgroup-app.jpg)

![Set up an App Group for the keyboard](dictation-appgroup-keyboard.jpg)

The app and keyboard will now be able to exchange data in a way that makes dictation work. 


### 3. Create a deep link

To make it possible for the keyboard to open the app, you must set up a custom URL scheme:

![Set up a URL Scheme for the app](dictation-url-scheme.jpg)

The keyboard extension will now be able to open the app in a way that makes dictation work.


### 4. Create a keyboard dictation configuration

To perform keyboard dictation, you must create a ``KeyboardDictationConfiguration`` that defines your app-specific App Group ID and deep link:

```swift
extension KeyboardDictationConfiguration {

    static let app = .init(
        appGroupId: "group.com.my-app"    
        appDeepLink: "YOUR-URL-SCHEME://dictation"
    )
}
```

Make sure to make this available to both the app and the keyboard, since they both need it.


### 5. Configure the keyboard

KeyboardKit Pro will register a keyboard dictation service when you register a valid license. To configure your it with an app-specific configuration, just call ``DictationContext/setup(with:)``.

You can now start dictation with the ``KeyboardAction/dictation`` action or by calling ``KeyboardDictationService/startDictationFromKeyboard(with:)`` manually. 

If everything is correctly configured, your keyboard will then open your app and start dictation.


### 6. Configure the app

To make your app handle dictation, you must first register your KeyboardKit Pro license key, then create a ``DictationContext`` and apply a `.keyboardDictation` modifier to your application's root view:

```swift
import SwiftUI

@main
struct MyApp: App {

    init() {
        _ = try? License.register(licenseKey: "LICENSE-KEY")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {

    @StateObject
    var context = DictationContext(config: .app)

    var body: some View {
        NavigationStack(path: $path) {
            ...
        }
        .keyboardDictation(
            context: context,
            config: .app,
            speechRecognizer: recognizer,   // See further down
            overlay: overlay
        )
    }

    func overlay() -> some View {
        DictationScreen(
            dictationContext: context,
            titleView: { EmptyView() },
            indicator: { DictationBarVisualizer(isAnimating: $0) }
        )
    } 
}
```

The app will now automatically start dictation if it's opened with the deep link that is specified in the configuration. When dictation stops, it will automatically navigate back to the keyboard.

You can customize the standard `DictationScreen` with a custom style or use a completely custom overlay.

> Important: If you are using a DocumentGroup-based app, you may have noticed that the `.keyboardDictation` view modifier only works if a document is open. To make dictation always work in a DocumentGroup-based, you can instead check if the context's `isDictationStartedByKeyboard` is `true` when the app starts, and if so present a sheet or a modal and add `keyboardDictationOnAppear` on its root view.  


### 7. Create a speech recognizer

KeyboardKit Pro doesn't contain a `SpeechRecognizer`, since the `Speech` framework would force all apps to specify dictation permissions, even if they aren't using dictation.

Instead, just add this to the app and use a `StandardSpeechRecognizer()` in the modifier:

```swift
import Speech
import KeyboardKitPro

public class StandardSpeechRecognizer: SpeechRecognizer {

    public init() {}

    private var resultHandler: ResultHandler?
    private var speechRecognizer: SFSpeechRecognizer?
    private var speechRecognizerRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognizerTask: SFSpeechRecognitionTask?

    public var authorizationStatus: DictationAuthorizationStatus {
        SFSpeechRecognizer.authorizationStatus().keyboardDictationStatus
    }

    public func requestDictationAuthorization() async throws -> DictationAuthorizationStatus {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status.keyboardDictationStatus)
            }
        }
    }

    public func resetDictationResult() async throws {}

    public func startDictation(
        with config: DictationConfiguration
    ) async throws {
        try await startDictation(with: config, resultHandler: nil)
    }

    public func startDictation(
        with config: DictationConfiguration,
        resultHandler: ResultHandler?
    ) async throws {
        guard let recognizer = setupSpeechRecognizer(for: config) else { throw DictationServiceError.missingSpeechRecognizer }
        guard let request = setupSpeechRecognizerRequest() else { throw DictationServiceError.missingSpeechRecognitionRequest }
        self.resultHandler = resultHandler
        setupSpeechRecognizerTask(for: recognizer, and: request)
    }

    public func stopDictation() async throws {
        speechRecognizerRequest?.endAudio()
        speechRecognizerRequest = nil
        speechRecognizerTask?.cancel()
        speechRecognizerTask = nil
    }

    public func setupAudioEngineBuffer(_ buffer: AVAudioPCMBuffer) {
        speechRecognizerRequest?.append(buffer)
    }
}

private extension StandardSpeechRecognizer {

    func setupSpeechRecognizer(for config: DictationConfiguration) -> SFSpeechRecognizer? {
        let locale = Locale(identifier: config.localeId)
        speechRecognizer = SFSpeechRecognizer(locale: locale)
        return speechRecognizer
    }

    func setupSpeechRecognizerRequest() -> SFSpeechAudioBufferRecognitionRequest? {
        speechRecognizerRequest = SFSpeechAudioBufferRecognitionRequest()
        speechRecognizerRequest?.shouldReportPartialResults = true
        return speechRecognizerRequest
    }

    func setupSpeechRecognizerTask(
        for recognizer: SFSpeechRecognizer,
        and request: SFSpeechRecognitionRequest
    ) {
        speechRecognizerTask = recognizer.recognitionTask(with: request) { [weak self] in
            self?.handleTaskResult($0, error: $1)
        }
    }

    func handleTaskResult(_ result: SFSpeechRecognitionResult?, error: Error?) {
        let result = SpeechRecognizerResult(
            dictatedText: result?.bestTranscription.formattedString,
            error: error,
            isFinal: result?.isFinal ?? true)
        resultHandler?(result)
    }
}
#endif
```

Just copy and paste this code into your app, and you'll be able to use this implementation as is.


### 7. Wrap up dictation in the keyboard

When the service returns the user to the keyboard, the keyboard will automatically try to finish dictation by reading the dictated text and send it to the document.

You don't have to do anything, but if you want to customize the dictation behavior, you can override and customize ``KeyboardInputViewController/viewWillHandleDictationResult()``.


[Pro]: https://github.com/KeyboardKit/KeyboardKitPro
