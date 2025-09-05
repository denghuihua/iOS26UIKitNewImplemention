//
//  MenuViewController.swift
//  UIKitNewAppearence
//
//  Created by huihuadeng on 8/25/25.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "菜单视图"
        
        // 添加一些内容到视图中
        let label = UILabel()
        label.text = "这是菜单视图控制器\n点击右上角按钮查看菜单"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
        
        // 添加一个状态标签来显示菜单选择结果
        let statusLabel = UILabel()
        statusLabel.text = "等待菜单选择..."
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        statusLabel.textColor = .secondaryLabel
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.tag = 999 // 用于后续更新
        
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            statusLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupNavigationBar() {
        // 创建右上角菜单按钮
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(menuButtonTapped)
        )
        
        navigationItem.rightBarButtonItem = menuButton
    }
    
    @objc private func menuButtonTapped() {
        // 创建菜单项
        let editAction = UIAction(
            title: "编辑",
            image: UIImage(systemName: "pencil"),
            handler: { [weak self] _ in
                self?.handleMenuAction("编辑")
            }
        )
        
        let shareAction = UIAction(
            title: "分享",
            image: UIImage(systemName: "square.and.arrow.up"),
            handler: { [weak self] _ in
                self?.handleMenuAction("分享")
            }
        )
        
        let deleteAction = UIAction(
            title: "删除",
            image: UIImage(systemName: "trash"),
            attributes: .destructive,
            handler: { [weak self] _ in
                self?.handleMenuAction("删除")
            }
        )
        
        let settingsAction = UIAction(
            title: "设置",
            image: UIImage(systemName: "gear"),
            handler: { [weak self] _ in
                self?.handleMenuAction("设置")
            }
        )
        
        // 创建子菜单
        let moreAction = UIAction(
            title: "更多选项",
            image: UIImage(systemName: "ellipsis"),
            handler: { [weak self] _ in
                self?.showMoreOptionsMenu()
            }
        )
        
        // 创建菜单
        let menu = UIMenu(
            title: "选择操作",
            children: [
                editAction,
                shareAction,
                UIMenu(title: "", options: .displayInline, children: [
                    deleteAction
                ]),
                settingsAction,
                moreAction
            ]
        )
        
        // 创建菜单按钮
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            menu: menu
        )
        
        navigationItem.rightBarButtonItem = menuButton
    }
    
    private func showMoreOptionsMenu() {
        let copyAction = UIAction(
            title: "复制",
            image: UIImage(systemName: "doc.on.doc"),
            handler: { [weak self] _ in
                self?.handleMenuAction("复制")
            }
        )
        
        let pasteAction = UIAction(
            title: "粘贴",
            image: UIImage(systemName: "doc.on.clipboard"),
            handler: { [weak self] _ in
                self?.handleMenuAction("粘贴")
            }
        )
        
        let moreMenu = UIMenu(
            title: "更多选项",
            children: [copyAction, pasteAction]
        )
        
        // 显示子菜单
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            menu: moreMenu
        )
        
        navigationItem.rightBarButtonItem = menuButton
    }
    
    private func handleMenuAction(_ action: String) {
        print("用户选择了: \(action)")
        
        // 更新状态标签
        if let statusLabel = view.viewWithTag(999) as? UILabel {
            statusLabel.text = "已选择: \(action)"
            statusLabel.textColor = .systemBlue
            
            // 2秒后恢复原状态
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                statusLabel.text = "等待菜单选择..."
                statusLabel.textColor = .secondaryLabel
            }
        }
        
        // 显示提示
        let alert = UIAlertController(
            title: "菜单选择",
            message: "您选择了: \(action)",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "确定", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
