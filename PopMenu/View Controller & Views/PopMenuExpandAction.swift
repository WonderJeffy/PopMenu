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

    lazy var expandIcon: UIImageView = {
//        let imgView = UIImageView(image: UIImage(named: "expand_arrow_right"))
        let imgView = UIImageView(image: UIImage(named: "icon_arrow_right"))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()

    public override init(title: String? = nil, image: UIImage? = nil, color: Color? = nil, didSelect: PopMenuDefaultAction.PopMenuActionHandler? = nil) {
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
            expandIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    /// When the action is selected.
    public override func actionSelected(animated: Bool) {
        // Trigger handler.
        super.actionSelected(animated: animated)
    }
}
