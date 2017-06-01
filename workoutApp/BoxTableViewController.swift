//
//  BoxTableViewController.swift
//  workoutApp
//
//  Created by Alexander Kvamme on 23/05/2017.
//  Copyright © 2017 Alexander Kvamme. All rights reserved.
//

import UIKit

class BoxTableViewController: UITableViewController {
    
    let cellIdentifier: String = "BoxCell"
    var workoutStyle = ""
    
    var customRefreshView: RefreshControlView!
    
    var dataSource: UITableViewDataSource!
    
    init(workoutStyle: String) {
        super.init(nibName: nil, bundle: nil)
        self.workoutStyle = workoutStyle

        setUpNavigationBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        removeBackButton()
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .light
        super.viewDidLoad()
        removeBackButton()
        
        // Data source setup
        setupDataSource()
        
        // Table view setup
        setupTableView()
        
        // refreshControl
//        setupRefreshControl()
        setupTestRefreshControl()
        
    }

    // MARK: - helpers
    
    private func setupTestRefreshControl() {
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = .clear
        refreshControl?.tintColor = .clear
        
        // custom view
        customRefreshView = RefreshControlView()
        customRefreshView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customRefreshView.frame = refreshControl!.bounds // <-- Why is this needed?
        refreshControl?.addSubview(customRefreshView)
        
        refreshControl!.addTarget(self, action: #selector(BoxTableViewController.refreshControlHandler(sender:)), for: .valueChanged)
        
    }
    
    @objc private func refreshControlHandler(sender: UIRefreshControl) {
        print("Hard pull -> *handle pull*")
        
        // Fontsize pops bigger
        customRefreshView.label.font = UIFont.custom(style: .bold, ofSize: .extreme)
        sender.endRefreshing()
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = .clear
        refreshControl?.tintColor = .clear
        
        let v = UIView()
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        v.backgroundColor = .purple
        v.frame = refreshControl!.bounds // <-- Why is this needed?
        refreshControl?.addSubview(v)
    }
    
    private func setupDataSource() {
        dataSource = WorkoutTableViewDataSource(workoutStyle: workoutStyle)
        tableView.dataSource = dataSource
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.estimatedRowHeight = 115
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(WorkoutBoxCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorInset.left = 0
    }

    private func removeBackButton(){
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
    
    func swipeHandler() {
        print("swiped")
    }
    
    private func setUpNavigationBar() {
        self.title = "\(workoutStyle) workouts".uppercased()
        let navButtonRight = UIImage(named: "xmarkDarkBlue")?.withRenderingMode(.alwaysOriginal)
        let rightButton = UIBarButtonItem(image: navButtonRight, style: .done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    // MARK: - Delegate methods
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customRefreshView.label.alpha = abs(scrollView.contentOffset.y + 64)/100
        
        if customRefreshView.label.alpha == 0 {
            customRefreshView.label.font = UIFont.custom(style: .bold, ofSize: .biggest)
        }
        
    }
}

