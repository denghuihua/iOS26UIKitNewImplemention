//
//  TabbarController.swift
//  UIKitNewAppearence
//
//  Created by huihuadeng on 9/2/25.
//

import UIKit

// MARK: - 自定义UITabBarController
class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tabs.append(configFirstTab())
        tabs.append(configTab(EdgeEffectViewController(), title: "EdgeEffect", imageName: "person.2", identifier: "contacts"))
        tabs.append(configTab(ToolbarController.init(), title: "toolbar", imageName: "safari", identifier: "discover"))
        tabs.append(configTab(PresentViewController(), title: "present", imageName: "person", identifier: "me"))
        tabs.append(configSearchTab(UIViewController(), title: "搜索"))
        selectedTab = tabs.last
        // iOS26新增，向下滚动时，只显示第一个与UISearchTab的图标，中间显示辅助UITabAccessory
        self.tabBarMinimizeBehavior = .onScrollDown
        // iOS26新增
        let accessoryContainer = createAccessoryContainer()
//        self.bottomAccessory = UITabAccessory(contentView: accessoryContainer)
    }
    
    func createAccessoryContainer() -> UIToolbar{
        // 将 accessoryView 替换为 Label，并支持 trait 变化时缩放
        let accessoryContainer = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 260, height: 36))
        let accessoryLabel = UILabel()
        accessoryLabel.text = "我是accessoryVIew"
        accessoryLabel.textAlignment = .center
        accessoryLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        accessoryLabel.textColor = .black
//        accessoryLabel.backgroundColor = .white
        accessoryLabel.layer.cornerRadius = 8
        accessoryLabel.clipsToBounds = true
        accessoryLabel.frame = accessoryContainer.frame
        accessoryLabel.isUserInteractionEnabled = false
        accessoryContainer.addSubview(accessoryLabel)
        // 方案一：根据 UITraitTabAccessoryEnvironment 变化动态缩放
        accessoryContainer.registerForTraitChanges([UITraitTabAccessoryEnvironment.self]) { (cotainer:UIToolbar, _) in
            let isInline = cotainer.traitCollection.tabAccessoryEnvironment == .inline
            // tabbar最小化时缩小label并靠右下角
            if isInline {
                accessoryContainer.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                accessoryContainer.frame = CGRect(x: 120, y: 10, width: 100, height: 38)
            } else {
                accessoryContainer.transform = .identity
                accessoryContainer.frame = CGRect(x: 0, y: 0, width: 260, height: 36)
            }
        }
        return accessoryContainer
    }
    
    // MARK: 设置UITab
    func configFirstTab() -> UITab {
        let tab = UITab(title: "主页", image: UIImage(systemName: "message"), identifier: "主页") { tab in
            tab.badgeValue = "NEW"
            tab.userInfo = "主页"
            // 第一个 Tab：导航 + ViewController，包含搜索
            let mainVC = ViewController()
            let nav = UINavigationController(rootViewController: mainVC)
            return nav
        }
        return tab
    }
    func configTab(_ viewController: UIViewController,
                   title: String,
                   imageName: String,
                   identifier: String,
                   badgeValue: String? = nil) -> UITab {
        let tab = UITab(title: title, image: UIImage(systemName: imageName), identifier: identifier) { tab in
            tab.badgeValue = badgeValue
            tab.userInfo = identifier
            let scrollView = UIScrollView(frame: UIScreen.main.bounds)
            scrollView.backgroundColor = .init(red: .random(in: 0 ... 1), green: .random(in: 0 ... 1), blue: .random(in: 0 ... 1), alpha: 1.0)
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1500)
            viewController.view.addSubview(scrollView)
            viewController.view.sendSubviewToBack(scrollView)
            return self.configViewController(viewController: viewController, title: title)
        }
        return tab
    }

    // MARK: 设置UISearchTab
    func configSearchTab(_ viewController: UIViewController, title: String) -> UISearchTab {
        // UISearchTab，从TabBar分离出来单独显示
        let searchTab = UISearchTab { tab in
            let resultVC = PresentViewController.init()
            // 配置搜索控制器
            let searchController = ToolbarSearchController(hostViewController: resultVC)
            searchController.searchBar.searchTextField.placeholder = "花花"
            // 关键：将searchController赋值给navigationItem
            resultVC.navigationItem.searchController = searchController
            resultVC.navigationItem.hidesSearchBarWhenScrolling = false
//            // 进入时自动激活搜索栏
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                searchController.isActive = true
//            }
            return self.configViewController(viewController: resultVC, title: title)
        }
        searchTab.automaticallyActivatesSearch = true
        return searchTab
    }

    // MARK: 设置UIViewController
    func configViewController(viewController: UIViewController, title: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.title = title
        return navigationController
    }
}
