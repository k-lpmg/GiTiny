//
//  WebViewController.swift
//  GiTiny
//
//  Created by DongHeeKang on 04/04/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit
import WebKit

import PanModal
import RxSwift

final class WebViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: WebViewModel
    private var disposeBag = DisposeBag()
    private var observation: NSKeyValueObservation?
    
    // MARK: - UI Components
    
    private let navigationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = UIColor.lightGray.withAlphaComponent(0.2)
        progressView.trackTintColor = .clear
        progressView.backgroundColor = .clear
        return progressView
    }()
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "backGray"), for: .disabled)
        button.setImage(UIImage(named: "backBlack"), for: .normal)
        button.isEnabled = false
        return button
    }()
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        return label
    }()
    private let forwardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "forwardGray"), for: .disabled)
        button.setImage(UIImage(named: "forwardBlack"), for: .normal)
        button.isEnabled = false
        return button
    }()
    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "closeBlack"), for: .normal)
        return button
    }()
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    // MARK: - Con(De)structor
    
    init(viewModel: WebViewModel, urlString: String) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        bindView()
        bindViewModel(urlString: urlString)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setObserver()
        setProperties()
        view.addSubview(navigationView)
        view.addSubview(webView)
        navigationView.addSubview(progressView)
        navigationView.addSubview(backButton)
        navigationView.addSubview(urlLabel)
        navigationView.addSubview(forwardButton)
        navigationView.addSubview(closeButton)
        layout()
    }
    
    // MARK: - Binding
    
    private func bindView() {
        backButton.rx
            .tap
            .bind { [weak self] (_) in
                guard let self = self else {return}
                
                self.webView.goBack()
            }
            .disposed(by: disposeBag)
        forwardButton.rx
            .tap
            .bind { [weak self] (_) in
                guard let self = self else {return}
                
                self.webView.goForward()
            }
            .disposed(by: disposeBag)
        closeButton.rx
            .tap
            .bind { [weak self] (_) in
                guard let self = self else {return}
                
                self.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel(urlString: String) {
        // Input
        let request = rx.sentMessage(#selector(UIViewController.viewDidLoad)).map { _ in return urlString }.take(1)
        let input = type(of: viewModel).Input(request: request.asDriverOnErrorJustNever())
        
        // Output
        let output = viewModel.transform(input: input)
        output.url
            .drive(onNext: { [weak self] (url) in
                guard let self = self else {return}
                
                self.webView.load(URLRequest(url: url))
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    
    private func setObserver() {
        observation = webView.observe(\.estimatedProgress, options: .new) { [weak self] (webView, change) in
            guard let self = self, let changeValue = change.newValue else {return}
            
            let progress = Float(changeValue)
            self.progressView.setProgress(progress, animated: true)
        }
    }
    
    private func setProperties() {
        webView.navigationDelegate = self
        
        let highlughtedColor = UIColor.lightGray.withAlphaComponent(0.2)
        backButton.fh.controlEnable(normalColor: .clear, highlightedColor: highlughtedColor)
        forwardButton.fh.controlEnable(normalColor: .clear, highlightedColor: highlughtedColor)
        closeButton.fh.controlEnable(normalColor: .clear, highlightedColor: highlughtedColor)
    }
    
}

// MARK: - Layout

extension WebViewController {
    
    private func layout() {
        navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navigationView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navigationView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: navigationView.bottomAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        layoutNavigationView()
    }
    
    private func layoutNavigationView() {
        progressView.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: navigationView.topAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor).isActive = true
        
        backButton.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 40).isActive = true
        backButton.topAnchor.constraint(equalTo: navigationView.topAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        urlLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor).isActive = true
        urlLabel.topAnchor.constraint(equalTo: navigationView.topAnchor).isActive = true
        urlLabel.trailingAnchor.constraint(equalTo: forwardButton.leadingAnchor).isActive = true
        urlLabel.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor).isActive = true
        
        forwardButton.topAnchor.constraint(equalTo: navigationView.topAnchor).isActive = true
        forwardButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor).isActive = true
        forwardButton.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor).isActive = true
        forwardButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        closeButton.topAnchor.constraint(equalTo: navigationView.topAnchor).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
}

// MARK: - PanModalPresentable

extension WebViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return webView.scrollView
    }
    
    var allowsExtendedPanScrolling: Bool {
        return true
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeight
    }
    
}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        
        progressView.setProgress(1, animated: true)
        DispatchQueue.global(qos: .background).async {
            sleep(1)
            DispatchQueue.main.async {
                self.progressView.setProgress(0, animated: false)
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let urlResponse = navigationResponse.response as? HTTPURLResponse, let url = urlResponse.url else {
            decisionHandler(.cancel)
            return
        }
        
        urlLabel.text = url.absoluteString
        decisionHandler(.allow)
    }
    
}
