//
//  ViewController.swift
//  NewsAPI
//
//  Created by Saruar on 06.03.2023.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //Table view
    //Custom Cell
    //API Caller
    
    let searchController = UISearchController()
    
    private let tableView: UITableView = {
       let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        

        
        return table
    }()

    
//    var isSlideMenuPressed = false
//
//    lazy var slideInMenuPadding: CGFloat = self.view.frame.width * 0.3
//
//    lazy var menuView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemGray5
//        return view
//    }()
//
//    lazy var containerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemBackground
//        return view
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        view.backgroundColor = .systemBackground
        
//
//        menuView.pinMenuTo(view, with: slideInMenuPadding)
//        containerView.edgeTo(view)
        

        navigationBarCreated()
        fetchStories()
        
    
        
        // Do any additional setup after loading the view.
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
        
        
        let label = UILabel()
        label.text = "USD: 452 KZT GBT: 480 KZT RUB: 6.3 KZT"
        label.numberOfLines = 3
        
        let constraint = CGSize(width: 200, height: 60)
        
        let size = label.sizeThatFits(constraint)
        
        label.frame = CGRect(origin: CGPoint(x: 300, y: 60), size: size)
        
        let rightTitle = UIBarButtonItem(customView: label)
        navigationItem.rightBarButtonItem = rightTitle
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didTapMenuButton))
        
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
    
        
        searchController.searchBar.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .bookmark, state: .normal)
    }
    
    @objc func didTapMenuButton(){

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else{
            return
        }
        
        fetchSearchStories(with: text)
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
    
    
    private func fetchSearchStoriesPopularity(with text: String){
        
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
    
    
}


public extension UIView {
    func edgeTo(_ view: UIView){
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
}
    func pinMenuTo(_ view: UIView, with constant: CGFloat) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:
                                    -constant).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

