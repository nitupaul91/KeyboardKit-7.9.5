//
//  View+Callouts.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-01-06.
//  Copyright © 2021-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension View {

    /**
     Apply a keyboard action callout to the view.

     - Parameters:
       - calloutContext: The callout context to use.
       - keyboardContext: The keyboard context to use.
       - style: The style to apply to the view, by default `.standard`.
       - emojiKeyboardStyle: The emoji keyboard style to use, by default ``EmojiKeyboardStyle/standardPhonePortrait``.
     */
    func keyboardActionCallout(
        calloutContext: ActionCallout.Context,
        keyboardContext: KeyboardContext,
        style: KeyboardStyle.ActionCallout = .standard,
        emojiKeyboardStyle: EmojiKeyboardStyle = .standardPhonePortrait
    ) -> some View {
        self.overlay(
            ActionCallout(
                calloutContext: calloutContext,
                keyboardContext: keyboardContext,
                style: style,
                emojiKeyboardStyle: emojiKeyboardStyle
            )
        ).coordinateSpace(name: ActionCallout.coordinateSpace)
    }

    /**
     Apply a keyboard callout shadow to the view.

     - Parameters:
       - style: The style apply, by default `.standard`.
     */
    func keyboardCalloutShadow(
        style: KeyboardStyle.Callout = .standard
    ) -> some View {
        self.shadow(color: style.borderColor, radius: 0.4)
            .shadow(color: style.shadowColor, radius: style.shadowRadius)
    }
    
    /**
     Apply a keyboard input callout to the view.
     
     - Parameters:
       - calloutContext: The callout context to use.
       - keyboardContext: The keyboard context to use.
       - style: The style to apply, by default `.standard`.
     */
    func keyboardInputCallout(
        calloutContext: InputCallout.Context,
        keyboardContext: KeyboardContext,
        style: KeyboardStyle.InputCallout = .standard
    ) -> some View {
        self.overlay(
            InputCallout(
                calloutContext: calloutContext,
                keyboardContext: keyboardContext,
                style: style
            )
        ).coordinateSpace(name: InputCallout.coordinateSpace)
    }
}
