//
//  ViewController.swift
//  splitvc-test
//
//  Created by 垣本 桃弥 on 2023/05/26.
//

import UIKit

class ViewController: UIViewController {
    
    let splitVC = UISplitViewController(style: .doubleColumn)
    var hideBarButton: UIBarButtonItem!
    var showBarButton: UIBarButtonItem!
    
    var isExplorerHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuVC = MenuViewController()
        let mainVC = UIViewController()
        menuVC.view.backgroundColor = .systemBrown
        mainVC.view.backgroundColor = .systemMint
        
        splitVC.viewControllers = [
            UINavigationController(rootViewController: menuVC),
            UINavigationController(rootViewController: mainVC)
        ]
        
        splitVC.modalPresentationStyle = .fullScreen
        present(splitVC, animated: false)
        splitVC.show(.primary)
        
        splitVC.presentsWithGesture = false
        hideBarButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.left.and.arrow.down.right"),
            style: .plain,
            target: self,
            action: #selector(didTapHideBarButton))
        showBarButton = UIBarButtonItem(
            image: UIImage(systemName: "sidebar.left"),
            style: .plain,
            target: self,
            action: #selector(didTapShowBarButton))
        mainVC.navigationItem.leftBarButtonItems = [hideBarButton, showBarButton]
        for barButtonItem in mainVC.navigationItem.leftBarButtonItems! {
            barButtonItem.tintColor = .black
        }
        showBarButton.isHidden = true
        
        menuVC.delegate = self
        splitVC.delegate = self
    }
    
    @objc func didTapHideBarButton() {
        hideBarButton.isHidden = true
        showBarButton.isHidden = false
        splitVC.show(.secondary)
        splitVC.hide(.primary)
    }
    
    @objc func didTapShowBarButton() {
        hideBarButton.isHidden = false
        showBarButton.isHidden = true
        splitVC.show(.primary)
        splitVC.hide(.secondary)
    }
    
    private func updateHideAndShowButtonState() {
        hideBarButton.isHidden = isExplorerHidden
        showBarButton.isHidden = !isExplorerHidden
    }

}

extension ViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, willShow column: UISplitViewController.Column) {
        guard column.rawValue == 0 else { return }
        isExplorerHidden = false
        updateHideAndShowButtonState()
    }
    
    func splitViewController(_ svc: UISplitViewController, willHide column: UISplitViewController.Column) {
        guard column.rawValue == 0 else { return }
        isExplorerHidden = true
        updateHideAndShowButtonState()
    }
}

extension ViewController: MenuViewControllerDelegate {
    func hideMenu() {
        if splitVC.displayMode != .oneBesideSecondary {
            didTapHideBarButton()
        }
    }
}


protocol MenuViewControllerDelegate {
    func hideMenu()
}

class MenuViewController: UIViewController {
    let transitionButton: UIButton = {
        let button = UIButton()
        button.setTitle("transition", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    var delegate: MenuViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitionButton.frame = CGRect(x: 150, y: 100, width: 200, height: 50)
        view.addSubview(transitionButton)
        transitionButton.addTarget(self, action: #selector(didTapTransitionButton(_:)), for: .touchUpInside)
    }
    
    @objc func didTapTransitionButton(_ sender: UIButton) {
        delegate.hideMenu()
    }
}
