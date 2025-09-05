//
//  EdgeEffectViewController.swift
//  UIKitNewAppearence
//
//  Created by huihuadeng on 9/3/25.
//

import UIKit

final class EdgeEffectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let buttonsContainerView = UIVisualEffectView(effect: UIGlassEffect.init())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.isTabBarHidden = true
        // 显示底部工具栏
        navigationController?.isToolbarHidden = true
        view.backgroundColor = .systemBackground
        title = "Edge效果"

        setupTableView()
        tableView.backgroundColor = UIColor.systemPink
        setupButtonsContainer()
        setupEdgeInteraction()
    }

    // MARK: - TableView
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = "第 \(indexPath.row + 1) 行"
        config.secondaryText = "这是自定义内容"
        cell.contentConfiguration = config
        return cell
    }

    // MARK: - Bottom Container
    private func setupButtonsContainer() {
        buttonsContainerView.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainerView.layer.cornerRadius = 14
        buttonsContainerView.clipsToBounds = true
        view.addSubview(buttonsContainerView)

        NSLayoutConstraint.activate([
            buttonsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            buttonsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            buttonsContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -200),
            buttonsContainerView.heightAnchor.constraint(equalToConstant: 160)
        ])

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false

        let btn1 = UIButton(type: .system)
        btn1.setTitle("切换边缘效果", for: .normal)
        btn1.addTarget(self, action: #selector(toggleEdgeEffect), for: .touchUpInside)
        // 实现切换边缘效果的方法

        buttonsContainerView.contentView.addSubview(stack)
        stack.addArrangedSubview(btn1)
        

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: buttonsContainerView.contentView.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: buttonsContainerView.contentView.trailingAnchor, constant: -12),
            stack.heightAnchor.constraint(equalToConstant: 40),
            stack.bottomAnchor.constraint(equalTo: buttonsContainerView.contentView.bottomAnchor, constant: -100)
        ])
    }

    // MARK: - Edge effect’s custom container
    private func setupEdgeInteraction() {
        // 参考 WWDC25：将容器与滚动视图的边缘效果关联
        let interaction = UIScrollEdgeElementContainerInteraction()
        interaction.scrollView = tableView
        interaction.edge = .bottom
        buttonsContainerView.addInteraction(interaction)
    }
    
    @objc private func toggleEdgeEffect() {
        // 假设我们用一个属性来记录当前是否启用边缘效果
        // 这里用 tag 作为简单状态存储（0: 启用，1: 禁用）
        if buttonsContainerView.tag == 0 {
            // 移除边缘效果交互
            for interaction in buttonsContainerView.interactions {
                buttonsContainerView.removeInteraction(interaction)
            }
            tableView.topEdgeEffect.style = .hard
            buttonsContainerView.tag = 1
            // 可选：提示用户
            if let window = view.window {
                let alert = UIAlertController(title: "边缘效果已关闭", message: "已移除底部边缘效果", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "确定", style: .default))
                window.rootViewController?.presentedViewController?.dismiss(animated: false)
                window.rootViewController?.present(alert, animated: true)
            }
        } else {
            tableView.topEdgeEffect.style = .soft
            // 重新添加边缘效果交互
            let interaction = UIScrollEdgeElementContainerInteraction()
            interaction.scrollView = tableView
            interaction.edge = .bottom
            buttonsContainerView.addInteraction(interaction)
            buttonsContainerView.tag = 0
            // 可选：提示用户
            if let window = view.window {
                let alert = UIAlertController(title: "边缘效果已开启", message: "已恢复底部边缘效果", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "确定", style: .default))
                window.rootViewController?.presentedViewController?.dismiss(animated: false)
                window.rootViewController?.present(alert, animated: true)
            }
        }
    }

}
