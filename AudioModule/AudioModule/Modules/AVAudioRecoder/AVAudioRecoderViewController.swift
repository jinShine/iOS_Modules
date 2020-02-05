//
//  AVAudioRecoderViewController.swift
//  AudioModule
//
//  Created by Seungjin on 04/02/2020.
//  Copyright © 2020 jinnify. All rights reserved.
//

import UIKit
import AVFoundation

class AVAudioRecoderViewController: UIViewController {

  //MARK:- Outlets
  @IBOutlet private var stopButton: UIButton!
  @IBOutlet private var playButton: UIButton!
  @IBOutlet private var recordButton: UIButton!
  @IBOutlet private var timeLabel: UILabel!

  var audioRecoder: AVAudioRecorder!
  var audioPlayer: AVAudioPlayer?
  private var timer: Timer?
  private var elapsedTimeInSecond: Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()

    configure()
  }

  private func configure() {
    stopButton.isEnabled = false
    playButton.isEnabled = false

    guard
      let directoryURL = FileManager.default.urls(
        for: FileManager.SearchPathDirectory.documentDirectory,
        in: FileManager.SearchPathDomainMask.userDomainMask
      ).first else {
        let alertMessage = UIAlertController(
          title: "Error",
          message: "Failed to get the document directory for recording the audio. Please try again later.",
          preferredStyle: .alert
        )
        alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertMessage, animated: true, completion: nil)

        return
    }

    // Set the default audio file
    let audioFileURL = directoryURL.appendingPathComponent("MyAudioMemo.m4a")

    // Setup audio session
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(.playAndRecord, mode: AVAudioSession.Mode.default, options: [.defaultToSpeaker])

      let recoderSetting: [String: Any] = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 44100.0,
        AVNumberOfChannelsKey: 2,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
      ]

      audioRecoder = try AVAudioRecorder(url: audioFileURL, settings: recoderSetting)
      audioRecoder.delegate = self
      audioRecoder.isMeteringEnabled = true // 소음 측정기 가능 여부
      audioRecoder.prepareToRecord()
    } catch {
      print(error)
    }

  }

  func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
      self.elapsedTimeInSecond += 1
      self.updateTimeLabel()
    })
  }

  func pauseTimer() {
    timer?.invalidate()
  }

  func resetTimer() {
    timer?.invalidate()
    elapsedTimeInSecond = 0
    updateTimeLabel()
  }

  func updateTimeLabel() {
    let seconds = elapsedTimeInSecond % 60
    let minutes = (elapsedTimeInSecond / 60)
    timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
  }

}

// MARK: - Actions
extension AVAudioRecoderViewController {

  @IBAction func stop(sender: UIButton) {

    recordButton.setImage(UIImage(named: "Record_Round"), for: .normal)
    recordButton.isEnabled = true
    stopButton.isEnabled = false
    playButton.isEnabled = true

    audioRecoder.stop()
    resetTimer()

    let audioSession = AVAudioSession.sharedInstance()

    do {
      try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
    } catch {
      print(error)
    }
  }

  @IBAction func play(sender: UIButton) {

    if !audioRecoder.isRecording {
      guard let player = try? AVAudioPlayer(contentsOf: audioRecoder.url) else {
        print("Failed to initialize AVAudioPlayer")
        return
      }

      audioPlayer = player
      audioPlayer?.delegate = self
      audioPlayer?.play()
      audioRecoder.pause()
    }

  }

  @IBAction func record(sender: UIButton) {

    if let player = audioPlayer, player.isPlaying {
      player.stop()
    }

    if !audioRecoder.isRecording {
      let audioSession = AVAudioSession.sharedInstance()

      do {
        // 레코더가 작동하도록 하려면 오디오 세션을 활성 상태로 설정해야 한다. 그렇지 않으면 오디오 녹화가 활성화되지 않는다.
        try audioSession.setActive(true , options: .notifyOthersOnDeactivation)
        audioRecoder.record()
        startTimer()

        recordButton.setImage(UIImage(named: "Pause_Round"), for: .normal)
      } catch {
        print(error)
      }
    } else {
      audioRecoder.pause()
      pauseTimer()
      recordButton.setImage(UIImage(named: "Record_Round"), for: .normal)
    }

    stopButton.isEnabled = true
    playButton.isEnabled = false
  }

}

extension AVAudioRecoderViewController: AVAudioRecorderDelegate {

  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if flag {
      let alertMessage = UIAlertController(title: "Finish Recording",
                                           message: "Successfully recorded the audio!",
                                           preferredStyle: .alert)
      alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alertMessage, animated: true, completion: nil)
    }
  }
}

extension AVAudioRecoderViewController: AVAudioPlayerDelegate {

  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    playButton.isSelected = false

    let alertMessage = UIAlertController(title: "Finish Playing", message: "Finish playing the recording!", preferredStyle: .alert)
    alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertMessage, animated: true, completion: nil)
  }
}
