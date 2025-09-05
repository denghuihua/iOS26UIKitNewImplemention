//
//  ViewController.swift
//  UIKitNewAppearence
//
//  Created by huihuadeng on 8/25/25.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Properties
    private var containerEffectView: UIVisualEffectView!
    private var finalViews: [UIView] = []
    private var backgroundImageView: UIImageView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureControls()
        bindInteractions()
        configureNavigationBarItems()
       
    }

    // MARK: - Navigation Items
    private func configureNavigationBarItems() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(navDoneTapped))
        let flagButton = UIBarButtonItem(image: UIImage(systemName: "flag"), style: .plain, target: self, action: #selector(navFlagTapped))
        let folderButton = UIBarButtonItem(image: UIImage(systemName: "folder"), style: .plain, target: self, action: #selector(navFolderTapped))
        let infoButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(navInfoTapped))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(navShareTapped))
        let selectButton = UIBarButtonItem(title: "选择", style: .plain, target: self, action: #selector(navSelectTapped))

        navigationItem.rightBarButtonItems = [
            doneButton,
            flagButton,
            folderButton,
            infoButton,
            .fixedSpace(0),
            shareButton,
            selectButton
        ]
    }

    // MARK: - Navigation Actions
    @objc private func navDoneTapped() { print("Done tapped") }
    @objc private func navFlagTapped() { print("Flag tapped") }
    @objc private func navFolderTapped() { print("Folder tapped") }
    @objc private func navInfoTapped() { print("Info tapped") }
    @objc private func navShareTapped() { print("Share tapped") }
    @objc private func navSelectTapped() { print("Select tapped") }

    // MARK: - UIScrollViewDelegate
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return backgroundImageView
    }

    // MARK: - Setup Layout
    private func configureLayout() {
        let scrollView = setupScrollView()
        setupBackgroundImage(in: scrollView)
        setupContainerEffectView()
        createGlassViews()
        createGestureGlassViews()
    }

    private func setupScrollView() -> UIScrollView {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.delegate = self
        view.addSubview(scrollView)
        view.sendSubviewToBack(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        return scrollView
    }

    private func setupBackgroundImage(in scrollView: UIScrollView) {
        backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "bg.jpeg")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(backgroundImageView)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            backgroundImageView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
    }

    private func setupContainerEffectView() {
        let container = UIGlassContainerEffect.init()
        container.spacing = 20
        let containerView = UIVisualEffectView.init(effect: container)
        containerEffectView = containerView
        containerEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerEffectView)

        NSLayoutConstraint.activate([
            containerEffectView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerEffectView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 30),
            containerEffectView.widthAnchor.constraint(equalToConstant: 300),
            containerEffectView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    // MARK: - Setup Controls
    private func configureControls() {
        let glassButton = makeGlassProminentButton(title: "玻璃按钮带前景色", tint: .red, action: #selector(topButtonTapped))
        let button = makeGlassButton(title: "玻璃按钮")
        let rightButton = makeNormalButton(title: "普通按钮", action: #selector(rightButtonTapped))
        let slider = makeSlider()
        let switchControl = makeSwitch()

        // 使用垂直 StackView 从上到下依次排列，间隔相等
        let stack = UIStackView(arrangedSubviews: [glassButton, button, rightButton, slider, switchControl])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        // 维持控件自身尺寸
        NSLayoutConstraint.activate([
            glassButton.widthAnchor.constraint(equalToConstant: 120),
            glassButton.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 120),
            button.heightAnchor.constraint(equalToConstant: 44),
            rightButton.widthAnchor.constraint(equalToConstant: 120),
            rightButton.heightAnchor.constraint(equalToConstant: 44),
            slider.widthAnchor.constraint(equalToConstant: 200)
        ])

        // StackView 贴合上下安全区，自动等间距分布
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -320),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: - Bind Interactions
    private func bindInteractions() {
        guard let stackView = view.subviews.first(where: { $0 is UIStackView }) as? UIStackView else {
            return
        }
        let buttons = stackView.subviews.filter({ view in
            view is UIButton
        })
        buttons.forEach {
            if let button = $0 as? UIButton {
                button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            }
        }
        if let slider = stackView.subviews.first(where: { $0 is UISlider }) as? UISlider {
            slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        }
        if let switchControl = stackView.subviews.first(where: { $0 is UISwitch }) as? UISwitch {
            switchControl.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        }
    }

    // MARK: - Factory Methods
    private func makeGlassProminentButton(title: String, tint: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.configuration = .prominentGlass()
        button.tintColor = tint
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func makeGlassButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.configuration = .glass()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    private func makeNormalButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func makeSlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.value = 2
        slider.trackConfiguration = .init(allowsTickValuesOnly: true, neutralValue: 0.2, numberOfTicks: 4)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }

    private func makeSwitch() -> UISwitch {
        let switchControl = UISwitch()
        switchControl.isOn = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }

    // MARK: - Actions
    @objc func addButtonTapped() {
        print("点击了添加按钮")
    }

    @objc func rightButtonTapped() {
        let container = UIGlassContainerEffect()
        UIView.animate {
            containerEffectView.effect = container
        }
    }

    @objc func topButtonTapped() {
        let container = UIGlassContainerEffect()
        UIView.animate {
            containerEffectView.effect = nil
        }
    }

    @objc func buttonTapped() {
        print("按钮被点击了！")
        guard let containerEffectView = self.view.subviews.first(where: { $0 is UIVisualEffectView }) as? UIVisualEffectView else {
            print("未找到玻璃容器视图")
            return
        }
        let glassViews = containerEffectView.contentView.subviews.compactMap { $0 as? UIVisualEffectView }
        guard glassViews.count >= 2 else {
            print("未找到两个玻璃子视图")
            return
        }
        let view1 = glassViews[0]
        let view2 = glassViews[1]

        let originalView1Frame = view1.frame
        let originalView2Frame = view2.frame

        if CGRectEqualToRect(originalView1Frame, originalView2Frame) {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: []) {
                view1.frame.origin.x = (originalView1Frame.origin.x + originalView2Frame.origin.x) / 2 - 5 - originalView1Frame.size.width/2
                view2.frame.origin.x = (originalView1Frame.origin.x + originalView2Frame.origin.x) / 2 + 5 + originalView1Frame.size.width/2
            } completion: { _ in
                print("玻璃分割动画完成")
            }
        } else {
            UIView.animate {
                view1.frame.origin.x = (originalView1Frame.origin.x + originalView2Frame.origin.x) / 2
                view2.frame.origin.x = (originalView1Frame.origin.x + originalView2Frame.origin.x) / 2
            }
        }
    }

    // MARK: - Gesture Handling
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        print("handlePanGesture")
        if gesture.state == .began || gesture.state == .changed {
            let translation = gesture.translation(in: backgroundImageView)
            guard let panView = gesture.view else { return }
            panView.center = CGPoint(x: panView.center.x + translation.x, y: panView.center.y + translation.y)
            gesture.setTranslation(.zero, in: view)
        }
    }

    // MARK: - Glass Effects
    private func createGestureGlassViews() {
        let glassEffect = UIGlassEffect()
        glassEffect.isInteractive = true
        glassEffect.tintColor = UIColor.black
        let view1 = UIVisualEffectView(effect: glassEffect)
        view1.cornerConfiguration = .capsule(maximumRadius: 400)
        view1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view1)

        NSLayoutConstraint.activate([
            view1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view1.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            view1.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            view1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25)
        ])

        let panGesture = UIPanGestureRecognizer()
        view1.addGestureRecognizer(panGesture)
        panGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
    }

    private func createGlassViews() {
        let glassEffect = UIGlassEffect()
        glassEffect.isInteractive = true
        let view1 = UIVisualEffectView(effect: glassEffect)
        let view2 = UIVisualEffectView(effect: glassEffect)

        view1.translatesAutoresizingMaskIntoConstraints = false
        view2.translatesAutoresizingMaskIntoConstraints = false

        containerEffectView.contentView.addSubview(view1)
        containerEffectView.contentView.addSubview(view2)

        NSLayoutConstraint.activate([
            view1.leadingAnchor.constraint(equalTo: containerEffectView.contentView.leadingAnchor, constant: 10),
            view1.topAnchor.constraint(equalTo: containerEffectView.contentView.topAnchor, constant: 10),
            view1.bottomAnchor.constraint(equalTo: containerEffectView.contentView.bottomAnchor, constant: -10),
            view1.widthAnchor.constraint(equalTo: containerEffectView.contentView.widthAnchor, multiplier: 0.45),

            view2.trailingAnchor.constraint(equalTo: containerEffectView.contentView.trailingAnchor, constant: -10),
            view2.topAnchor.constraint(equalTo: containerEffectView.contentView.topAnchor, constant: 10),
            view2.bottomAnchor.constraint(equalTo: containerEffectView.contentView.bottomAnchor, constant: -10),
            view2.widthAnchor.constraint(equalTo: containerEffectView.contentView.widthAnchor, multiplier: 0.45)
        ])

        addContentToGlassView(view1, title: "玻璃视图 1")
        addContentToGlassView(view2, title: "玻璃视图 2")
    }

    private func addContentToGlassView(_ glassView: UIVisualEffectView, title: String) {
        let label = UILabel()
        label.text = title
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false

        glassView.contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: glassView.contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: glassView.contentView.centerYAnchor)
        ])
    }

    // MARK: - Slider & Switch Handlers
    @objc func sliderValueChanged(_ sender: UISlider) {
        print("滑块值: \(sender.value)")
    }

    @objc func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            // 示例：此处演示使用 ToolbarSearchController 的行为
            let toolbarSearchController = ToolbarSearchController(hostViewController: self)
            self.navigationController?.pushViewController(toolbarSearchController, animated: true)
        }
    }
    
    func setupToolbar() {
            let searchController = ToolbarSearchController(hostViewController: self)
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = true
            navigationController?.isToolbarHidden = false
            let searchItem = navigationItem.searchBarPlacementBarButtonItem
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
            let flexibleSpace = UIBarButtonItem.flexibleSpace()
            flexibleSpace.hidesSharedBackground = false
            toolbarItems = [addButton, flexibleSpace, searchItem]
            self.tabBarController?.isTabBarHidden = true
    }

    
}
