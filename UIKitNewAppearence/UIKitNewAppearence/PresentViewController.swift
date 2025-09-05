//
//  PresentViewController.swift
//  UIKitNewAppearence
//
//  Created by huihuadeng on 9/3/25.
//

import UIKit

final class PresentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Present"
        setupUI()
    }

    private func setupUI() {
        let alertButton = UIButton(type: .system)
        alertButton.setTitle("跳转 AlertViewController", for: .normal)
        alertButton.configuration = .filled()
        alertButton.translatesAutoresizingMaskIntoConstraints = false
        alertButton.addTarget(self, action: #selector(showAlertVC), for: .touchUpInside)

        let menuButton = UIButton(type: .system)
        menuButton.setTitle("跳转 MenuViewController", for: .normal)
        menuButton.configuration = .filled()
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.addTarget(self, action: #selector(showMenuVC), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [alertButton, menuButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            alertButton.widthAnchor.constraint(equalToConstant: 220),
            alertButton.heightAnchor.constraint(equalToConstant: 44),
            menuButton.widthAnchor.constraint(equalToConstant: 220),
            menuButton.heightAnchor.constraint(equalToConstant: 44),

            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Actions
    @objc private func showAlertVC() {
        let vc = AlertViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }

    @objc private func showMenuVC() {
        let vc = MenuViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true)
    }
}
