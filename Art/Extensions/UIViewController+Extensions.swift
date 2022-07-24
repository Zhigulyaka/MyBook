//
//  UIViewController+Extensions.swift
//  Art
//
//  Created by Zhigulyaka on 22.07.2022.
//

import Foundation
import UIKit

extension UIViewController {
    /// Add `UITableView` as subview to a view of current `UIViewController`.
    ///
    /// - Parameters:
    ///     - top:      `CGFloat` top inset from super view `UIView`.
    ///     - bottom:   `CGFloat` bottom inset from super view `UIView`.
    ///     - lleft:    ` CGFloat` left inset from super view `UIView`.
    ///     - right:    `CGFloat` right inset from super view `UIView`.
    ///
    /// - Returns: `tableView` as a 1x1 `UITableView`.
    func placeTableView(top: CGFloat = 0, bottom: CGFloat = 0,
                        left: CGFloat = 0, right: CGFloat = 0,
                        tableStyle: UITableView.Style) -> UITableView
    {
        let tableView = UITableView(frame: .zero, style: tableStyle)

        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self as? UITableViewDataSource
        tableView.backgroundColor = .clear
        tableView.tableFooterView = .init(frame: .zero)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)

        view.addSubview(tableView)

        tableView.snp.makeConstraints { target in
            target.top.equalToSuperview().inset(top)
            target.bottom.equalToSuperview().inset(bottom)
            target.left.equalToSuperview().inset(left)
            target.right.equalToSuperview().inset(right)
        }

        return tableView
    }
}
