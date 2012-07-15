// Based on the SoundFont reader of NAudio 
//      C# Code: (C) Mark Heath 2006 (mark@wordandspirit.co.uk)
//      Haxe Code: (C) Daniel Kuschny 2012 (danielku15@coderline.net)
// You are free to use this code for your own projects.
// Please consider giving credit somewhere in your app to this code if you use it
// Please do not redistribute this code without my permission
// Please get in touch and let me know of any bugs you find, enhancements you would like,
// and apps you have written
package com.ludamix.triad.audio.sf2;

enum GeneratorEnum 
{
    StartAddressOffset; // = 0
    EndAddressOffset;
    StartLoopAddressOffset;
    EndLoopAddressOffset;
    StartAddressCoarseOffset;
    ModulationLFOToPitch;
    VibratoLFOToPitch;
    ModulationEnvelopeToPitch;
    InitialFilterCutoffFrequency;
    InitialFilterQ;
    ModulationLFOToFilterCutoffFrequency;
    ModulationEnvelopeToFilterCutoffFrequency;
    EndAddressCoarseOffset;
    ModulationLFOToVolume;
    Unused1;
    ChorusEffectsSend;
    ReverbEffectsSend;
    Pan;
    Unused2;
    Unused3;
    Unused4;
    DelayModulationLFO;
    FrequencyModulationLFO;
    DelayVibratoLFO;
    FrequencyVibratoLFO;
    DelayModulationEnvelope;
    AttackModulationEnvelope;
    HoldModulationEnvelope;
    DecayModulationEnvelope;
    SustainModulationEnvelope;
    ReleaseModulationEnvelope;
    KeyNumberToModulationEnvelopeHold;
    KeyNumberToModulationEnvelopeDecay;
    DelayVolumeEnvelope;
    AttackVolumeEnvelope;
    HoldVolumeEnvelope;
    DecayVolumeEnvelope;
    SustainVolumeEnvelope;
    ReleaseVolumeEnvelope;
    KeyNumberToVolumeEnvelopeHold;
    KeyNumberToVolumeEnvelopeDecay;
    Instrument;
    Reserved1;
    KeyRange;
    VelocityRange;
    StartLoopAddressCoarseOffset;
    KeyNumber;
    Velocity;
    InitialAttenuation;
    Reserved2;
    EndLoopAddressCoarseOffset;
    CoarseTune;
    FineTune;
    SampleID;
    SampleModes;
    Reserved3;
    ScaleTuning;
    ExclusiveClass;
    OverridingRootKey;
    Unused5;
    UnusedEnd;
}