// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
import CAudioKit

/// AudioKit version of Apple's LowShelfFilter Audio Unit
///
open class LowShelfFilter: Node, Toggleable {

    fileprivate let effectAU = AVAudioUnitEffect(
    audioComponentDescription:
    AudioComponentDescription(appleEffect: kAudioUnitSubType_LowShelfFilter))

    /// Specification details for cutoffFrequency
    public static let cutoffFrequencyDef = NodeParameterDef(
        identifier: "cutoffFrequency",
        name: "Cutoff Frequency",
        address: 0,
        initialValue: 80,
        range: 10 ... 200,
        unit: .hertz,
        flags: .default)

    /// Cutoff Frequency (Hertz) ranges from 10 to 200 (Default: 80)
    @Parameter(cutoffFrequencyDef) public var cutoffFrequency: AUValue

    /// Specification details for gain
    public static let gainDef = NodeParameterDef(
        identifier: "gain",
        name: "Gain",
        address: 1,
        initialValue: 0,
        range: -40 ... 40,
        unit: .decibels,
        flags: .default)

    /// Gain (decibels) ranges from -40 to 40 (Default: 0)
    @Parameter(gainDef) public var gain: AUValue

    /// Tells whether the node is processing (ie. started, playing, or active)
    public var isStarted = true

    /// Initialize the low shelf filter node
    ///
    /// - parameter input: Input node to process
    /// - parameter cutoffFrequency: Cutoff Frequency (Hertz) ranges from 10 to 200 (Default: 80)
    /// - parameter gain: Gain (decibels) ranges from -40 to 40 (Default: 0)
    ///
    public init(
        _ input: Node,
        cutoffFrequency: AUValue = cutoffFrequencyDef.initialValue,
        gain: AUValue = gainDef.initialValue) {
        super.init(avAudioNode: effectAU)
        connections.append(input)

        associateParams(with: effectAU)

        self.cutoffFrequency = cutoffFrequency
        self.gain = gain
    }

    /// Function to start, play, or activate the node, all do the same thing
    public func start() {
        effectAU.bypass = false
        isStarted = true
    }

    /// Function to stop or bypass the node, both are equivalent
    public func stop() {
        effectAU.bypass = true
        isStarted = false
    }
}
