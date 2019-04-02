//
//  ViewController.swift
//  K3TestTask
//
//  Created by Evgeniya Ignatyeva on 3/28/19.
//  Copyright © 2019 Evgeniya Ignatyeva. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let apiManager = APIManager()
    var timestamp: Int?
    var posts: [Post] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup searchbar
        let searchBar = UISearchBar()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        // setup tableview
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: Notification.Name("didReceiveData"), object: nil)

    }
    
    @objc func onDidReceiveData(_ notification:Notification) {
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    func performSearch() {
        guard let searchBar = self.navigationItem.titleView as? UISearchBar,
            let request = searchBar.text,
            let timestamp = self.timestamp else { return }
        apiManager.request(.search(matching: request, before: timestamp)) { responseObject, error in
            guard let responseObject = responseObject, error == nil else {
                print(error ?? "Unknown error")
                return
            }
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(TumblrResponse.self, from: responseObject)
                self.prepareViewModel(responseData.response)
            } catch {
                print("Decoding response error: \(error)")
            }
        }
    }
    
    func prepareViewModel(_ response: [Response]) {
        for item in response {
            let post = Post.init(with: item)
            posts.append(post)
            self.timestamp = item.timestamp
        }
        if !response.isEmpty {
            NotificationCenter.default.post(name: Notification.Name("didReceiveData"), object: nil)
        } else {
            DispatchQueue.main.async {
                self.tableView.isHidden = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue", let index = sender as? Int {
            let destVC = segue.destination as! DetailViewController
            destVC.image = self.posts[index].imageUrl
            destVC.imageHeight = self.posts[index].imageHeight
            destVC.blogName = self.posts[index].blogName
            destVC.type = self.posts[index].type
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.avatarImageView?.sd_setImage(with: URL(string: posts[indexPath.row].blogAvatar), placeholderImage: UIImage(named: "no_avatar.png"))
        cell.blogName.text = posts[indexPath.row].blogName
        cell.descriptionLabel.text = posts[indexPath.row].summary
        cell.notesCountLabel.text = "\(posts[indexPath.row].notesCount) notes"
        cell.tagsLabel.text = posts[indexPath.row].tags
        switch posts[indexPath.row].type {
        case .photo:
            cell.contentImage.sd_setImage(with: URL(string: posts[indexPath.row].imageUrl!), placeholderImage: UIImage(named: "no_image_available.jpeg"))
        case .notPhoto:
            cell.contentImage.image = UIImage(named: "no_image_available.jpeg")
        }
        cell.imageHeightConstraint.constant = posts[indexPath.row].imageHeight
        view.layoutIfNeeded()
        cell.readButtonHandler = {
            self.performSegue(withIdentifier: "detailSegue", sender: indexPath.row)
        }
        return cell
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell)  {
            performSearch()
        }
    }
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= posts.count - 1
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.showsCancelButton = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let request = searchBar.text, request != "" else { return }
        // clear prev data
        self.posts = []
        self.timestamp = nil
        DispatchQueue.main.async {
            self.tableView.isHidden = true
        }
        tableView.reloadData()
        searchBar.resignFirstResponder()
        initTimestamp()
        performSearch()
    }
    func initTimestamp() {
        let date = Date()
        let timeInterval = date.timeIntervalSince1970
        timestamp = Int(timeInterval)
    }
}
