//
//  View+ActionOverModifier.swift
//  
//
//  Created by Andrea Miotto on 19/4/20.
//

import SwiftUI

extension View {
    /**
     Presents an **Action Over**. It will be an **Action Sheet** on *iPhone* and a **Popover** on *iPad and Mac*.
     - parameter presented: This should be set to true when the Action Over has to be displayed.
     - parameter title: The title of the Action Over.
     - parameter message:The message of the action Over.
     - parameter buttons: An array of ActionOverButton that will be rendered in the proper format according the displayed menu type.
     Default is *true*.
     - parameter ipadAndMacConfiguration: The configuration that helpd the menu to position itself on iPad and Mac.
     - parameter normalButtonColor: The color for the buttons with a *normal* action. The default color is *UIColor.label*
     */
    public func actionOver(
        presented: Binding<Bool>,
        title: String,
        message: String?,
        buttons: [ActionOverButton],
        ipadAndMacConfiguration: IpadAndMacConfiguration,
        normalButtonColor: UIColor = UIColor.label
    ) -> some View {
        return self.modifier(
            ActionOver(
                presented: presented,
                title: title,
                message: message,
                buttons: buttons,
                ipadAndMacConfiguration: ipadAndMacConfiguration,
                normalButtonColor: normalButtonColor
            )
        )
    }

    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func applyIf<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
