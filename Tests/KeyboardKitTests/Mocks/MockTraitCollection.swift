//
//  MockTraitCollection.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-02-19.
//  Copyright © 2021-2023 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit

class MockTraitCollection: UITraitCollection {
    
    var userInterfaceStyleValue: UIUserInterfaceStyle = .light
    
    override var userInterfaceStyle: UIUserInterfaceStyle { userInterfaceStyleValue }
}
#endif
