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
        
        loadNews(apiKey: "761e3bdff43144e9b74b51734d44a5f3")
        
    }
    
    func postNews(title : String, desc : String, apiKey : String) {
        
        let url = URL(string: "https://newsapi.org/")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(apiKey, forHTTPHeaderField: "api-key")
        let parameter = ["title" : title, "description" : desc]
        
        let formData = "title=\(title)&description=\(desc)"
        urlRequest.httpBody = formData.data(using: .utf8)
        
        guard let data = try? JSONSerialization.data(withJSONObject: parameter, options: []) else {
            return
        }
        
        urlRequest.httpBody = data
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { (data, response, error) in
            
            
            if error != nil {
                print(error ?? "Unknow Error")
                return
            }
            
            guard let data = data else { return }
            
            
        }.resume()
        
    }
    
    func loadNews(apiKey : String) {
        
        URLSession.shared.dataTask(with: URL(string: "https://newsapi.org/v2/everything?q=bitcoin&from=2018-10-11&sortBy=publishedAt&apiKey=\(apiKey)")!) { (data, response, error) in
            
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
