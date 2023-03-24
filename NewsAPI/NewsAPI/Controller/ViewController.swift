//
//  ViewController.swift
//  NewsAPI
//
//  Created by Saruar on 06.03.2023.
//

import UIKit
import SafariServices
import SideMenu


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SideMenuListControllerDelegate {

    //var menu: SideMenuNavigationController?

    let searchController = UISearchController()
    var menu: SideMenuNavigationController?
    var category: String?
    
    private let tableView: UITableView = {
       let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        

        
        return table
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "News"
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        view.backgroundColor = .systemBackground
    
        sideMenuCreated()

        
        
        
        navigationBarCreated()
        fetchStories()
        
    
    }


    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()
    
    //MARK: - TableView
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath
        )as? NewsTableViewCell else{
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else{
            return
        }
        
        let vc = SFSafariViewController(url: url)
        
        present(vc, animated: true)
    }
    
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 150
    }
    
    
    
    //MARK: - UISearchBar
    
    func navigationBarCreated(){
        navigationItem.searchController = searchController
    
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didTapSideMenuButton))
        
        
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
    
        
        searchController.searchBar.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .bookmark, state: .normal)
    }
    
    @objc func didTapSideMenuButton(){
        present(menu!, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else{
            return
        }
        
        if category == nil{
            fetchSearchStories(with: text)
        }else{
            switch category{
            case "Business":
                fetchSearchStories(with: "business&q=" + text)
            case "Entertainment":
                fetchSearchStories(with: "entertainment&q=" + text)
            case "General":
                fetchSearchStories(with: "general&q=" + text)
            case "Health":
                fetchSearchStories(with: "health&q=" + text)
            case "Science":
                fetchSearchStories(with: "science&q=" + text)
            case "Sports":
                fetchSearchStories(with: "sports&q=" + text)
            case "Technology":
                fetchSearchStories(with: "technology&q=" + text)
            default:
                fetchStories()
            }
        }
        
        
    }
    
    func searchBarButtonClickedByPopularity(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else{
            return
        }
        
        fetchSearchStoriesPopularity(with: text)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {

        showAlert()
      
    }
    
    
    func isEmpty(_ searchController: UISearchController) -> Bool{
        if searchController.searchBar.text == nil{
            return true
        }
        return false
    }
    
    func updateSearchResults(for searchController: UISearchController){
        guard let text = searchController.searchBar.text else{
            return
        }
        
        print(text)
    }
    
    //MARK: - SideMenu
    
     func sideMenuCreated(){
        let vc = SideMenuListController()
        vc.delegate = self
        
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
         
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
    }
    
    func didSelectMenuItem(named: String) {
        menu?.dismiss(animated: true, completion: nil)
        
        category = named
        
        switch named{
        case "Business":
            fetchSearchStoriesCategory(with: "business&q=")
            DispatchQueue.main.async {
                self.title = "Business"
            }
        case "Entertainment":
            fetchSearchStoriesCategory(with: "entertainment&q=")
            DispatchQueue.main.async {
                self.title = "Entertainment"
            }
        case "General":
            fetchSearchStoriesCategory(with: "general&q=")
            DispatchQueue.main.async {
                self.title = "General"
            }
        case "Health":
            fetchSearchStoriesCategory(with: "health&q=")
            DispatchQueue.main.async {
                self.title = "Health"
            }
        case "Science":
            fetchSearchStoriesCategory(with: "science&q=")
            DispatchQueue.main.async {
                self.title = "Science"
            }
        case "Sports":
            fetchSearchStoriesCategory(with: "sports&q=")
            DispatchQueue.main.async {
                self.title = "Sports"
            }
        case "Technology":
            fetchSearchStoriesCategory(with: "technology&q=")
            DispatchQueue.main.async {
                self.title = "Technology"
            }
            
        default:
            fetchSearchStoriesCategory(with: "entertainment&q=")
        }
        
    }
    
    //MARK: - ActionSheet
    
    @IBAction func showAlert() {
        let alert = UIAlertController(title: "Filter by", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Popularity", style: .default , handler:{ (UIAlertAction)in
            if self.isEmpty(self.searchController) == true{
                return
            }else{
                self.fetchSearchStoriesPopularity(with: self.searchController.searchBar.text!)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        }))

        
        alert.addAction(UIAlertAction(title: "Reset", style: .default, handler:{ (UIAlertAction)in
            self.fetchStories()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
    

        self.present(alert, animated: true, completion: {
            
        })
    }
    
    
    //MARK: - API Requests

    private func fetchStories(){
        APICaller.shared.getTopStories { [weak self] result in
            switch result{
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title, description: $0.description ?? "", imageURL: URL(string: $0.urlToImage ?? "")
                    )
                    
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchSearchStories(with text: String){
        
        APICaller.shared.searchStories(with: text) { [weak self] result in
            switch result{
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title, description: $0.description ?? "", imageURL: URL(string: $0.urlToImage ?? "")
                    )
                    
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.searchController.dismiss(animated: true)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    public func fetchSearchStoriesCategory(with text: String){
        
        //category_name&q=
        
        APICaller.shared.searchStoriesCategory(with: text) { [weak self] result in
            switch result{
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title, description: $0.description ?? "", imageURL: URL(string: $0.urlToImage ?? "")
                    )
                    
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.searchController.dismiss(animated: true)
                }
                
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    public func fetchSearchStoriesPopularity(with text: String){
        
        APICaller.shared.searchStoriesSortByPublished(with: text) { [weak self] result in
            switch result{
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title, description: $0.description ?? "", imageURL: URL(string: $0.urlToImage ?? "")
                    )
                    
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.searchController.dismiss(animated: true)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func reloadData(){
        tableView.reloadData()
    }
    
    

}


