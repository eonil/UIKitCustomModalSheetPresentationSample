//
//  Sample1VC.swift
//  UIKitCustomModalSheetPresentationSample
//
//  Created by Hoon H. on 2022/03/02.
//

import Foundation
import UIKit

final class Sample1VC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sample 1"
        view.backgroundColor = .systemBackground
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vc = ContentVC()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = tx
        present(vc, animated: true, completion: nil)
    }
    private let tx = Sample1TransitionController()
}

private final class ContentVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dismiss(animated: true, completion: nil)
    }
}

private final class Sample1TransitionController: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        Sample1PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

private final class Sample1PresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        containerView?.bounds.divided(atDistance: 100, from: .maxYEdge).slice ?? .zero
    }
}
