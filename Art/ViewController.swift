//
//  ViewController.swift
//  Art
//
//  Created by Zhigulyaka on 20.07.2022.
//

import UIKit

class ViewController: BaseViewController {
    
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        configureNavBar()
        configureSearchBar()
        configureTableView()
    }

    // MARK: - Configure

    private func configureTableView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // for drawing large navigation bar
            self.tableView = self.placeTableView(tableStyle: .insetGrouped)
            self.tableView.backgroundColor = .clear
        }
    }

    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func configureSearchBar() {
        addSearchController(.white, .black)
    }
}

