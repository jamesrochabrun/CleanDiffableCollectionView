//
//  ViewController.swift
//  CleanDiffableCollectionView
//
//  Created by james rochabrun on 9/3/20.
//  Copyright © 2020 james rochabrun. All rights reserved.
//

import UIKit


enum Section: Int, CaseIterable {
    case tom
    case mail
}

class ViewController: UIViewController, UITableViewDataSource {
    
    var items = Array(0...100)
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.registerNib(TOMCollectionViewContainerTableViewCell.self)
            tableView.register(UITableViewCell.self)
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 150
            tableView.dataSource = self
        }
    }
    
    var model = TOMMultiColumnCouponViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigationItems()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .tom: return 1
        case .mail: return items.count
        default: return 0
        }
    }

    private func setupNavigationItems() {
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch Section(rawValue: indexPath.section) {
        case .tom:
            let cell: TOMCollectionViewContainerTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.item = model
            cell.delegate = self
            return cell
        case .mail:
            let cell: UITableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let num = items[indexPath.item]
            cell.backgroundColor = indexPath.section == 0 ? .yellow : .darkGray
            cell.tag = indexPath.section == 0 ? 0 : 1
            cell.textLabel?.text = "\(num)"
            return cell
        default: return tableView.dequeueReusableCell(forIndexPath: indexPath)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
}

extension ViewController: TOMCollectionViewContainerTableViewCellDelegate {

    
    func updateUI() {
        tableView.reloadSections([Section.tom.rawValue], with: .automatic)
    }
}

