//
//  InventoryDetailViewController.swift
//  zaico_ios_codingtest
//
//  Created by ryo hirota on 2025/03/11.
//

import UIKit

class InventoryDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    
    private var input: InventoryDetailPresenterInput!
    private func inject(input: InventoryDetailPresenterInput) {
        self.input = input
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "詳細情報"
        view.backgroundColor = .white
        
        setupTableView()
        
        input.fetchDetailData()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(InventoryCell.self, forCellReuseIdentifier: "InventoryCell")
        tableView.register(InventoryImageCell.self, forCellReuseIdentifier: "InventoryImageCell")
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
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
            cell.configure(leftText: input.cellTitle(index: indexPath.row),
                           rightText: String(input.inventory?.id ?? 0))
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryImageCell", for: indexPath) as! InventoryImageCell
            if let imageURL = input.inventory?.itemImage?.url {
                cell.configure(leftText: input.cellTitle(index: indexPath.row),
                               rightImageURLString: imageURL)
            } else {
                cell.configure(leftText: input.cellTitle(index: indexPath.row),
                               rightImageURLString: "imageURL")
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
            cell.configure(leftText: input.cellTitle(index: indexPath.row),
                           rightText: input.inventory?.title ?? "")
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
            var quantity = "0"
            if let q = input.inventory?.quantity {
                quantity = String(q)
            }
            cell.configure(leftText: input.cellTitle(index: indexPath.row),
                           rightText: quantity)
            return cell
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension InventoryDetailViewController: InventoryDetailPresenterOutput {
    func reloadData() {
        tableView.reloadData()
    }
}

extension InventoryDetailViewController {
    static func viewController(inventoryId: Int) -> UIViewController {
        let detailVC = InventoryDetailViewController()
        let presenter = InventoryDetailPresenter(inventoryId: inventoryId, output: detailVC)
        detailVC.inject(input: presenter)
        return detailVC
    }
}
