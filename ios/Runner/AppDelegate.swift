import UIKit
import Flutter
import AVFoundation
import Speech

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private var speechRecognizer: SFSpeechRecognizer!

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Create a MethodChannel with the same channel name as in Flutter
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let speechChannel = FlutterMethodChannel(name: "speech_to_text", binaryMessenger: controller.binaryMessenger)
    
    // Add a handler for the method call from Flutter
    speechChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "transcribeAudio" {
        if let args = call.arguments as? [String: Any], let path = args["path"] as? String, let languageCode = args["languageCode"] as? String {
          self?.transcribeAudio(at: path, languageCode: languageCode, result: result)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Path required", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


    func extractAudio(from videoURL: URL, to audioURL: URL, completion: @escaping (Error?) -> Void) {
        let asset = AVAsset(url: videoURL)
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)!
        exportSession.outputFileType = .m4a
        exportSession.outputURL = audioURL
        exportSession.exportAsynchronously(completionHandler: {
            if exportSession.status == .completed {
                completion(nil)
            } else {
                completion(exportSession.error)
            }
        })
    }
  
    private func transcribeAudio(at path: String, languageCode: String, result: @escaping FlutterResult) {
      let fileURL = URL(fileURLWithPath: path)
        
      let temporaryAudioURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp_1.m4a")
      extractAudio(from: fileURL, to: temporaryAudioURL) { error in
        guard error == nil else {
          result(FlutterError(code: "EXTRACTION_ERROR", message: error?.localizedDescription, details: nil))
          return
        }

        let locale = Locale(identifier: languageCode)
        guard let recognizer = SFSpeechRecognizer(locale: locale), recognizer.isAvailable else {
          result(FlutterError(code: "RECOGNIZER_NOT_AVAILABLE", message: "Speech recognizer not available for the given locale", details: nil))
          return
        }

        self.speechRecognizer = recognizer
        let request = SFSpeechURLRecognitionRequest(url: temporaryAudioURL)
        request.shouldReportPartialResults = false
        request.taskHint = .dictation
          
        self.speechRecognizer?.recognitionTask(with: request, resultHandler: { (speechResult, error) in
            
          if let transcription = speechResult?.bestTranscription {
                  // You can send the partial or final transcription to Flutter here
                  if speechResult?.isFinal ?? false {
                      var subtitles: [[String: Any]] = []

                      for segment in transcription.segments {
                        let start = segment.timestamp
                        let end = start + segment.duration
                        let text = segment.substring

                        let subtitle: [String: Any] = ["start": start, "end": end, "text": text]
                        subtitles.append(subtitle)
                      }
                      
                    do {
                      try FileManager.default.removeItem(at: temporaryAudioURL)
                    } catch {
                      // Handle or ignore the error
                    }
                      
                    result(subtitles)
                  } else {
                    // Partial result, you may send it to Flutter if you need to show it in real time
                    print(transcription.formattedString) // Or handle it accordingly
                  }
          }
            
          if let error = error {
            result(FlutterError(code: "RECOGNITION_ERROR", message: error.localizedDescription, details: nil))
            return
          }

          if let transcription = speechResult?.bestTranscription {
            result(transcription.formattedString)
          } else {
            result(nil)
          }
        })
      }
    }

}
