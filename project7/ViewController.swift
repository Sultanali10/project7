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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        return
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
        
    }
    
    func errorMessage(){
       let ac = UIAlertController(title: "Error", message: "There was an error, please check", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = petitions[indexPath.row].title
        cell.detailTextLabel?.text = petitions[indexPath.row].body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

