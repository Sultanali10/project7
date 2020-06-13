//
//  ViewController.swift
//  project7
//
//  Created by Sultan Ali on 13/06/2020.
//  Copyright © 2020 Sultan Ali. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var showingPetitions = [Petition]()
    var searchWord:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        let credit = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(credits))
        navigationItem.rightBarButtonItem = credit
        
        let filter = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filteringPetitions))
        navigationItem.leftBarButtonItem = filter
        
        
        var urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url){
                  parse(json: data)
                return
            }
        }
        
        errorMessage()
    }
    
    @objc func credits(){
        let ac = UIAlertController(title: "Credits", message: "The credits of these petitions goes for USA gov and their API site", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filteringPetitions(){
        
        let ac = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Search", style: .default){
          [weak self, weak ac]  _ in
            self?.searchWord = ac?.textFields?[0].text
            guard let searchWord = self?.searchWord else {return}
            self?.showFilteredPetitions(searchWord: searchWord)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func showFilteredPetitions(searchWord word: String){
        filteredPetitions.removeAll()
        for petition in petitions {
            if petition.title.contains(word) || petition.body.contains(word){
                filteredPetitions.append(petition)
            }
            showingPetitions = filteredPetitions
            tableView.reloadData()
        }
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            showingPetitions = petitions
            tableView.reloadData()
        }
        
    }
    
    func errorMessage(){
       let ac = UIAlertController(title: "Error", message: "There was an error, please check", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showingPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = showingPetitions[indexPath.row].title
        cell.detailTextLabel?.text = showingPetitions[indexPath.row].body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

