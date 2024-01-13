//
//  MockAudioFeedbackEngine.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-04-01.
//  Copyright © 2021-2023 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import MockingKit

class MockAudioFeedbackEngine: AudioFeedbackEngine, Mockable {
    
    var mock = Mock()
    
    lazy var triggerRef = MockReference(trigger)
    
    override func trigger(_ audio: AudioFeedback) {
        call(triggerRef, args: (audio))
    }
}
