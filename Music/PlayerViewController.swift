//
//  PlayerViewController.swift
//  Music
//
//  Created by Peter Bassem on 7/23/20.
//  Copyright © 2020 Peter Bassem. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var holderView: UIView!
    
    private lazy var albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var albumNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    public var position: Int = 0
    public var songs: [Song] = []
    
    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if holderView.subviews.count == 0 {
            configure()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        player?.stop()
    }
    
    private func configure() {
        // setup player
        let song = songs[position]
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlString = urlString, let url = URL(string: urlString) else { return }
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = 0.5
            player?.play()
        } catch let error {
            print("error occurred:", error)
        }
        
        // setup ui elements
        // Album Cover
        albumImageView.frame = CGRect(x: 10, y: 10, width: (holderView.frame.size.width - 20), height: (holderView.frame.size.width - 20))
        albumImageView.image = UIImage(named: song.imageName)
        holderView.addSubview(albumImageView)
        
        // Labels: Song name, Album name, Artist name
        songNameLabel.frame = CGRect(x: 10, y: (albumImageView.frame.size.height + 10), width: (holderView.frame.size.width - 20), height: 70)
        albumNameLabel.frame = CGRect(x: 10, y: (albumImageView.frame.size.height + 10 + 70), width: (holderView.frame.size.width - 20), height: 70)
        artistNameLabel.frame = CGRect(x: 10, y: (albumImageView.frame.size.height + 10 + 140), width: (holderView.frame.size.width - 20), height: 70)
        
        songNameLabel.text = song.name
        albumNameLabel.text = song.albumName
        artistNameLabel.text = song.artistName
        
        holderView.addSubview(songNameLabel)
        holderView.addSubview(albumNameLabel)
        holderView.addSubview(artistNameLabel)
        
        // Player controls
        let playPauseButton = UIButton()
        let nextButton = UIButton()
        let backButton = UIButton()
        
        // Frames
        let yPosition = artistNameLabel.frame.origin.y + 70 + 20
        let size: CGFloat = 80
        
        playPauseButton.frame = CGRect(x: (holderView.frame.size.width - size) / 2.0, y: yPosition, width: size, height: size)
        nextButton.frame = CGRect(x: (holderView.frame.size.width - size - 20), y: yPosition, width: size, height: size)
        backButton.frame = CGRect(x: 20, y: yPosition, width: size, height: size)
        
        // Add Actions
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton(_:)), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton(_:)), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton(_:)), for: .touchUpInside)
        
        // Styling
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        nextButton.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        backButton.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        
        playPauseButton.tintColor = .black
        nextButton.tintColor = .black
        backButton.tintColor = .black
        
        holderView.addSubview(playPauseButton)
        holderView.addSubview(nextButton)
        holderView.addSubview(backButton)
        
        // Volume Slider
        let slider = UISlider(frame: CGRect(x: 20, y: (holderView.frame.size.height - 60), width: (holderView.frame.size.width - 40), height: 50))
        slider.value = 0.5
        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        holderView.addSubview(slider)
    }
    
    @objc private func didTapBackButton(_ sender: UIButton) {
        if position > 0 {
            position = position - 1
            player?.stop()
            for subview in holderView.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc private func didTapPlayPauseButton(_ sender: UIButton) {
        if player?.isPlaying == true {
            // pause
            player?.pause()
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
            // shrink image
            UIView.animate(withDuration: 0.2) {
                self.albumImageView.frame = CGRect(x: 30, y: 30, width: (self.holderView.frame.size.width - 60), height: (self.holderView.frame.size.width - 60))
            }
        } else {
            // play
            player?.play()
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            // increase image
            UIView.animate(withDuration: 0.2) {
                self.albumImageView.frame = CGRect(x: 10, y: 10, width: (self.holderView.frame.size.width - 20), height: (self.holderView.frame.size.width - 20))
            }
        }
    }
    
    @objc private func didTapNextButton(_ sender: UIButton) {
        if position < (songs.count - 1) {
            position = position + 1
            player?.stop()
            for subview in holderView.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc private func didSlideSlider(_ sender: UISlider) {
        let value = sender.value
        player?.volume = value
    }
}
