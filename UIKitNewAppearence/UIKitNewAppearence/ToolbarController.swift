//
//  ToolbarController.swift
//  UIKitNewAppearence
//
//  Created by huihuadeng on 9/3/25.
//

import UIKit

final class ToolbarController: UIViewController {

    // MARK: - Public
    private(set) lazy var toolbar: UIToolbar = {
        let tb = UIToolbar()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()

    weak var hostViewController: UIViewController?

    // MARK: - Lifecycle
    convenience init(hostViewController: UIViewController?) {
        self.init(nibName: nil, bundle: nil)
        self.hostViewController = hostViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupToolbar()
//        configureDefaultItems()
        setupToolbarItems()
    }

    // MARK: - Setup
    private func setupToolbar() {
        view.addSubview(toolbar)
        // 记录底部约束，便于后续动态调整
        let toolbarBottomConstraint = toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbarBottomConstraint
        ])
        
        // 监听键盘弹出与收起
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) { [weak self] notification in
            guard let self = self,
                  let userInfo = notification.userInfo,
                  let keyboardFrameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                  let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
                  let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
            else { return }
            
            // 键盘在本控制器view坐标系下的frame
            let keyboardFrameInView = self.view.convert(keyboardFrameEnd, from: nil)
            let overlap = max(self.view.bounds.maxY - keyboardFrameInView.origin.y, 0)
            
            // 动画同步键盘
            let options = UIView.AnimationOptions(rawValue: curveRaw << 16)
            toolbarBottomConstraint.constant = -overlap
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    // MARK: - Configuration
    func configureDefaultItems() {
        // 工具栏均匀分布的按钮，全部在同一背景组
        let flexibleSpace = UIBarButtonItem.flexibleSpace()
        flexibleSpace.hidesSharedBackground = false

        toolbar.items = [
            .init(image: UIImage(systemName: "location")),
            flexibleSpace,
            .init(image: UIImage(systemName: "number")),
            flexibleSpace,
            .init(image: UIImage(systemName: "camera")),
            flexibleSpace,
            navigationItem.searchBarPlacementBarButtonItem
        ]
    }
    
    func setupToolbarItems() {
        //不配置searchController searchIcon不显示
        let searchController = ToolbarSearchController(hostViewController: self)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.isToolbarHidden = false
        let searchItem = navigationItem.searchBarPlacementBarButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        let flexibleSpace = UIBarButtonItem.flexibleSpace()
        flexibleSpace.hidesSharedBackground = false
        toolbar.items = [addButton, flexibleSpace, searchItem]
//        navigationController?.toolbarItems = [addButton, flexibleSpace, searchItem]
        self.tabBarController?.isTabBarHidden = true
    }

    func setItems(_ items: [UIBarButtonItem], animated: Bool = true) {
        toolbar.setItems(items, animated: animated)
    }

    func refresh() {
        configureDefaultItems()
    }

    // MARK: - Actions
    @objc private func addTapped() { print("Toolbar Add tapped") }
    @objc private func shareTapped() { print("Toolbar Share tapped") }
}
