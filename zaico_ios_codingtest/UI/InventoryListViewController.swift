//
//  ViewController.swift
//  zaico_ios_codingtest
//
//  Created by ryo hirota on 2025/03/11.
//

import UIKit

class InventoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    
    private var input: InventoryListPresenterInput!
    func inject(input: InventoryListPresenterInput) {
        self.input = input
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "在庫一覧"
        
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        input.fetchListData()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tappedAddButton))
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "InventoryListViewController_addButton"
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(InventoryCell.self, forCellReuseIdentifier: "InventoryCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return input.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
        let inventory = input.item(index: indexPath.row)
        cell.configure(leftText: String(inventory.id),
                       rightText: inventory.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        input.didSelectCell(index: indexPath.row)
    }
}

extension InventoryListViewController: InventoryListPresenterOutput {
    func reloadData() {
        tableView.reloadData()
    }
    
    func showInventoryDetail(inventory: Inventory) {
        let detailVC = InventoryDetailViewController.viewController(inventoryId: inventory.id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func showInventoryCreate() {
        let createVC = InventoryCreateViewController()
        navigationController?.pushViewController(createVC, animated: true)
    }
    
}

extension InventoryListViewController {
    @objc private func tappedAddButton() {
        input.didTapAdd()
    }
}

extension InventoryListViewController {
    static var viewContoroller: UIViewController {
        let listVC = InventoryListViewController()
        let presenter = InventoryListPresenter(output: listVC)
        listVC.inject(input: presenter)
        return listVC
    }
}
