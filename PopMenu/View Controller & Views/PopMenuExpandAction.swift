//
//  PopMenuExpandAction.swift
//  Pods
//
//  (\(\
//  ( -.-)
//  o_(")(")
//  -----------------------
//  Created by jeffy on 2025/4/1.
//

public class PopMenuExpandAction: PopMenuDefaultAction {

    // MARK: - Properties

    public lazy var expandIcon: UIImageView = {
        //        let imgView = UIImageView(image: UIImage(named: "expand_arrow_right"))
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()

    public var actions: [PopMenuAction] = [] {
        didSet {
            for action in actions {
                action.edgeInsets = edgeInsets
            }
        }
    }


    // MARK: - Overrides

    public override init(
        title: String? = nil, image: UIImage? = nil, color: Color? = nil,
        didSelect: PopMenuDefaultAction.PopMenuActionHandler? = nil
    ) {
        super.init(title: title, image: image, color: color, didSelect: didSelect)
        edgeInsets = UIEdgeInsets(top: 0, left: 34, bottom: 0, right: 16)
        keepSelected = true
        hilightColor = .clear
    }

    /// Load and configure the action view.
    public override func renderActionView() {
        super.renderActionView()
        // Add expand icon.
        view.addSubview(expandIcon)
        NSLayoutConstraint.activate([
            expandIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            expandIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            expandIcon.widthAnchor.constraint(equalToConstant: 24),
            expandIcon.heightAnchor.constraint(equalToConstant: 24),
        ])
    }

    /// When the action is selected.
    public override func actionSelected(animated: Bool) {
        // Trigger handler.
        super.actionSelected(animated: animated)
        // Show secondary actions.
        guard let parent = view.superview else {
            return
        }
        let didExpandAction = self.didExpandSction()
        let maskView = didExpandAction.maskView
        maskView.frame = parent.bounds
        maskView.alpha = 0
        parent.addSubview(maskView)
        let menuViewController = PopMenuViewController(
            sourceView: self.view,
            actions: [didExpandAction] + actions
        )
        menuViewController.transitioningDelegate = SecondaryTransitioningDelegate.shared
        view.controller?.present(menuViewController, animated: true, completion: {

        })
    }

    // MARK: - Private

    /// Dismiss the popover.
    @objc private func dismissPopover() {
        view.controller?.dismiss(animated: true, completion: nil)
    }

    private func didExpandSction() -> DidExpandAction {
        let action = DidExpandAction(title: title, image: image, color: color, didSelect: nil)
        action.expandIcon.image = self.expandIcon.image
        action.view.frame = self.view.frame
        return action
    }
}

class DidExpandAction: PopMenuDefaultAction {

    // MARK: - Properties

    public lazy var expandIcon: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()

    lazy var maskView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        return view
    }()

    // MARK: - Overrides

    public override init(
        title: String? = nil, image: UIImage? = nil, color: Color? = nil,
        didSelect: PopMenuDefaultAction.PopMenuActionHandler? = nil
    ) {
        super.init(title: title, image: image, color: color, didSelect: didSelect)
        edgeInsets = UIEdgeInsets(top: 0, left: 34, bottom: 0, right: 16)
        keepSelected = true
    }

    /// Load and configure the action view.
    public override func renderActionView() {
        super.renderActionView()
        // Add expand icon.
        view.addSubview(expandIcon)
        NSLayoutConstraint.activate([
            expandIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            expandIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            expandIcon.widthAnchor.constraint(equalToConstant: 24),
            expandIcon.heightAnchor.constraint(equalToConstant: 24),
        ])
    }

    /// When the action is selected.
    public override func actionSelected(animated: Bool) {
        view.controller?.dismiss(animated: true, completion: nil)
    }

    override func caculateWidth() -> CGFloat {
        view.frame.width
    }
}
