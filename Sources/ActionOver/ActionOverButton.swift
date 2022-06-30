//
//  ActionOverButton.swift
//  
//
//  Created by Andrea Miotto on 19/4/20.
//
import SwiftUI

/**
 The Action Over Button will be translated to an ActionSheetButton for the Action Sheet, or to a Button for the Popover menu.

 It defines the:
 - **title**: the title for the button.
 - **type** for the button: (normal, cancel, destructive).
 - **action** executed when the button is pressed.
 */
public struct ActionOverButton {
    public enum ActionType {
        case destructive, cancel, normal
    }

    public enum Alignment {
        case leading, center, trailing
    }

    let title: String?
    let image: Image?
    let type: ActionType
    let action: (() -> Void)?
    let alignment: Alignment

    public init(title: String?,
                image: Image? = nil,
                type: ActionType,
                alignment: Alignment = .center,
                action: (() -> Void)?
    ) {
        self.title = title
        self.image = image
        self.type = type
        self.alignment = alignment
        self.action = action
    }
}
