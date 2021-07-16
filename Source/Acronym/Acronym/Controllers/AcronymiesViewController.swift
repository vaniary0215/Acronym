//
//  AcronymiesViewController.swift
//  Acronym
//
//  Created by Ashish Vani on 16/07/21.
//

import UIKit

class AcronymiesViewController: UIViewController {
    //MARK:- Static Properties
    static var controller:AcronymiesViewController {
        let sb = UIStoryboard.Name.main.board()
        let vc:AcronymiesViewController = sb.instantiateViewController(withIdentifier: "\(AcronymiesViewController.self)") as! AcronymiesViewController
        return vc
    }
    
    //MARK:- Properties
    var vmSearch:SearchViewModel = SearchViewModel()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.darkGray
        return refreshControl
    }()
    
    //MARK:- IBOutlet
    @IBOutlet var tvItem: UITableView!
    @IBOutlet var aiv: UIActivityIndicatorView!

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicatorView()
        setupTableView()
        loadData()
        title = vmSearch.strSearch ?? ""
        
    }
    
    //MARK:- Private
    func addPullToRefresh() {
        
    }
    
    func setupIndicatorView(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: aiv)
    }
    
    func setupTableView(){
        tvItem.refreshControl = refreshControl
        tvItem.tableFooterView = UILabel()
        
        let nibDetail = UINib(nibName: UITableViewCell.Identifier.acronymDetail.rawValue, bundle: Bundle.main)
        tvItem.register(nibDetail, forCellReuseIdentifier: UITableViewCell.Identifier.acronymDetail.rawValue)
        
        tvItem.delegate = self
        tvItem.dataSource = self
        tvItem.reloadData()
        
    }
    
    func loadData(){
        if let search:String = vmSearch.strSearch, !search.isEmpty {
            aiv.startAnimating()
            vmSearch.fetchAnronymDetails(of: search, completion: { [weak self] (isSuccess, sError) in
                let strongSelf = self
                strongSelf?.aiv.stopAnimating()
                strongSelf?.refreshControl.endRefreshing()
                
                if isSuccess {
                    strongSelf?.tvItem.reloadData()
                }else {
                    strongSelf?.showAlert(title: UIAlertController.Title.error.rawValue, message: sError?.message ?? ServerError.invalidResponse.message)
                }
            })
        }else {
            showAlert(title: UIAlertController.Title.error.rawValue, message: UIAlertController.Message.invalidSearchText.rawValue)
        }
    }
    
    func noRecordFoundView(message:String = "") {
        let rect = CGRect(origin: CGPoint(x: 50,y :0), size: tvItem.bounds.size)

        let lblMessage = UILabel(frame: rect)
        lblMessage.text = message
        if !message.isEmpty { lblMessage.text = message }
        lblMessage.textColor = UIColor.gray
        lblMessage.numberOfLines = 0
        lblMessage.textAlignment = .center
        lblMessage.font = UIFont.systemFont(ofSize: 14)
        lblMessage.center = tvItem.center
        tvItem.backgroundView = lblMessage
    }
    
    @objc func handleRefresh(_ sender: Any) {
        if let appDelegate:AppDelegate = UIApplication.shared.delegate as? AppDelegate, appDelegate.network.isAvailable {
            refreshControl.endRefreshing()
            loadData()
        } else { refreshControl.endRefreshing()}
    }
}

//MARK:- UITableViewDelegate and UITableViewDataSource
extension AcronymiesViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count:Int = vmSearch.items.count as? Int, count > 0 else {
            noRecordFoundView(message: "No data found")
            return 0
        }
        tableView.backgroundView = nil
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var item:Acronym = vmSearch.items[indexPath.row] as? Acronym else { return UITableViewCell() }
        guard let cell:AcronymDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.Identifier.acronymDetail.rawValue) as? AcronymDetailTableViewCell else { return UITableViewCell() }
        cell.loadData(item: item)
        return cell
    }
}
