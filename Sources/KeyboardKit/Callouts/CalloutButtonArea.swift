//
//  CalloutButtonArea.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-09-30.
//  Copyright © 2021-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 [DEPRECATED] This will be made internal in KeyboardKit 8.0.
 
 This view is the part of the callout that covers the button
 that was tapped or pressed to trigger the callout.
 */
public struct CalloutButtonArea: View {
    
    /**
     Create an autocomplete toolbar item style.
     
     - Parameters:
       - frame: The button area frame.
       - style: The style to use, by default `.standard`.
     */
    public init(
        frame: CGRect,
        style: Style = .standard
    ) {
        self.frame = frame
        self.style = style
    }
    
    public typealias Style = KeyboardStyle.Callout
    
    private let frame: CGRect
    private let style: Style
    
    public var body: some View {
        HStack(alignment: .top, spacing: 0) {
            calloutCurve.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            buttonBody
            calloutCurve
        }
    }
}

private extension CalloutButtonArea {
    
    var backgroundColor: Color { style.backgroundColor }
    
    var cornerRadius: CGFloat { style.buttonCornerRadius }
    
    var curveSize: CGSize { style.curveSize }
}

private extension CalloutButtonArea {
    
    var buttonBody: some View {
        CustomRoundedRectangle(bottomLeft: cornerRadius, bottomRight: cornerRadius)
            .foregroundColor(backgroundColor)
            .frame(width: frame.size.width, height: frame.size.height)
    }
    
    var calloutCurve: some View {
        CalloutCurve()
            .frame(width: curveSize.width, height: curveSize.height)
            .foregroundColor(backgroundColor)
    }
}

struct CalloutButtonArea_Previews: PreviewProvider {
    
    static var previews: some View {
        CalloutButtonArea(
            frame: CGRect(x: 0, y: 0, width: 50, height: 50),
            style: .standard)
            .padding(30)
            .background(Color.gray)
            .cornerRadius(20)
    }
}
