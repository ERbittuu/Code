//
//  HomeScreenController.swift
//  Code
//
//  Created by Utsav Patel on 7/2/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    @IBOutlet weak var tableView: TableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var viewModel: HomeViewModel = {
        return HomeViewModel()
    }()
    
    @IBOutlet weak var loginButton: UIButton!
    
    var didSelect: (Media) -> () = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.pagingDelegate = self
        
        // view controller UI setup
        largeTitle(text: "INSTAGRAM PHOTOS")
        searchBar(shows: true)
        
        if Instagram.shared.isAuthenticated {
            self.startInstagram()
        }else{
            self.logoutFromInstagram()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func logoutFromInstagram() {
        self.viewModel.logoutFromInstagram()
        
        // UI updates
        self.loginButton.isHidden = false
        self.navigationItem.removeButton(onRight: true)
        self.navigationItem.removeButton(onRight: false)
        
        self.tableView.reloadData()
        self.tableView.alpha = 0
    }
    
    func startInstagram() {
        
        loginButton.isHidden = true
        
        self.navigationItem.addbutton(onRight: true, type: .profile) { (button) in
            
        }
        
        self.navigationItem.addbutton(onRight: false, type: .logout) { (button) in
            self.logoutFromInstagram()
        }
        
        // Init the static view
        initView()
        
        // init view model
        initVM()
        
        self.viewModel.initiateInstagram()
    }
    
    func initView() {
        tableView.estimatedRowHeight = self.view.frame.size.width
    }
    
    func initVM() {
        
        // Naive binding
        viewModel.showAlertClosure = { [weak self] () in
            if let message = self?.viewModel.alertMessage {
                UIAlertController.showAlert(message, on: self!)
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            self?.tableView.isLoading = false
            let isIntitialLoading = self?.viewModel.isIntitialLoading ?? false
            
            self?.tableView.hide = isIntitialLoading
            if isIntitialLoading {
                self?.activityIndicator.startAnimating()
            }else {
                self?.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            self?.tableView.isLoading = false
            self?.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        Instagram.shared.login(from: self.navigationController!, success: {
            self.loginButton.isHidden = Instagram.shared.isAuthenticated
            self.startInstagram()
        }) { (error) in
            print(error)
        }
    }
}

extension HomeController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.width
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return self.viewModel.userPressedAllowed(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedPhoto = viewModel.selectedPhoto {
            didSelect(selectedPhoto)
        }
    }
}

extension HomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Cell not exists in storyboard")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell1 = cell as? Cell {
            let cellVM = viewModel.getCellViewModel( at: indexPath )
            cell1.configure(withDelegate: cellVM, row: indexPath.row)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
}

extension HomeController: TableViewPaging {
    func paginate(_ tableView: TableView, to page: Int) {
        if self.viewModel.pageRemaining() {
            tableView.isLoading = true
            self.viewModel.fetch(nextPage: true)
        }
    }
}
