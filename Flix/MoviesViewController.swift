//
//  ViewController.swift
//  Flix
//
//  Created by Kelly Ly on 2/23/22.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    // properties (available for lifetime of that screen)
    // create an array of dictionaries
    // Type of Key : Type of Value
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        print("Hello")
        
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                 
                 // cast as an array of dictionaries
                 self.movies = dataDictionary["results"] as! [[String:Any]]
                 
                 // call the functions on the bottom again
                 self.tableView.reloadData()
                 
                 print(dataDictionary)
                 
                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data
                 
                 


             }
        }
        task.resume()
    }
    
    
    // functions are called when ViewController starts up
    // haven't received movies yet - movies.count = 0
    // have to tell MovieView to update (once we get self.movies, reloadData())
    // asking for # of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // let cell = UITableViewCell()
        // if another cell is offscreen, give recycled cell
        // if there isn't one, create a new one
        // cast as MovieCell (so we can access it like a MovieCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        // get current movie
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String      // cast title (String)
        let synopsis = movie["overview"] as! String

        // cell.textLabel!.text = title
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
       
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        // url checks if it's correctly formed vs. an arbitrary string
        let posterUrl = URL(string: baseUrl + posterPath)
        
        // from AlamoFireImage
        // give URL, will take care of downloading & setting image
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        print("Loading up the details screen")
        
        
        // Find the selected movie
        // sender -> cell that was tapped on
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!  //  get indexPath for that cell
        let movie = movies[indexPath.row]                // access that array
        
        // Pass the selected movie to the details view controller
        // cast it, otherwise generic ViewController
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        // not highlighted when going back
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}

