//
//  KeyboardLayout.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-07-03.
//  Copyright © 2020-2023 Daniel Saidi. All rights reserved.
//

import CoreGraphics
import SwiftUI

/**
 A keyboard layout defines all available keyboard actions on
 a keyboard, as well as their size.

 A keyboard layout most often consists of several input rows
 where the input buttons are surrounded by system buttons on
 either or both sides, as well as a bottom row, with a large
 space button and several system buttons.

 The most flexible way to generate a keyboard layout is with
 a ``KeyboardLayoutProvider``.
 */
public class KeyboardLayout {

    /**
     Create a new layout with the provided `items`.

     - Parameters:
       - itemRows: The layout item rows to show in the keyboard.
       - idealItemHeight: An optional, ideal item height, otherwise picked from the first item.
       - idealItemInsets: An optional, ideal item inset value, otherwise picked from the first item.
    */
    public init(
        itemRows rows: KeyboardLayoutItem.Rows,
        idealItemHeight height: Double? = nil,
        idealItemInsets insets: EdgeInsets? = nil
    ) {
        self.itemRows = rows
        self.idealItemHeight = height ?? Self.resolveIdealItemHeight(for: rows)
        self.idealItemInsets = insets ?? Self.resolveIdealItemInsets(for: rows)
    }

    /// The layout item rows to show in the keyboard.
    public var itemRows: KeyboardLayoutItem.Rows

    /// The ideal item height.
    public var idealItemHeight: Double

    /// The ideal item inserts.
    public var idealItemInsets: EdgeInsets

    /// A `CGFloat` typealias for the total keyboard width.
    public typealias TotalWidth = CGFloat

    /// A cache used to avoid having to recalculate widths.
    var widthCache = [TotalWidth: CGFloat]()
}

public extension KeyboardLayout {

    /// Get the bottom item row index.
    var bottomRowIndex: Int {
        itemRows.count - 1
    }

    /// Get the system action items at the bottom row.
    var bottomRowSystemItems: [KeyboardLayoutItem] {
        if bottomRowIndex < 0 { return [] }
        return itemRows[bottomRowIndex].filter {
            $0.action.isSystemAction
        }
    }

    /// Whether or not the bottom row has a keyboard switch.
    func hasKeyboardSwitcher(for type: Keyboard.KeyboardType) -> Bool {
        guard let row = itemRows.last else { return false }
        return row.contains { $0.action.isKeyboardTypeAction(.emojis) }
    }

    /**
     Calculate the width of an input key given a `totalWidth`.

     This will find the smallest required input width in all
     rows, which can then be applied to all input keys. This
     value will then be cached for the `totalWidth`, so that
     it doesn't have to be calculated again.
     */
    func inputWidth(
        for totalWidth: TotalWidth
    ) -> CGFloat {
        if let result = widthCache[totalWidth] { return result }
        let result = itemRows.compactMap { $0.inputWidth(for: totalWidth) }.min() ?? 0
        widthCache[totalWidth] = result
        return result
    }

    /**
     Get the bottom row system items.

     This function will use the first ``bottomRowSystemItems``
     as item template if you don't provide a template. If no
     template is found, the function will return `nil` since
     it lacks information to create a valid item.
     */
    func tryCreateBottomRowItem(
        for action: KeyboardAction
    ) -> KeyboardLayoutItem? {
        guard let template = bottomRowSystemItems.first else { return nil }
        return KeyboardLayoutItem(
            action: action,
            size: template.size,
            insets: template.insets
        )
    }
}

private extension KeyboardLayout {

    static func resolveIdealItemHeight(for rows: KeyboardLayoutItem.Rows) -> Double {
        let item = rows.flatMap { $0 }.first
        return Double(item?.size.height ?? .zero)
    }

    static func resolveIdealItemInsets(for rows: KeyboardLayoutItem.Rows) -> EdgeInsets {
        let item = rows.flatMap { $0 }.first
        return item?.insets ?? EdgeInsets()
    }
}

private extension KeyboardLayoutItem.Row {

    var hasInputWidth: Bool {
        contains { $0.size.width == .input }
    }

    func inputWidth(for totalWidth: CGFloat) -> CGFloat? {
        guard hasInputWidth else { return nil }
        let taken = reduce(0) { $0 + $1.allocatedWidth(for: totalWidth) }
        let remaining = totalWidth - taken
        let totalRefPercentage = reduce(0) { $0 + $1.inputPercentageFactor }
        return remaining / totalRefPercentage
    }
}

private extension KeyboardLayoutItem {

    func allocatedWidth(for totalWidth: CGFloat) -> CGFloat {
        switch size.width {
        case .available: return 0
        case .input: return 0
        case .inputPercentage: return 0
        case .percentage(let percentage): return totalWidth * percentage
        case .points(let points): return points
        }
    }

    var inputPercentageFactor: CGFloat {
        switch size.width {
        case .available: return 0
        case .input: return 1
        case .inputPercentage(let percentage): return percentage
        case .percentage: return 0
        case .points: return 0
        }
    }
}
