//
//  BaseViewController.swift
//  MoviePlayer
//
//  Created by Nguyên Duy on 3/27/20.
//  Copyright © 2020 Nguyên Duy. All rights reserved.
//


import UIKit

class BaseViewController: UIViewController {
    //-------------------------------------------------------------------------------------------
    // MARK: - IBOutlets
    //-------------------------------------------------------------------------------------------
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Local Variables
    //-------------------------------------------------------------------------------------------
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var currentSystemStyle: UIUserInterfaceStyle {
        return UIScreen.main.traitCollection.userInterfaceStyle
    }
    var btnNoti: UIButton!
    
    /// 테이블뷰 로드 되기 전.
    private let startLoadingOffset: CGFloat = 20.0
    
    var leftSwipeGesture = UIPanGestureRecognizer()
    //-------------------------------------------------------------------------------------------
    // MARK: - override method
    //-------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.initLayout()
        self.initRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setNeedsStatusBarAppearanceUpdate() {
        super.setNeedsStatusBarAppearanceUpdate()
        loadViewIfNeeded()
    }
    
    
    func initLayout() {
        //    self.leftSwipeGesture = UIPanGestureRecognizer(target: self, action: #selector(leftSwipeDismiss(gestureRecognizer:)))
        //
        //    if (self.navigationController?.hero.isEnabled ?? false) || (self.hero.isEnabled) {
        //      self.view.addGestureRecognizer(self.leftSwipeGesture)
        //    }
    }
    
    func initRequest() {
        
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Local method
    //-------------------------------------------------------------------------------------------

    
    /// 뷰컨트롤러에 네비게이션 컨트롤러를 추가해 준다.
    ///
    /// - Returns: UINavigationController
    func coverNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        return navigationController
    }
    
    func closeViewController() {
        self.view.endEditing(true)
        if let navigation = self.navigationController {
            if navigation.viewControllers.count == 1 {
                self.dismiss(animated: true, completion: nil)
            } else {
                navigation.popViewController(animated: true)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func cleanDollars(_ value: String?) -> String {
        guard value != nil else { return "0" }
        let doubleValue = Double(value!) ?? 0.0
        let formatter = NumberFormatter()
        formatter.currencyCode = "KRW"
        formatter.currencySymbol = ""
        formatter.minimumFractionDigits = 0 //(value!.contains(".00")) ? 0 : 2
        formatter.maximumFractionDigits = 0
        formatter.numberStyle = .currencyAccounting
        return formatter.string(from: NSNumber(value: doubleValue)) ?? "\(doubleValue)"
    }
    
    @objc func backButtonPressed(_ sender: UIBarButtonItem)  {
        self.closeViewController()
    }
    
    //MARK: - FUNCTIONS
    
    func showTitleOnLeftSide(_ title: String) {
        let lbTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        lbTitle.text = title
        lbTitle.textColor = .darkText
        lbTitle.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: 50))
        emptyView.backgroundColor = .clear
        let emptyBar = UIBarButtonItem(customView: emptyView)
        let titleBar = UIBarButtonItem(customView: lbTitle)
        self.navigationItem.setLeftBarButtonItems([emptyBar, titleBar], animated: false)
        lbTitle.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func showTitleOnMiddle(_ title: String, textColor: UIColor = colorScheme.black) {
        let lbTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        lbTitle.text = title
        lbTitle.textColor = textColor
        lbTitle.font = fontScheme.bold16
        lbTitle.textAlignment = .center
        self.navigationItem.titleView = lbTitle
    }
    
    func showBackButton(tintColor: UIColor = colorScheme.black) {
        let btnBack = UIButton(type: .custom)
        btnBack.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        btnBack.setImage(#imageLiteral(resourceName: "icBack").resize(targetSize: CGSize(width: 24, height: 24)).tintWith(color: tintColor), for: .normal)
        btnBack.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        btnBack.widthAnchor.constraint(equalToConstant: 24).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: 24).isActive = true
        let leftBar = UIBarButtonItem(customView: btnBack)
        self.navigationItem.setLeftBarButton(leftBar, animated: false)
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - IBAction
    //-------------------------------------------------------------------------------------------
}

//-------------------------------------------------------------------------------------------
// MARK: - StoryBoardHelper
//-------------------------------------------------------------------------------------------
protocol StoryBoardHelper {}
extension UIViewController: StoryBoardHelper {}
extension StoryBoardHelper where Self: UIViewController {
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: self.className, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: self.className) as! Self
    }
    
    static func instantiate(storyboard: String) -> Self {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: self.className) as! Self
    }
}

//-------------------------------------------------------------------------------------------
// MARK: - UIGestureRecognizerDelegate
//-------------------------------------------------------------------------------------------
extension BaseViewController: UIGestureRecognizerDelegate {
}

