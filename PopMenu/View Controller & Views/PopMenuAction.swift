//
//  PopMenuAction.swift
//  PopMenu
//
//  Created by Cali Castle  on 4/13/18.
//  Copyright © 2018 PopMenu. All rights reserved.
//

import UIKit

/// Customize your own action and conform to `PopMenuAction` protocol.
@objc public protocol PopMenuAction: NSObjectProtocol {

    /// if `separatorHeight` > 0, a separator will be rendered
    /// else the action will be rendered with default separatorHeight from `PopMenuAppearance`
    var separatorHeight: CGFloat { get set }

    /// if `edgeInsets` is not `.zero`, the action will be rendered with edgeInsets
    /// else the action will be rendered with default edgeInsets from `PopMenuAppearance`
    var edgeInsets: UIEdgeInsets { get set }

    /// Title of the action.
    var title: String? { get }

    /// Image of the action.
    var image: UIImage? { get }

    /// Container view of the action.
    var view: UIView { get }

    /// The initial color of the action.
    var color: Color? { get }

    /// The handler of action.
    var didSelect: PopMenuActionHandler? { get }

    /// Icon sizing.
    var iconWidthHeight: CGFloat { get set }

    /// The color to set for both label and icon.
    var tintColor: UIColor { get set }

    /// The font for label.
    var font: UIFont { get set }

    /// The corner radius of action view.
    var cornerRadius: CGFloat { get set }

    /// Is the view highlighted by gesture.
    var highlighted: Bool { get set }

    var keepSelected: Bool { get set }

    /// Render the view for action.
    func renderActionView()

    /// Called when the action gets selected.
    @objc optional func actionSelected(animated: Bool)

    func caculateWidth() -> CGFloat

    /// Type alias for selection handler.
    typealias PopMenuActionHandler = (PopMenuAction) -> Void

}

/// The default PopMenu action class.
public class PopMenuDefaultAction: NSObject, PopMenuAction {

    /// only work with horizontal axis
    public var edgeInsets: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)

    public var separatorHeight: CGFloat = 0

    /// Title of action.
    public let title: String?

    /// Icon of action.
    public let image: UIImage?

    /// Image rendering option.
    public var imageRenderingMode: UIImage.RenderingMode = .alwaysTemplate

    /// Renderred view of action.
    public let view: UIView

    /// Color of action.
    public let color: Color?

    /// Handler of action when selected.
    public let didSelect: PopMenuActionHandler?

    /// Icon sizing.
    public var iconWidthHeight: CGFloat = 24

    public var keepSelected: Bool = false

    // MARK: - Computed Properties

    /// Text color of the label.
    public var tintColor: Color {
        get {
            return titleLabel.textColor
        }
        set {
            titleLabel.textColor = newValue
            iconImageView.tintColor = newValue
        }
    }

    /// Font for the label.
    public var font: UIFont {
        get {
            return titleLabel.font
        }
        set {
            titleLabel.font = newValue
        }
    }

    /// Rounded corner radius for action view.
    public var cornerRadius: CGFloat {
        get {
            return view.layer.cornerRadius
        }
        set {
            view.layer.cornerRadius = newValue
        }
    }

    /// Inidcates if the action is being highlighted.
    public var highlighted: Bool = false {
        didSet {
            guard highlighted != oldValue else { return }
            highlightActionView(highlighted)
        }
    }

    /// Background color for highlighted state.
    var hilightColor: Color = .white.withAlphaComponent(0.1)

    // MARK: - Subviews

    /// Title label view instance.
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.text = title

        return label
    }()

    /// Icon image view instance.
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image?.withRenderingMode(imageRenderingMode)

        return imageView
    }()

    // MARK: - Initializer

    /// Initializer.
    public init(
        title: String? = nil, image: UIImage? = nil, color: Color? = nil, didSelect: PopMenuActionHandler? = nil
    ) {
        self.title = title
        self.image = image
        self.color = color
        self.didSelect = didSelect

        view = UIView()
    }

    /// Setup necessary views.
    fileprivate func configureViews() {
        var hasImage = false

        if image != nil {
            hasImage = true
            view.addSubview(iconImageView)

            NSLayoutConstraint.activate([
                iconImageView.widthAnchor.constraint(equalToConstant: iconWidthHeight),
                iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
                iconImageView.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor, constant: -edgeInsets.right),
                iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
        }

        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: edgeInsets.left),
            titleLabel.trailingAnchor.constraint(
                equalTo: hasImage ? iconImageView.leadingAnchor : view.trailingAnchor,
                constant: hasImage ? 0 : -edgeInsets.right),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    /// Load and configure the action view.
    public func renderActionView() {
        configureViews()
    }

    /// Highlight the view when panned on top,
    /// unhighlight the view when pan gesture left.
    public func highlightActionView(_ highlight: Bool) {
        DispatchQueue.main.async {
            self.view.backgroundColor = self.highlighted ? self.hilightColor : .clear
        }
    }

    /// When the action is selected.
    public func actionSelected(animated: Bool) {
        // Trigger handler.
        didSelect?(self)

        // Animate selection
        guard animated else { return }

        DispatchQueue.main.async {
            UIView.animate(
                withDuration: 0.175,
                animations: {
                    self.view.backgroundColor = self.hilightColor
                },
                completion: { _ in
                    UIView.animate(
                        withDuration: 0.175,
                        animations: {
                            self.view.backgroundColor = .clear
                        })
                })
        }
    }

    public func caculateWidth() -> CGFloat {
        let edgeWidth = edgeInsets.left + edgeInsets.right
        let textWidth = titleLabel.sizeThatFits(view.bounds.size).width
        let textIconSpace = 14.0
        return edgeWidth + textWidth + textIconSpace + iconWidthHeight
    }

}
