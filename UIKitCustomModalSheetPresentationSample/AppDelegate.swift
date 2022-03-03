//
//  AppDelegate.swift
//  UIKitCustomModalSheetPresentationSample
//
//  Created by Hoon H. on 2022/03/01.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var root = Root?.none
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        root = Root()
        return true
    }
}

final class Root {
    private let mainWindow = UIWindow(frame: UIScreen.main.bounds)
    private let mainNC = UINavigationController()
    private let menuVC = MenuVC()
    init() {
        mainWindow.makeKeyAndVisible()
        mainWindow.rootViewController = mainNC
        mainNC.viewControllers = [menuVC]
    }
}

struct MenuItem {
    var label: String
    var action: () -> UIViewController
}
final class MenuVC: UITableViewController {
    let items = [
        MenuItem(label: "Non-Interactive Animation Only", action: Sample1VC.init),
        MenuItem(label: "Interactive Dissmiss", action: Sample2VC.init),
    ]
    private var dataSource = UITableViewDiffableDataSource<Int,Int>?.none
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sample"
        view.backgroundColor = .systemBackground
        let items = items
        var snapshot = NSDiffableDataSourceSnapshot<Int,Int>()
        snapshot.appendSections([0])
        snapshot.appendItems(Array(items.indices), toSection: 0)
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            var cc = cell.defaultContentConfiguration()
            cc.image = UIImage(systemName: "star")
            cc.text = items[itemIdentifier].label
            cell.contentConfiguration = cc
            return cell
        })
        dataSource?.apply(snapshot, animatingDifferences: false, completion: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = items[indexPath.row].action()
        navigationController?.pushViewController(vc, animated: true)
    }
}
