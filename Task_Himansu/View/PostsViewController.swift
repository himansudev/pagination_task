//
//  PostsViewController.swift
//  Task_Himansu
//
//  Created by Himansu Panigrahi on 5/30/24.
//

import UIKit
class PostsViewController: UIViewController {
    private var postsTableView: UITableView!
    private var posts: [PostVM] = []
    private var currentPage = 1
    private let limit = 20
    private var isLoading = false {
        didSet{
            showProgress(show: isLoading)
        }
    }
    private let mainActivityIndicator = UIActivityIndicatorView()
    private let bottomActivityIndicator = UIActivityIndicatorView()
    private var postsViewModel:PostsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Posts"
        postsViewModel = PostsViewModel(delegate: self)
        configurePostsTableView()

        configureMainActivityIndicatorView()
        setupActivityIndicator()
        loadPosts(page: currentPage)
    }
    
    private func configurePostsTableView(){
        postsTableView = UITableView()
        postsTableView.separatorColor = .black
        view.addSubview(postsTableView)
        
        postsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            postsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            postsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.register(
            PostTVCell.self,
            forCellReuseIdentifier: String.init(describing: PostTVCell.self)
        )
        
        //Adding no data label
        let noDataLabel = UILabel()
        noDataLabel.text = "No Data"
        noDataLabel.textAlignment = .center
        postsTableView.backgroundView = noDataLabel
    }
    
    
    private func configureMainActivityIndicatorView(){
        mainActivityIndicator.center = view.center
        mainActivityIndicator.style = .large
        view.addSubview(mainActivityIndicator)
    }
   
    private func showProgress(show:Bool){
        if show{
            if posts.isEmpty{
                mainActivityIndicator.startAnimating()
            }
            else{
                bottomActivityIndicator.startAnimating()
            }
        }
        else{
            mainActivityIndicator.stopAnimating()
            bottomActivityIndicator.stopAnimating()
        }
    }
    
    private func setupActivityIndicator() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: postsTableView.frame.width, height: 50))
        footerView.addSubview(bottomActivityIndicator)
        bottomActivityIndicator.style = .large
        bottomActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomActivityIndicator.heightAnchor.constraint(equalToConstant: 10),
            bottomActivityIndicator.widthAnchor.constraint(equalToConstant: 10),
            bottomActivityIndicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            bottomActivityIndicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
        
        postsTableView.tableFooterView = footerView
    }
        
}

extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String.init(describing: PostTVCell.self),
            for: indexPath
        ) as? PostTVCell else {return UITableViewCell()}
        let post = posts[indexPath.row]
        cell.configure(with: post)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postDetailVC = PostDetailViewController()
        postDetailVC.post = self.posts[indexPath.row]
        navigationController?.pushViewController(postDetailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let offsetY = scrollView.contentOffset.y
           let contentHeight = scrollView.contentSize.height
           let height = scrollView.frame.size.height

           if offsetY > contentHeight - height {
               if !isLoading{
                   loadPosts(page: currentPage + 1)
               }
           }
       }
}


extension PostsViewController:PostsViewModelProtocol{
    
    func loadPosts(page: Int) {
        guard !isLoading else { return }
        isLoading = true
        postsViewModel?.fetchPosts(page: page, limit: limit)
    }
    
    func updatePostsResponse(posts: [PostVM]?, page:Int, error: String?) {
        DispatchQueue.main.async {
            self.isLoading = false
            if let error = error{
                if self.posts.isEmpty{
                    self.showAlert(
                        title: "Error",
                        message: error,
                        actions: [(
                            title: "Retry",
                            style: .default,
                            handler: {
                                _ in
                                self.loadPosts(page: self.currentPage)
                            }
                        )]
                    )
                }
                else{
                    self.showAlert(
                        title: "Error",
                        message: error,
                        actions: [(
                            title: "OK",
                            style: .default,
                            handler: nil
                        )]
                    )
                }
            }
            else{
                if let posts = posts {
                    if !posts.isEmpty{
                        self.currentPage = page
                        self.posts.append(contentsOf: posts)
                        self.postsTableView.reloadData()
                    }
                }
            }
        }
    }
}


