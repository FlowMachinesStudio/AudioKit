//
//  main.swift
//  AudioKit
//
//  Created by Nick Arner and Aurelius Prochazka on 12/28/14.
//  Copyright (c) 2014 Aurelius Prochazka. All rights reserved.
//

import Foundation

let testDuration: Float = 10.0

class Instrument : AKInstrument {

    override init() {
        super.init()

        let filename = "CsoundLib64.framework/Sounds/mandpluk.aif"
        let soundFile = AKSoundFile(filename: filename)

        let speed = AKLine(
            firstPoint:  3.ak,
            secondPoint: 0.5.ak,
            durationBetweenPoints: testDuration.ak
        )
        
        let functionTableLooper = AKFunctionTableLooper(functionTable: soundFile)
        functionTableLooper.endTime = 9.6.ak
        functionTableLooper.transpositionRatio = speed
        functionTableLooper.loopMode = AKFunctionTableLooper.loopPlaysForwardAndThenBackwards()

        enableParameterLog(
            "Transposition Ratio = ",
            parameter: functionTableLooper.transpositionRatio,
            timeInterval:0.1
        )
        setAudioOutput(functionTableLooper)
    }
}

AKOrchestra.testForDuration(testDuration)

let instrument = Instrument()
AKOrchestra.addInstrument(instrument)

instrument.play()

let manager = AKManager.sharedManager()
while(manager.isRunning) {} //do nothing
println("Test complete!")
