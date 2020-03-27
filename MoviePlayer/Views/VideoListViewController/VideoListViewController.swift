//
//  VideoListViewController.swift
//  MoviePlayer
//
//  Created by Nguyên Duy on 3/27/20.
//  Copyright © 2020 Nguyên Duy. All rights reserved.
//

import UIKit

class VideoListViewController: BaseViewController {
    // MARK: - IBOUTLETS
    @IBOutlet weak var tbVideos: UITableView!
    
    
    
    // MARK: - VARIABLES
    var refreshControl = UIRefreshControl()
    var videoList = [Video]()
    
    lazy var btnDarkMode: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.setTitle("Dark", for: .normal)
        button.setTitle("Light", for: .selected)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.label, for: .selected)
        button.titleLabel?.font = fontScheme.regular16
        button.isSelected = currentSystemStyle == .dark
        button.addTarget(self, action: #selector(handleDarkModeButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    // MARK: - ACTIONS
    @objc func handleReloadData() {
        self.videoList.removeAll()
        self.loadListVideo()
    }
    
    @objc private func handleDarkModeButton(_ sender: UIButton) {
        let style: UIUserInterfaceStyle = sender.isSelected ? .light : .dark
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = style
        }
        sender.isSelected.toggle()
    }
    
    // MARK: - FUNCTIONS
    override func initRequest() {
        super.initRequest()
        
        self.loadListVideo()
    }
    
    override func initLayout() {
        super.initLayout()
        
        initNavigationBar()
        initTableView()
    }
    
    private func initNavigationBar() {
        self.showTitleOnMiddle("Video List", textColor: UIColor.label)
        
        let rightBar = UIBarButtonItem(customView: btnDarkMode)
        self.navigationItem.rightBarButtonItem = rightBar
    }
    
    private func initTableView() {
        tbVideos.registerCell(type: VideoListTableViewCell.self)
        tbVideos.delegate = self
        tbVideos.dataSource = self
        tbVideos.rowHeight = UITableView.automaticDimension
        tbVideos.estimatedRowHeight = 253
        refreshControl.addTarget(self, action: #selector(handleReloadData), for: .valueChanged)
        tbVideos.refreshControl = refreshControl
    }
    
    func loadListVideo() {
        if let path = Bundle.main.path(forResource: "videos", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [String: Any] {
                    if let categories = jsonResult["categories"] as? [[String: Any]] {
                        if let firstCategory = categories.first {
                            if let videoJSONs = firstCategory["videos"] as? [[String: Any]] {
                                let videos = videoJSONs.compactMap({ Video(json: $0) })
                                self.videoList.append(contentsOf: videos)
                                self.tbVideos.reloadData()
                                
                                if self.refreshControl.isRefreshing {
                                    self.refreshControl.endRefreshing()
                                }
                            }
                        }
                    }
                }
            } catch let error {
                error.localizedDescription.alert(self)
            }
        } else {
            "Invalid filename/path.".alert(self)
        }
    }
}

// MARK: - EXTENSIONS
extension VideoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: VideoListTableViewCell.cellID, for: indexPath) as?  VideoListTableViewCell {
            let video = videoList[indexPath.row]
            cell.selectionStyle = .none
            cell.populateData(with: video)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = videoList[indexPath.row]
        let detailVC = DetailVideoViewController()
        detailVC.video = video
        detailVC.modalPresentationStyle = .overCurrentContext
        self.present(detailVC, animated: true, completion: nil)
    }
}
