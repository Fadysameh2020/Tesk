////
////  BaseViewController.swift
////  Task
////
////  Created by Fady Sameh on 6/24/24.
////
//
//import Foundation
//import UIKit
//
//import NotificationBannerSwift
//
//class BaseViewController<T: BaseViewModelProtocol>: UIViewController {
//
//    private var scrollingView: UIScrollView?
//    private var keyboardWillShowCompletion: ((CGRect) -> Void)?
//    private var keyboardWillHideCompletion: (() -> Void)?
//    
//    var viewModel: T
//    
//    lazy var cancellable: Set<AnyCancellable> = {
//       return Set<AnyCancellable>()
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [weak self] in
//            guard let self = self else { return }
//            viewModel.viewModelDidLoad()
//        })
//       
//        bindDataFromViewModel()
//        overrideUserInterfaceStyle = .light
//        setupBackButton()
//    }
//    
//    private func setupBackButton() {
//        let backButton = UIButton(type: .custom)
//        backButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
//        backButton.setTitle(AppLocalizedKeys.back.value, for: .normal)
//        backButton.setTitleColor(.systemBlue, for: .normal)
//        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//        
//        let backBarButtonItem = UIBarButtonItem(customView: backButton)
//        self.navigationItem.leftBarButtonItem = backBarButtonItem
//    }
//    
//    @objc
//    func backButtonTapped() {
//        // Action for the custom back button
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//    }
//    
//    private lazy var loadingView: UIView = {
//        let activity = UIActivityIndicatorView()
//        let view = UIView(frame: view.frame)
//        activity.center = view.center
//        activity.hidesWhenStopped = true
//        activity.startAnimating()
//        view.addSubview(activity)
//        view.backgroundColor = .white.withAlphaComponent(0.4)
//        return view
//    }()
//
//    init(viewModel: T) {
//        self.viewModel = viewModel
//        super.init(nibName: String(describing: type(of: self)), bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    final func bindDataFromViewModel() {
//        viewModel.viewStatesPublisher.sink { [weak self] state in
//            guard let self = self else { return }
//            switch state {
//            case .idle:
//                removeLoadingView()
//            case .loading:
//                addLoadingView()
//            case .error(let error):
//                removeLoadingView()
//                if let error = error as? ResultError {
//                    showErrorMessage(error: error)
//                }
//                if let error = error as? String {
//                    showErrorMessage(error: ResultError.messageError(error))
//                }
//            case .success(let message):
//                showSuccessMessage(message: message)
//            default:
//                break
//            }
//        }
//        .store(in: &cancellable)
//        
//    }
//    
//    final private func addLoadingView() {
//        loadingView.center = view.center
//        view.addSubview(loadingView)
//    }
//    
//    final private func removeLoadingView() {
//        DispatchQueue.main.async {
//            if self.loadingView.isDescendant(of: self.view) {
//                self.loadingView.removeFromSuperview()
//            }
//        }
//    }
//    
//    final private func showErrorMessage(error: ResultError) {
//        DispatchQueue.main.async {
//            let leftView = UIImageView(image: UIImage(systemName: "info.circle"))
//            leftView.tintColor = .white
//            let banner = FloatingNotificationBanner(subtitle: error.describtionError, leftView: leftView, style: .danger)
//            banner.show(
//                cornerRadius: 8,
//                shadowColor: UIColor(red: 0.431, green: 0.459, blue: 0.494, alpha: 1),
//                shadowBlurRadius: 16,
//                shadowEdgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
//        }
//       
//    }
//    
//    final private func showSuccessMessage(message: String) {
//        DispatchQueue.main.async {
//            let leftView = UIImageView(image: UIImage(systemName: "checkmark"))
//            leftView.tintColor = .white
//            let banner = FloatingNotificationBanner(subtitle: message, leftView: leftView, style: .success)
//            banner.show(
//                cornerRadius: 8,
//                shadowColor: UIColor(red: 0.431, green: 0.459, blue: 0.494, alpha: 1),
//                shadowBlurRadius: 16,
//                shadowEdgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
//        }
//       
//    }
//    
//    // MARK: - keyboard management
//    func configureKeyboardLayout(
//        scrollingView: UIScrollView,
//        keyboardWillShowCompletion: @escaping ((CGRect) -> Void) = {_ in},
//        keyboardWillHideCompletion: @escaping (() -> Void) = {}
//    ) {
//        self.scrollingView = scrollingView
//        self.keyboardWillShowCompletion = keyboardWillShowCompletion
//        self.keyboardWillHideCompletion = keyboardWillHideCompletion
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        registerKeyboardNotifications()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        unregisterKeyboardNotifications()
//    }
//    
//    func registerKeyboardNotifications() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillShow),
//            name: UIResponder.keyboardWillShowNotification,
//            object: nil
//        )
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillHide),
//            name: UIResponder.keyboardWillHideNotification,
//            object: nil
//        )
//    }
//    
//    func unregisterKeyboardNotifications() {
//        NotificationCenter.default.removeObserver(
//            self,
//            name: UIResponder.keyboardWillShowNotification,
//            object: nil
//        )
//        NotificationCenter.default.removeObserver(
//            self,
//            name: UIResponder.keyboardWillHideNotification,
//            object: nil
//        )
//    }
//    
//    @objc
//    private func keyboardWillShow(notification: NSNotification) {
//        guard let userInfo = notification.userInfo,
//              let keyboardFrame = (
//                userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
//              )?.cgRectValue else { return }
//        
//        keyboardWillShowCompletion?(keyboardFrame)
//        
//        let contentInsets = UIEdgeInsets(
//            top: 0,
//            left: 0,
//            bottom: keyboardFrame.size.height + 10,
//            right: 0
//        )
//        guard let scrollView = scrollingView else {return}
//        scrollView.contentInset = contentInsets
//        scrollView.scrollIndicatorInsets = contentInsets
//        
//    }
//    
//    @objc
//    private func keyboardWillHide(notification: NSNotification) {
//        keyboardWillHideCompletion?()
//        
//        guard let scrollView = scrollingView else {return}
//        let contentInsets = UIEdgeInsets.zero
//        scrollView.contentInset = contentInsets
//        scrollView.scrollIndicatorInsets = contentInsets
//    }
//}
