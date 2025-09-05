//
//  SecondViewController.swift
//  UIKitNewAppearence
//
//  Created by huihuadeng on 8/25/25.
//

import UIKit

class AlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "二级视图"
        
        // 添加一些内容到视图中
        let label = UILabel()
        label.text = "这是二级视图控制器\n点击右上角按钮查看 Alert"
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
    }
    
    private func setupNavigationBar() {
        // 创建右上角按钮
        let alertButton = UIBarButtonItem(
            title: "Alert",
            style: .plain,
            target: self,
            action: #selector(alertButtonTapped)
        )
        navigationItem.rightBarButtonItem = alertButton
    }
    
    @objc private func alertButtonTapped() {
        let alert = UIAlertController(
            title: "提示",
            message: "这是一个 AlertView 弹窗！",
            preferredStyle: .actionSheet
        )
        // 添加确定按钮
        let okAction = UIAlertAction(title: "确定", style: .default) { _ in
            print("用户点击了确定按钮")
        }
        // 添加确定按钮
        let okAction1 = UIAlertAction(title: "确定", style: .default) { _ in
            print("用户点击了确定按钮")
        }
        // 添加确定按钮
        let okAction2 = UIAlertAction(title: "确定", style: .default) { _ in
            print("用户点击了确定按钮")
        }
        // 添加确定按钮
        let okAction3 = UIAlertAction(title: "确定", style: .default) { _ in
            print("用户点击了确定按钮")
        }
        alert.addAction(okAction)
        alert.addAction(okAction1)
        alert.addAction(okAction2)
        alert.addAction(okAction3)
        //关键代码
        alert.popoverPresentationController?.sourceItem = navigationItem.rightBarButtonItem
                // 5. Present the popover view controller
        present(alert, animated: true, completion: nil)
    }
}
