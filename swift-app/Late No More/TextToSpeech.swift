//
//  TextToSpeech.swift
//  Late No More
//
//  Created by Manish Jain on 19/06/25.
//


import AVFoundation
class TextToSpeech {
    private let synthesizer = AVSpeechSynthesizer()
    
    func speak(_ text: String, voice: String? = nil, rate: Float = 0.5, pitch: Float = 1.0, volume: Float = 1.0) {
        addLog(text: "speak \(text)")
        let utterance = AVSpeechUtterance(string: text)
        
        // Set voice (if specified)
        if let voiceIdentifier = voice {
            utterance.voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier)
        }
        
        // Configure speed & pitch
        utterance.rate = rate  // Range: 0.0 (slow) to 1.0 (fast)
        utterance.pitchMultiplier = pitch  // Range: 0.5 (low) to 2.0 (high)
        utterance.volume = volume
        synthesizer.speak(utterance)
    }
    
    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    func listVoices() {
           print("Available Voices:")
           AVSpeechSynthesisVoice.speechVoices().forEach {
               print("\($0.name): \($0.identifier)")
               arrVoiceNames[$0.name] = $0.identifier
           }
       }
}
