//
//  ViewController.swift
//  vorobei-challange-1
//
//  Created by Alexey Voronov on 03.07.2023.
//

import UIKit

class ViewController : UITableViewController {
    enum Section {
        case main
    }

    lazy var dataSource: UITableViewDiffableDataSource<Section ,String> = {
        let dataSource = UITableViewDiffableDataSource<Section, String>(tableView: tableView, cellProvider: { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = item
            cell.accessoryType = self.selectedItems.contains(item) ? .checkmark : .none
            return cell
        })
        return dataSource
    }()
    
    
    var dataArray = Array<Int>(0...10).map({"\($0)"})
    var selectedItems: Set<String> = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Task 4"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle", style: .done, target: self, action: #selector(shuffle))

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(dataArray)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func updateTable(withAdditionId: String? = nil) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(dataArray)
        if let withAdditionId = withAdditionId {
            snapshot.reloadItems([withAdditionId])
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc func shuffle() {
        dataArray.shuffle()
        updateTable()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        let index = indexPath.row
        let item = dataArray[indexPath.row]
        if selectedItems.contains(item) {
            selectedItems.remove(item)
            updateTable(withAdditionId: item)
        } else {
            selectedItems.insert(item)
            let item = dataArray.remove(at: index)
            dataArray.insert(item, at: 0)
            updateTable(withAdditionId: item)
        }
    }
}
