//
//  ExcerciseViewController.swift
//  MasterFitness
//
//  Created by Chamidu on 15/05/2023.
//

import UIKit
import WebKit

class ExcerciseViewController: UIViewController {
    var exercises: [[String: Any]] = []
    var currentIndex: Int = 0
    var timer: Timer?
    var timeRemaining: Int = 0
    
    private let exerciseLabel = UILabel()
    private let repsLabel = UILabel()
    private let timerLabel = UILabel()
    var videoPlayer: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        startExercise(index: currentIndex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop the timer when leaving the view
        stopTimer()
    }
    
    private func setupUI() {
        // Exercise label
        exerciseLabel.font = UIFont.boldSystemFont(ofSize: 24)
        exerciseLabel.textAlignment = .center
        exerciseLabel.translatesAutoresizingMaskIntoConstraints = false
        exerciseLabel.textColor = .white
        view.addSubview(exerciseLabel)
        
        // Reps label
        repsLabel.font = UIFont.systemFont(ofSize: 18)
        repsLabel.textAlignment = .center
        repsLabel.translatesAutoresizingMaskIntoConstraints = false
        repsLabel.textColor = .white
        view.addSubview(repsLabel)
        
        // Timer label
        timerLabel.font = UIFont.systemFont(ofSize: 32)
        timerLabel.textAlignment = .center
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.textColor = .white
        view.addSubview(timerLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            exerciseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exerciseLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            
            repsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            repsLabel.topAnchor.constraint(equalTo: exerciseLabel.bottomAnchor, constant: 20),
            
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: repsLabel.bottomAnchor, constant: 20),
        ])
    }
    
    private func startExercise(index: Int) {
        guard index < exercises.count else {
            // All exercises are done, navigate back to the previous view controller
            navigationController?.popViewController(animated: true)
            return
        }
        
        let exercise = exercises[index]
        
        if let exerciseName = exercise["exercise"] as? String,
           let repsString = exercise["reps"] as? String,
           let reps = Int(repsString),
           let timeString = exercise["time"] as? String,
           let time = Int(timeString) {
            exerciseLabel.text = exerciseName
            repsLabel.text = "Reps: \(reps)"
            timeRemaining = time
            
            if let videoURLString = exercise["videoURL"] as? String, let videoURL = URL(string: videoURLString) {
                // Load the YouTube video
                setupVideoPlayer(with: videoURL)
            } else {
                // No video URL provided
                removeVideoPlayer()
            }
            
            // Start the timer
            startTimer()
        } else {
            print("Exercise data is invalid or missing.")
        }
    }
    
    private func setupVideoPlayer(with videoURL: URL) {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.defaultWebpagePreferences.allowsContentJavaScript = true
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        videoPlayer = WKWebView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 250), configuration: webConfiguration)
        videoPlayer?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(videoPlayer!)
        
        NSLayoutConstraint.activate([
            videoPlayer!.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            videoPlayer!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoPlayer!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoPlayer!.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        let videoRequest = URLRequest(url: videoURL)
        videoPlayer?.load(videoRequest)
        
        videoPlayer?.navigationDelegate = self
    }
    
    private func removeVideoPlayer() {
        videoPlayer?.removeFromSuperview()
        videoPlayer = nil
    }
    
    private func startTimer() {
        timer?.invalidate()
        
        // Update the timer label
        timerLabel.text = "\(timeRemaining)"
        
        // Start the countdown
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.timeRemaining -= 1
            
            if let timeRemaining = self?.timeRemaining {
                if timeRemaining > 0 {
                    // Update the timer label
                    self?.timerLabel.text = "\(timeRemaining)"
                } else {
                    // Move to the next exercise
                    self?.currentIndex += 1
                    self?.startExercise(index: self?.currentIndex ?? 0)
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

}

extension ExcerciseViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Hide the YouTube player controls
        let hideControlsScript = """
        var player = document.querySelector('video');
        player.muted = true;
        player.play();
        player.controls = false;
        """
        webView.evaluateJavaScript(hideControlsScript, completionHandler: nil)
    }
}






