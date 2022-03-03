//
//  Sample2VC.swift
//  UIKitCustomModalSheetPresentationSample
//
//  Created by Hoon H. on 2022/03/02.
//

import Foundation
import UIKit

final class Sample2VC: UIViewController {
    private let transition = Sample2TransitionController()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sample 2"
        view.backgroundColor = .systemBackground
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vc = Sample2ContentVC()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = transition
        present(vc, animated: true, completion: nil)
    }
}

private final class Sample2ContentVC: UIViewController {
    private let pan = UIPanGestureRecognizer()
    override func loadView() {
        view = Sample2ContentView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addGestureRecognizer(pan)
        pan.addTarget(self, action: #selector(onPan(_:)))
    }
    @objc func onPan(_ pan:UIPanGestureRecognizer) {
        let p = pan.translation(in: pan.view)
        switch pan.state {
        case .changed:
            if p.y < 0 {
                let a = -p.y
                let b = log2(a)
                let c = a * 0.2 + b * 0.8   /// Blend appropriately.
                let h = view.sizeThatFits(.zero).height + c
                let f = presentationController?.containerView?.bounds.divided(atDistance: h, from: .maxYEdge).slice ?? .zero
                view.frame = f
            }
            else {
                let h = view.sizeThatFits(.zero).height + (-p.y)
                let f = presentationController?.containerView?.bounds.divided(atDistance: h, from: .maxYEdge).slice ?? .zero
                view.frame = f
            }
        case .ended, .cancelled:
            if p.y > 100 {
                dismiss(animated: true)
            }
            else {
                let h = view.sizeThatFits(.zero).height
                let f = presentationController?.containerView?.bounds.divided(atDistance: h, from: .maxYEdge).slice ?? .zero
                let a = UIViewPropertyAnimator(duration: 0.25, dampingRatio: 1) { [weak view] in
                    view?.frame = f
                }
                a.startAnimation()
            }
        default:
            break
        }
    }
}

private final class Sample2ContentView: UIView {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(width: 100, height: 300)
    }
}

private final class Sample2TransitionController: NSObject, UIViewControllerTransitioningDelegate {
    let interactionController = UIPercentDrivenInteractiveTransition()
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        Sample2PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactionController
    }
}

private final class Sample2PresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        let sz = presentedView?.sizeThatFits(.zero) ?? .zero
        return containerView?.bounds.divided(atDistance: sz.height, from: .maxYEdge).slice ?? .zero
    }
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
    }
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
    }
}

