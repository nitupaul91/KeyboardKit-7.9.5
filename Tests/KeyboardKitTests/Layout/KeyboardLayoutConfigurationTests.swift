//
//  KeyboardLayoutConfigurationTests.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-10-01.
//  Copyright © 2021-2023 Daniel Saidi. All rights reserved.
//

import XCTest

@testable import KeyboardKit

class KeyboardLayoutConfigurationTests: XCTestCase {

    func testStandardConfigurationIsCorrectForiPadInPortrait() {
        let config = KeyboardLayoutConfiguration.standardPad
        XCTAssertEqual(config.buttonCornerRadius, 5)
        XCTAssertEqual(config.buttonInsets, .horizontal(6, vertical: 4))
        XCTAssertEqual(config.rowHeight, 64)
    }
    
    func testStandardConfigurationIsCorrectForiPadInLandscape() {
        let config = KeyboardLayoutConfiguration.standardPadLandscape
        XCTAssertEqual(config.buttonCornerRadius, 7)
        XCTAssertEqual(config.buttonInsets, .horizontal(7, vertical: 6))
        XCTAssertEqual(config.rowHeight, 86)
    }

    func testStandardConfigurationIsCorrectForiPhoneInPortrait() {
        let config = KeyboardLayoutConfiguration.standardPhone
        XCTAssertEqual(config.buttonCornerRadius, 5)
        XCTAssertEqual(config.buttonInsets, .horizontal(3, vertical: 6))
        XCTAssertEqual(config.rowHeight, 54)
    }

    func testStandardConfigurationIsCorrectForiPhoneInLandscape() {
        let config = KeyboardLayoutConfiguration.standardPhoneLandscape
        XCTAssertEqual(config.buttonCornerRadius, 5)
        XCTAssertEqual(config.buttonInsets, .horizontal(3, vertical: 4))
        XCTAssertEqual(config.rowHeight, 40)
    }

    func testStandardConfigurationIsCorrectForiPhoneProMaxInPortrait() {
        let config = KeyboardLayoutConfiguration.standardPhoneProMax
        XCTAssertEqual(config.buttonCornerRadius, 5)
        XCTAssertEqual(config.buttonInsets, .horizontal(3, vertical: 5.5))
        XCTAssertEqual(config.rowHeight, 56)
    }

    func testStandardConfigurationIsCorrectForiPhoneProMaxInLandscape() {
        let config = KeyboardLayoutConfiguration.standardPhoneProMaxLandscape
        XCTAssertEqual(config.buttonCornerRadius, 5)
        XCTAssertEqual(config.buttonInsets, .horizontal(3, vertical: 4))
        XCTAssertEqual(config.rowHeight, 40)
    }


    func configuration(
        for device: DeviceType,
        size: CGSize,
        orientation: InterfaceOrientation
    ) -> KeyboardLayoutConfiguration {
        KeyboardLayoutConfiguration.standard(
            forDevice: device,
            screenSize: size,
            orientation: orientation
        )
    }

    func testStandardKeyboardConfigurationForExplicitOrientations() {
        var config = configuration(for: .pad, size: .iPadScreenLandscape, orientation: .landscapeRight)
        XCTAssertEqual(config.buttonCornerRadius, 7)
        XCTAssertEqual(config.buttonInsets, .horizontal(7, vertical: 6))
        XCTAssertEqual(config.rowHeight, 86)

        config = configuration(for: .pad, size: .iPadScreenPortrait, orientation: .portrait)
        XCTAssertEqual(config.buttonCornerRadius, 5)
        XCTAssertEqual(config.buttonInsets, .horizontal(6, vertical: 4))
        XCTAssertEqual(config.rowHeight, 64)


        config = configuration(for: .pad, size: .iPadProLargeScreenLandscape, orientation: .landscapeRight)
        XCTAssertEqual(config.buttonCornerRadius, 8)
        XCTAssertEqual(config.buttonInsets, .horizontal(7, vertical: 5))
        XCTAssertEqual(config.rowHeight, 88)

        config = configuration(for: .pad, size: .iPadProLargeScreenPortrait, orientation: .portrait)
        XCTAssertEqual(config.buttonCornerRadius, 6)
        XCTAssertEqual(config.buttonInsets, .horizontal(4, vertical: 4))
        XCTAssertEqual(config.rowHeight, 69)


        config = configuration(for: .pad, size: .iPadProSmallScreenLandscape, orientation: .landscapeRight)
        XCTAssertEqual(config, .standardPadLandscape)

        config = configuration(for: .pad, size: .iPadProSmallScreenPortrait, orientation: .portrait)
        XCTAssertEqual(config, .standardPad)


        config = configuration(for: .phone, size: .zero, orientation: .landscapeRight)
        XCTAssertEqual(config.buttonCornerRadius, 5)
        XCTAssertEqual(config.buttonInsets, .horizontal(3, vertical: 4))
        XCTAssertEqual(config.rowHeight, 40)

        config = configuration(for: .phone, size: .zero, orientation: .portrait)
        XCTAssertEqual(config.buttonCornerRadius, 5)
        XCTAssertEqual(config.buttonInsets, .horizontal(3, vertical: 6))
        XCTAssertEqual(config.rowHeight, 54)


        config = configuration(for: .phone, size: .zero, orientation: .landscapeRight)
        XCTAssertEqual(config.buttonCornerRadius, 5)
        XCTAssertEqual(config.buttonInsets, .horizontal(3, vertical: 4))
        XCTAssertEqual(config.rowHeight, 40)

        config = configuration(for: .phone, size: .iPhoneProMaxScreenLandscape, orientation: .portrait)
        XCTAssertEqual(config.buttonCornerRadius, 5)
        XCTAssertEqual(config.buttonInsets, .horizontal(3, vertical: 6))
        XCTAssertEqual(config.rowHeight, 54)
    }
}
