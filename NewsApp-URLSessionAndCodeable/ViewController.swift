//
//  ViewController.swift
//  NewsApp-URLSessionAndCodeable
//
//  Created by Win Than Htike on 11/9/18.
//  Copyright © 2018 PADC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    
    var newsList : [NewsVO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newsTableView.separatorStyle = .none   
        
        loadNews()
        
    }
    
    func loadNews() {
        
        URLSession.shared.dataTask(with: URL(string: "https://newsapi.org/v2/everything?q=bitcoin&from=2018-10-09&sortBy=publishedAt&apiKey=761e3bdff43144e9b74b51734d44a5f3")!) { (data, response, error) in
            
            if error != nil {
                print(error ?? "Unknow Error")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let baseResponse = try JSONDecoder().decode(BaseResponse.self, from: data)
                
                DispatchQueue.main.async {
                 
                    self.newsList = baseResponse.articles
                    self.newsTableView.reloadData()
                    
                }
                
            } catch let jsonErr {
                print("JSONSerialization error ==> \(jsonErr.localizedDescription)")
            }
            
        }.resume()
        
    }
    
}

extension ViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        
        let news = self.newsList[indexPath.row]
        
        cell.lblNewsTitle.text = news.title ?? "Network Error"
        
        cell.lblNewsReleasedDate.text = news.publishedAt ?? "Date Error"
        
        cell.ivNews.loadImageUsingUrlString(url: news.urlToImage ?? "")
        
        return cell
    }
    
    
}

extension UIViewController : UITableViewDelegate {
    
}
