//
//  ActionOverButton.swift
//  
//
//  Created by Andrea Miotto on 19/4/20.
//
import SwiftUI

struct ActionOver: ViewModifier {

    // MARK: - Public Properties

    /// Set to true when you want to display the **ActionOver view**
    @Binding var presented: Bool

    /// The **title** of the *Action Over*
    let title: String

    /// The **message** of the *Action Over*
    let message: String?

    /// All the **buttons** that will be displayed inside the *Action Over*
    let buttons: [ActionOverButton]

    /// The iPad and Mac configuration
    let ipadAndMacConfiguration: IpadAndMacConfiguration

    /// The normal action button color
    let normalButtonColor: UIColor

    // MARK: - Private Properties

    /// The **Action Sheet Buttons** built from the Action Over Buttons
    private var sheetButtons: [ActionSheet.Button] {

        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = normalButtonColor

        var actionButtons: [ActionSheet.Button] = []

        // for each action over button
        // build an action sheet button
        for button in buttons {
            switch button.type {
            case .cancel:
                let button: ActionSheet.Button = .cancel()
                actionButtons.append(button)
            case .normal:
                let button: ActionSheet.Button = .default(
                    Text(button.title ?? ""),
                    action: button.action
                )
                actionButtons.append(button)
            case .destructive:
                let button: ActionSheet.Button = .destructive(
                    Text(button.title ?? ""),
                    action: button.action
                )
                actionButtons.append(button)
            }
        }
        return actionButtons
    }

    /// The **Popover Buttons** built from the Action Over Buttons
    private var popoverButtons: [Button<Label<Text, Image?>>] {
        var actionButtons: [Button<Label<Text, Image?>>] = []
        // for each action over button
        // build an action sheet button
        for button in buttons {
            switch button.type {
            case .cancel:
                break
            case .normal:
                let button: Button<Label<Text, Image?>> = Button(
                    action: {
                        self.presented = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            button.action?()
                        }
                    },
                    label: {
                        Label.init(title: {
                            Text(button.title ?? "")
                                .foregroundColor(Color(self.normalButtonColor))
                        }, icon: {
                            button.image
                        })
                    })
                actionButtons.append(button)
            case .destructive:
                let button = Button(
                    action: {
                        self.presented = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            button.action?()
                        }
                },
                    label: {
                        Label.init(title: {
                            Text(button.title ?? "")
                                .foregroundColor(Color(UIColor.systemRed))
                        }, icon: {
                            button.image
                        })
                })
                actionButtons.append(button)
            }
        }
        return actionButtons
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .iPhone {
                $0.actionSheet(isPresented: $presented) {
                    ActionSheet(
                        title: Text(self.title),
                        message: self.message != nil ? Text(self.message ?? "") : nil,
                        buttons: sheetButtons)
                }
            }
            .iPadAndMac {
                $0.popover(
                    isPresented: $presented,
                    attachmentAnchor: PopoverAttachmentAnchor.point(ipadAndMacConfiguration.anchor ?? .topTrailing),
                    arrowEdge: (ipadAndMacConfiguration.arrowEdge ?? .top),
                    content: {
                        ActionOverPopoverView(
                            presented: $presented,
                            title: self.title,
                            message: self.message,
                            buttons: buttons,
                            normalButtonColor: normalButtonColor,
                            popoverAlignment: .leading
                        )
                    }
                )
            }
    }
}

/**
 Creates an **Action Over Popover**. It will be a **Popover** on *iPad and Mac*.

 It defines the:
 - **title**: The title of the Action Over.
 - **message**: The message of the action Over.
 - **buttons** An array of ActionOverButton that will be rendered in the proper format according the displayed menu type.
 - **popoverAlignment**: The alignment that helpd the menu to position itself on iPad and Mac
 */
struct ActionOverPopoverView: View {

    // MARK: - Public Properties

    /// Set to true when you want to display the **ActionOver view**
    var presented: Binding<Bool>

    /// The **title** of the *Action Over*
    let title: String

    /// The **message** of the *Action Over*
    let message: String?

    /// All the **buttons** that will be displayed inside the *Action Over*
    let buttons: [ActionOverButton]

    /// The normal action button color
    let normalButtonColor: UIColor

    /// The stack alignment
    let stackAlignment: HorizontalAlignment

    /// The title and message text alignment
    let titleAndSubtitleTextAlignment: TextAlignment

    init(
        presented: Binding<Bool>,
        title: String,
        message: String?,
        buttons: [ActionOverButton],
        normalButtonColor: UIColor,
        popoverAlignment: IpadAndMacConfiguration.Alignment = .center
    ) {
        self.presented = presented
        self.title = title
        self.message = message
        self.buttons = buttons
        self.normalButtonColor = normalButtonColor
        switch popoverAlignment {
        case .center:
            self.stackAlignment = .center
            self.titleAndSubtitleTextAlignment = .center
        case .leading:
            self.stackAlignment = .leading
            self.titleAndSubtitleTextAlignment = .leading
        case .trailing:
            self.stackAlignment = .trailing
            self.titleAndSubtitleTextAlignment = .trailing
        }
    }

    var body: some View {
        VStack(alignment: stackAlignment, spacing: 10) {
            Text(self.title)
                .font(.headline)
                .foregroundColor(Color(UIColor.secondaryLabel))
                .padding(.top)
                .multilineTextAlignment(titleAndSubtitleTextAlignment)
            if self.message != nil {
                Text(self.message ?? "")
                    .font(.body)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .frame(maxWidth: UIScreen.main.bounds.size.width/3, minHeight: 60)
                    .lineLimit(5)
                    .multilineTextAlignment(titleAndSubtitleTextAlignment)
                    .padding(.horizontal)
            }

            ForEach((0..<self.popoverButtons.count), id: \.self) { index in
                Group {
                    Divider()
                    self.popoverButtons[index]
                        .padding(.all, 10)
                        .contentShape(Rectangle())
                }
            }
        }
        .padding(10)
    }

    /// The **Popover Buttons** built from the Action Over Buttons
    private var popoverButtons: [Button<Label<Text, Image?>>] {
        var actionButtons: [Button<Label<Text, Image?>>] = []
        // for each action over button
        // build an action sheet button
        for button in buttons {
            switch button.type {
            case .cancel:
                break
            case .normal:
                let button: Button<Label<Text, Image?>> = Button(
                    action: {
                        self.presented.wrappedValue = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            button.action?()
                        }
                    },
                    label: {
                        Label.init(title: {
                            Text(button.title ?? "")
                                .foregroundColor(Color(self.normalButtonColor))
                        }, icon: {
                            button.image
                        })
                    })
                actionButtons.append(button)
            case .destructive:
                let button = Button(
                    action: {
                        self.presented.wrappedValue = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            button.action?()
                        }
                    },
                    label: {
                        Label.init(title: {
                            Text(button.title ?? "")
                                .foregroundColor(Color(UIColor.systemRed))
                        }, icon: {
                            button.image
                        })
                    })
                actionButtons.append(button)
            }
        }
        return actionButtons
    }
}
