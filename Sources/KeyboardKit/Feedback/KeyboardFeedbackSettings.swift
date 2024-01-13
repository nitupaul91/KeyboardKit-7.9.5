//
//  KeyboardFeedbackSettings.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-04-01.
//  Copyright © 2021-2023 Daniel Saidi. All rights reserved.
//

import Combine
import Foundation

/**
 This class can be used to specify what kind of feedback the
 current keyboard should give to the user.
 
 KeyboardKit will create an observable setting instance when
 the keyboard extension is started, then apply this instance
 to ``KeyboardInputViewController/keyboardFeedbackSettings``.
 It will then use this instance by default to determine what
 feedback that should be given for a certain action.
 
 This instance is used by ``StandardKeyboardFeedbackHandler``,
 which means that you can change the basic feedback behavior
 without having to create a custom feedback handler.
 
 You may notice that the enabled and disabled configurations
 look a bit odd, where the disabled defaults are `.standard`.
 This is since 
 */
public class KeyboardFeedbackSettings: ObservableObject {
    
    /**
     Create a keyboard feedback settings instance.
     
     - Parameters:
       - audioConfiguration: The configuration to use for audio feedback, by deafult `.enabled`.
       - hapticConfiguration: The configuration to use for haptic feedback, by deafult `.minimal`.
       - enabledAudioConfiguration: The configuration to use to enable audio feedback, by default `.enabled`.
       - enabledHapticConfiguration: The configuration to use to enable haptic feedback, by default `.enabled`.
       - disabledAudioConfiguration: The configuration to use to disable audio feedback, by default `.standard`.
       - disabledHapticConfiguration: The configuration to use to disable haptic feedback, by default `.minimal`.
     */
    public init(
        audioConfiguration: AudioFeedbackConfiguration = .enabled,
        hapticConfiguration: HapticFeedbackConfiguration = .minimal,
        enabledAudioConfiguration: AudioFeedbackConfiguration = .enabled,
        enabledHapticConfiguration: HapticFeedbackConfiguration = .enabled,
        disabledAudioConfiguration: AudioFeedbackConfiguration = .enabled,
        disabledHapticConfiguration: HapticFeedbackConfiguration = .minimal
    ) {
        self.audioConfiguration = audioConfiguration
        self.hapticConfiguration = hapticConfiguration
        self.enabledAudioConfiguration = enabledAudioConfiguration
        self.enabledHapticConfiguration = enabledHapticConfiguration
        self.disabledAudioConfiguration = disabledAudioConfiguration
        self.disabledHapticConfiguration = disabledHapticConfiguration
    }
    
    
    /// The configuration to use to enable audio feedback.
    public var enabledAudioConfiguration: AudioFeedbackConfiguration
    
    /// The configuration to use to enable haptic feedback.
    public var enabledHapticConfiguration: HapticFeedbackConfiguration
    
    /// The configuration to use to disable audio feedback.
    public var disabledAudioConfiguration: AudioFeedbackConfiguration
    
    /// The configuration to use to disable haptic feedback.
    public var disabledHapticConfiguration: HapticFeedbackConfiguration
    

    /// The configuration to use for audio feedback.
    @Published
    public var audioConfiguration: AudioFeedbackConfiguration
    
    /// The configuration to use for haptic feedback.
    @Published
    public var hapticConfiguration: HapticFeedbackConfiguration
}

public extension KeyboardFeedbackSettings {
    
    /// This specifies a standard feedback configuration.
    static let standard = KeyboardFeedbackSettings()
}

public extension KeyboardFeedbackSettings {

    /// Get or set whether or not audio feedback is enabled.
    var isAudioFeedbackEnabled: Bool {
        get { audioConfiguration != .disabled }
        set { audioConfiguration = newValue ? enabledAudioConfiguration : disabledAudioConfiguration }
    }

    /// Get or set whether or not haptic feedback is enabled.
    var isHapticFeedbackEnabled: Bool {
        get { hapticConfiguration != .disabled }
        set { hapticConfiguration = newValue ? enabledHapticConfiguration : disabledHapticConfiguration }
    }

    /// Disable audio feedback.
    func disableAudioFeedback() {
        isAudioFeedbackEnabled = false
    }

    /// Disable haptic feedback.
    func disableHapticFeedback() {
        isHapticFeedbackEnabled = false
    }

    /// Enable audio feedback.
    func enableAudioFeedback() {
        isAudioFeedbackEnabled = true
    }

    /// Enable haptic feedback.
    func enableHapticFeedback() {
        isHapticFeedbackEnabled = true
    }

    /// Toggle audio feedback between enabled and disabled.
    func toggleAudioFeedback() {
        if isAudioFeedbackEnabled {
            disableAudioFeedback()
        } else {
            enableAudioFeedback()
        }
    }

    /// Toggle haptic feedback between enabled and disabled.
    func toggleHapticFeedback() {
        if isHapticFeedbackEnabled {
            disableHapticFeedback()
        } else {
            enableHapticFeedback()
        }
    }
}
