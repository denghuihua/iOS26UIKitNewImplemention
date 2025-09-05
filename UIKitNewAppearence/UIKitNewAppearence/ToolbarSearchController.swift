import UIKit

final class ToolbarSearchController: UISearchController, UISearchResultsUpdating {
    weak var hostViewController: UIViewController?

    private(set) lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()

    // 便捷初始化，指定宿主控制器
    convenience init(hostViewController: UIViewController) {
        self.init(searchResultsController: nil)
        self.hostViewController = hostViewController
        commonInit()
    }

    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        configureSearch()
        configureToolbar()
    }

    private func configureSearch() {
        obscuresBackgroundDuringPresentation = false
        searchBar.placeholder = "搜索"
        searchResultsUpdater = self
    }

    func configureToolbar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        let searchItem: UIBarButtonItem
        if let host = hostViewController {
            searchItem = host.navigationItem.searchBarPlacementBarButtonItem
        } else {
            searchItem = UIBarButtonItem(systemItem: .flexibleSpace)
        }
        toolbar.items = [addButton, .flexibleSpace(), searchItem]
    }

    func refreshItems() {
        configureToolbar()
    }

    @objc private func addButtonTapped() {
        print("点击了添加按钮")
    }

    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        // 根据需要更新搜索结果；此处仅作示例打印
        let text = searchController.searchBar.text ?? ""
        if !text.isEmpty {
            print("搜索: \(text)")
        }
    }
}
