//
//  AudioPlayerViewController.swift
//  AudioModule
//
//  Created by Seungjin on 31/01/2020.
//  Copyright © 2020 jinnify. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayerViewController: UIViewController {

  //MARK:- Outlets
  @IBOutlet weak var progressBar: UIProgressView!
  @IBOutlet weak var countUpLabel: UILabel!
  @IBOutlet weak var countDownLabel: UILabel!
  @IBOutlet weak var playPauseButton: UIButton!
  @IBOutlet weak var rateLabel: UILabel!
  @IBOutlet weak var rateSlider: UISlider!

  //MARK:- AVAudio Properties
  var player: AVAudioPlayer!
  var audioFileURL: URL? {
    didSet {
      if let url = audioFileURL {
        do {
          player = try AVAudioPlayer(contentsOf: url)
          currentTime = Float(player.currentTime)
          duration = Float(player.duration)
        } catch {
          print("Error", error.localizedDescription)
        }
      }
    }
  }
  var currentTime: Float = 0.0
  var duration: Float = 0.0


  //MARK:- other properties
  let rateSliderValues: [Float] = [0.5, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0]
  var updater: CADisplayLink?

  override func viewDidLoad() {
    super.viewDidLoad()

    configureAudioPlayer()
    configureUpdater()
    initUI()
  }

  private func configureAudioPlayer() {
    // Song 1
    audioFileURL = Bundle.main.url(forResource: "Intro", withExtension: "mp4")
    // Song 2
    //audioFileURL = Bundle.main.url(forResource: "SampleMusic", withExtension: "mp3")

    player.delegate = self
    player.enableRate = true // rate 조절 가능 옵션
    player.prepareToPlay()
  }

  private func configureUpdater() {
    updater = CADisplayLink(target: self, selector: #selector(updateUI))
    updater?.add(to: .current, forMode: .default)
    updater?.isPaused = true
  }

  private func initUI() {
    countUpLabel.text = currentTime.formatted()
    countDownLabel.text = duration.formatted()
    rateLabel.text = "\(1.0)x"
    rateSlider.value = 1.0
    progressBar.progress = 0.0

    updater?.isPaused = true
    player.stop()
    playPauseButton.isSelected = false
  }

  @objc func updateUI(displayLink: CADisplayLink) {
    currentTime = Float(player.currentTime)
    currentTime = max(currentTime, 0)
    currentTime = min(currentTime, duration)

    countUpLabel.text = currentTime.formatted()
    progressBar.progress = currentTime / duration
  }

}

//MARK:- Actions
extension AudioPlayerViewController {

  @IBAction func playTapped(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected

    if player.isPlaying {
      updater?.isPaused = true
      player.pause()
    } else {
      updater?.isPaused = false
      player.play()
    }
  }

  @IBAction func didChangeRate(_ sender: UISlider) {
    let index = Int(sender.value)
    rateLabel.text = "\(rateSliderValues[index])x"
    if player.enableRate {
      player.rate = rateSliderValues[index]
    }
  }

}

//MARK:- AVAudioPlayer delegate
extension AudioPlayerViewController: AVAudioPlayerDelegate {

  //is called when a sound has finished playing
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    print("\n-------------- [audioPlayerDidFinishPlaying] --------------\n")
    print("Successfully :", flag)
    if flag {
      initUI()
    }
  }


  //if an error occurs while decoding it will be reported to the delegate.
  func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
    print("\n-------------- [audioPlayerDecodeErrorDidOccur] --------------\n")
    print("Error :", error?.localizedDescription)
  }

}
