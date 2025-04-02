//
//  SecondaryTransitioningDelegate.swift
//  Pods
//
//  (\(\
//  ( -.-)
//  o_(")(")
//  -----------------------
//  Created by jeffy on 2025/4/2.
//

class SecondaryTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    static let shared = SecondaryTransitioningDelegate()

    func animationController(
        forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return SecondaryPresentAnimationController()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SecondaryDismissAnimationController()
    }
}

class SecondaryPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? PopMenuViewController,
            let toVC = transitionContext.viewController(forKey: .to) as? PopMenuViewController
        else { return }
        guard let expandAction = toVC.actions.first as? DidExpandAction else {
            transitionContext.completeTransition(true)
            return
        }

        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        let finalFrame = toVC.contentFrame
        // 1. 设置初始状态
        let oldPosition = toVC.containerView.layer.position
        if #available(iOS 16.0, *) {
            toVC.containerView.anchorPoint = CGPoint(x: 0.5, y: 0)
        }
        toVC.contentHeightConstraint.constant = expandAction.view.frame.height
        // 修改锚点后，layer的position会改变，所以需要按照动画后的 frame 重新设置
        toVC.contentTopConstraint.constant = finalFrame.minY - finalFrame.height / 2
        toVC.containerView.layoutIfNeeded()
        expandAction.expandIcon.transform = .identity
        expandAction.maskView.alpha = 0
        containerView.addSubview(toVC.view)
        fromVC.containerView.transform = .identity
        // 2. 执行动画
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveEaseInOut
        ) {
            // 旋转图标
            expandAction.expandIcon.transform = CGAffineTransform(rotationAngle: .pi / 2)
            // 显示遮罩
            expandAction.maskView.alpha = 1
            // 缩小背景
            fromVC.containerView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            // 展开菜单
            toVC.contentHeightConstraint.constant = finalFrame.height
            toVC.containerView.layoutIfNeeded()
        } completion: { finished in
            transitionContext.completeTransition(finished)
        }
    }
}

class SecondaryDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? PopMenuViewController,
            let toVC = transitionContext.viewController(forKey: .to) as? PopMenuViewController,
            let expandAction = fromVC.actions.first as? DidExpandAction
        else {
            transitionContext.completeTransition(true)
            return
        }
        let finalFrame = fromVC.contentFrame
        // 修改锚点后，layer的position会改变，所以需要按照动画后的 frame 重新设置
        fromVC.contentTopConstraint.constant = finalFrame.minY - expandAction.view.frame.height / 2
        // 执行动画
        toVC.containerView.layoutIfNeeded()
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveEaseInOut
        ) {
            // 1. 图标反向旋转
            expandAction.expandIcon.transform = .identity
            // 2. 遮罩淡出
            expandAction.maskView.alpha = 0
            // 还原背景
            toVC.containerView.transform = .identity
            // 3. 内容收缩
            fromVC.contentHeightConstraint.constant = expandAction.view.frame.height
            fromVC.containerView.layoutIfNeeded()
        } completion: { finished in
            expandAction.maskView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
