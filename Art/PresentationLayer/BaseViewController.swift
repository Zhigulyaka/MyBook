//
//  BaseViewController.swift
//  Art
//
//  Created by Alina Kharunova on 22.07.2022.
//

import AVFoundation
import IQKeyboardManagerSwift
import SnapKit
import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    // MARK: - Constants

    enum Defaults {
        static let indicatorValue = 0.75
        static let indicatorSize = 50
    }

    // MARK: - Properties

    var isAddHideKeyboardHandler = true
    var isActivityObservers = false
    var isManualShowNavigationBar = true
    var isEnabledBackAction = true
    var keyboardHeight = CGFloat(0.0)
    var upperConstraint: NSLayoutConstraint?
    var upperConstraintMax = CGFloat(60.0)
    var upperConstraintConst = CGFloat(30.0)

    var loaderView: UIActivityIndicatorView = {
        $0.isUserInteractionEnabled = false
        $0.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin, .flexibleRightMargin]
        $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        return $0
    }(UIActivityIndicatorView(frame: .zero))

    private let searchController: UISearchController = {
        $0.searchBar.placeholder = ""
        $0.searchBar.barStyle = .default
        $0.searchBar.searchBarStyle = .minimal
        $0.definesPresentationContext = true
        return $0
    }(UISearchController(searchResultsController: nil))

    public var isEnableKeyboardHelper: Bool = false {
        didSet {
            let keyboard = IQKeyboardManager.shared

            keyboard.enabledToolbarClasses.removeAll { $0 == type(of: self) }
            keyboard.disabledToolbarClasses.removeAll { $0 == type(of: self) }

            if isEnableKeyboardHelper {
                keyboard.enabledToolbarClasses.append(type(of: self))
            } else {
                keyboard.disabledToolbarClasses.append(type(of: self))
            }
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        isEnableKeyboardHelper = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureBaseNavigationBar()

        if isAddHideKeyboardHandler {
            addKeyboardHideHanlder()
        }

        if isActivityObservers {
            NotificationCenter.default.addObserver(self, selector: #selector(appResignActive),
                                                   name: UIApplication.willResignActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(appBecomeActive),
                                                   name: UIApplication.didBecomeActiveNotification, object: nil)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = isEnabledBackAction

        configureKeyboardObserver(isAdd: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        configureKeyboardObserver(isAdd: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        configureKeyboardObserver(isAdd: false)
    }

    // MARK: - Configure

    func configureBaseNavigationBar(textStyle: TextStyle = .B16Black) {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = UIColor.black
            navBarAppearance.shadowImage = UIImage()
            navBarAppearance.shadowColor = nil
            navBarAppearance.titleTextAttributes = [.font: textStyle.font]
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        } else {
            navigationController?.navigationBar.barTintColor = UIColor.black
            navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        }
    }

    func configureKeyboardObserver(isAdd: Bool) {
        if isAdd {
            NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillShow(_:)), name:
                UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }

    func attachPanGestureHandler(_ add: Bool = false) {
        if add {
            navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: #selector(handlePanGesture))
        } else {
            navigationController?.interactivePopGestureRecognizer?.removeTarget(self, action: #selector(handlePanGesture))
        }
    }

    // MARK: - Keyboard

    func addKeyboardHideHanlder() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func hideKeyboard(_ gesture: UITapGestureRecognizer) {
        let view = gesture.view
        let loc = gesture.location(in: view)
        let subview = view?.hitTest(loc, with: nil)
        searchController.searchBar.endEditing(true)

        if subview?.tag != 100 {
            view?.endEditing(true)
        }
    }

    @objc func keyboardWillShow(_: NSNotification) {}

    @objc func keyboardWillHide(_: NSNotification) {}

    func checkShowKeyboard(_ notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if let constraint = upperConstraint, constraint.constant >= upperConstraintMax {
                upperConstraintConst = constraint.constant
                upperConstraint!.constant = upperConstraintMax
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

    func checkHideKeyboard(_: NSNotification) {
        if let constraint = upperConstraint, constraint.constant != upperConstraintConst {
            upperConstraint!.constant = upperConstraintConst
        }
    }

    // MARK: - Activity notifications

    @objc func appResignActive() {}

    @objc func appBecomeActive() {}

    // MARK: - Actions

    @objc func handlePanGesture(_: UIPanGestureRecognizer) {}

    @objc func retryAction() {}

    // MARK: - Loader

    func startLoader() {
        stopLoader()
        view.addSubview(loaderView)
        loaderView.startAnimating()

        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.snp.makeConstraints { target in
            target.width.equalTo(Defaults.indicatorSize)
            target.height.equalTo(Defaults.indicatorSize)
            target.center.equalTo(self.view)
        }
    }

    func stopLoader() {
        loaderView.stopAnimating()
        view.willRemoveSubview(loaderView)
    }

    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        return isEnabledBackAction
    }

    // MARK: - Navigation Items

    fileprivate func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }

    func popControllers(_ count: Int = 1) {
        let shift = count + 1
        if let viewControllers = navigationController?.viewControllers {
            guard viewControllers.count < shift else {
                navigationController?.popToViewController(viewControllers[viewControllers.count - shift], animated: true)
                return
            }
        }
    }

    // MARK: - Alerts

    func showAlert(_ title: String, _ actionTitle: String, _ completionCancel: @escaping (() -> Void), _ completionAction: @escaping (() -> Void)) {
        let alert = UIAlertController(title: nil, message: title, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "L10n.cancel", style: .cancel) { _ in
            completionCancel()
        }
        let action = UIAlertAction(title: actionTitle, style: .destructive) { _ in
            completionAction()
        }
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UISearchControllerDelegate

extension BaseViewController: UISearchControllerDelegate {
    func willPresentSearchController(_: UISearchController) {}

    func willDismissSearchController(_: UISearchController) {}
}

// MARK: - UISearchResultsUpdating

extension BaseViewController: UISearchResultsUpdating {
    func updateSearchResults(for _: UISearchController) {}
}

extension BaseViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_: UISearchBar) {}
}

// MARK: - UISearchController

extension BaseViewController {
    func addSearchController(_ backgroundColor: UIColor,
                             _ textColor: UIColor,
                             _ style: UIBarStyle = .default,
                             _ placeHolderText: String? = nil)
    {
        navigationController?.navigationBar.barStyle = style
        configureBaseNavigationBar()
        configureSearchController(textColor, placeHolderText)
    }

    private func configureSearchController(_ textColor: UIColor? = nil, _ placeHolderText: String? = nil) {
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.blue
        searchController.becomeFirstResponder()

        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.textColor = textColor
            searchController.searchBar.searchTextField.smartDashesType = .no
            searchController.searchBar.searchTextField.autocorrectionType = .no
            searchController.searchBar.searchTextField.autocapitalizationType = .none
            searchController.searchBar.searchTextField.spellCheckingType = .no

            if let text = placeHolderText {
                searchController.searchBar.searchTextField.placeholder = text
            }
        }
        navigationItem.searchController = searchController
    }
}

