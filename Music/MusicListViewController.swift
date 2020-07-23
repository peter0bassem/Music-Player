//
//  MusicListViewController.swift
//  Music
//
//  Created by Peter Bassem on 7/23/20.
//  Copyright © 2020 Peter Bassem. All rights reserved.
//

import UIKit

class MusicListViewController: UIViewController {
    
    @IBOutlet weak var musicTableView: UITableView!

    var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureSongs()
        musicTableView.delegate = self
        musicTableView.dataSource = self
    }
    
    private func configureSongs() {
        songs.append(Song(name: "Background music", albumName: "123 other", artistName: "Rando", imageName: "cover1", trackName: "song1"))
        songs.append(Song(name: "Havana", albumName: "Havana", artistName: "Cambilla Cabello", imageName: "cover2", trackName: "song3"))
        songs.append(Song(name: "Viva La Vida", albumName: "123 Something", artistName: "Coldplay", imageName: "cover3", trackName: "song3"))
        songs.append(Song(name: "Background music", albumName: "123 other", artistName: "Rando", imageName: "cover1", trackName: "song1"))
        songs.append(Song(name: "Havana", albumName: "Havana", artistName: "Cambilla Cabello", imageName: "cover2", trackName: "song3"))
        songs.append(Song(name: "Viva La Vida", albumName: "123 Something", artistName: "Coldplay", imageName: "cover3", trackName: "song3"))
        songs.append(Song(name: "Background music", albumName: "123 other", artistName: "Rando", imageName: "cover1", trackName: "song1"))
        songs.append(Song(name: "Havana", albumName: "Havana", artistName: "Cambilla Cabello", imageName: "cover2", trackName: "song3"))
        songs.append(Song(name: "Viva La Vida", albumName: "123 Something", artistName: "Coldplay", imageName: "cover3", trackName: "song3"))
    }
}

extension MusicListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = musicTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
        cell.imageView?.image = UIImage(named: song.imageName)
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.albumName
        cell.accessoryType = .disclosureIndicator
        
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 17)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        musicTableView.deselectRow(at: indexPath, animated: true)
        
        // present the player
        let position = indexPath.row
        // songs
        guard let playerViewController = storyboard?.instantiateViewController(withIdentifier: "playerViewController") as? PlayerViewController else { return }
        playerViewController.songs = songs
        playerViewController.position = position
        present(playerViewController, animated: true)
    }
}

struct Song {
    let name : String
    let albumName : String
    let artistName : String
    let imageName : String
    let trackName : String
}
