NodeProxy.defaultNumAudio = 1;
p = ProxySpace().push(s.boot);
q = ();

"Setting up environment".postln;

(
  /// Dm = 0, Em = 1, F = 2, G = 3, Am = 4, C = 5

  q.harmony_transition_edges = [
    [0, 1, 2, 3, 4],
    [4, 5],
    [3, 5],
    [0, 1, 3, 4],
    [0, 1, 4],
    [3, 4]
  ];

  q.harmony_transition_probabilities = [
    [0.3, 0.1, 0.1, 0.2, 0.3],
    [0.6, 0.4],
    [0.6, 0.4],
    [0.25, 0.2, 0.3, 0.25],
    [0.3, 0.3, 0.4],
    [0.5, 0.5]
  ];

  q.harmony_transition_markov = MarkovSet(
    [
      [0, q.harmony_transition_edges[0], q.harmony_transition_probabilities[0]],
      [1, q.harmony_transition_edges[1], q.harmony_transition_probabilities[1]],
      [2, q.harmony_transition_edges[2], q.harmony_transition_probabilities[2]],
      [3, q.harmony_transition_edges[3], q.harmony_transition_probabilities[3]],
      [4, q.harmony_transition_edges[4], q.harmony_transition_probabilities[4]],
      [5, q.harmony_transition_edges[5], q.harmony_transition_probabilities[5]]
    ]
  );

  q.harmony_transition_markov.seeds = [0];
  q.harmony_transition_stream = q.harmony_transition_markov.asStream;

  q.pm_1_notes  = ["A4", "E5", "A4", "B4", "A4", "E5"].collect { |n| Note(n).freq };
  q.pm_25_notes = ["F4", "G4", "F4", "G4", "G4", "G4"].collect { |n| Note(n).freq };
  q.pm_10_notes = ["D4", "D4", "C4", "D4", "C4", "C4"].collect { |n| Note(n).freq };

  q.adc_49_1_notes = ["C5", "B5", "Bf5", "Bf5", "B5", "B5" ].collect { |n| Note(n).freq };

  q.gene_no2_notes = ["F5", "E5", "Ef5", "D5", "C5", "B5" ].collect { |n| Note(n).freq };

  q.bass_notes = ["D1", "E1", "F1", "G1", "A1", "G1"].collect { |n| Note(n).freq };

  q.harmony_transition_base_time = 10;

  q.countryside_ambience = Buffer.read(s, "samples/countryside_ambience.wav".asAbsolutePath);
  q.refinery_ambience = Buffer.read(s, "samples/refinery_ambience.wav".asAbsolutePath);

  q.bombona_hit = Buffer.read(s, "samples/bombona.wav".asAbsolutePath);
  q.machinery_loop = Buffer.read(s, "samples/machinery_loop.wav".asAbsolutePath);

  q.user_threshold = Bus.control(s, 1);
  q.sck_pm_1 = Bus.control(s, 1);
  q.sck_pm_25 = Bus.control(s, 1);
  q.sck_pm_10 = Bus.control(s, 1);
  q.sck_sfa30_f = Bus.control(s, 1);
  q.sck_adc_49_1 = Bus.control(s, 1);
  q.gene_pm_1 = Bus.control(s, 1);
  q.gene_pm_25 = Bus.control(s, 1);
  q.gene_pm_10 = Bus.control(s, 1);
  q.gene_nox = Bus.control(s, 1);
  q.gene_no2 = Bus.control(s, 1);
  q.light = Bus.control(s, 1); //For some subtle variation throughout the day
);

"Loading OSC listeners".postln;
(

  OSCdef(\user_threshold, { |msg|
    q.user_threshold.set(msg[1]);
  }, "/nubes/user_threshold");

  OSCdef(\light, { |msg|
    q.light.set(msg[1]);
  }, "/sck/light");


  OSCdef(\sck_pm_1, { |msg|
    q.sck_pm_1.set(msg[1]);
  }, "/sck/pm_avg_1");

  OSCdef(\sck_pm_25, { |msg|
    q.sck_pm_25.set(msg[1]);
  }, "/sck/pm_avg_2.5");

  OSCdef(\sck_pm_10, { |msg|
    q.sck_pm_10.set(msg[1]);
  }, "/sck/pm_avg_10");

  OSCdef(\sck_sfa30_f, { |msg|
    q.sck_sfa30_f.set(msg[1]);
  }, "/sck/sfa30_f");

  OSCdef(\sck_adc_49_1, { |msg|
    q.sck_adc_49_1.set(msg[1]);
  }, "/sck/adc_49_1");

  OSCdef(\gene_pm_1, { |msg|
    q.gene_pm_1.set(msg[1]);
    ~gene_pm_1 = msg[1];
  }, "/gene/pm1");

  OSCdef(\gene_pm_25, { |msg|
    q.gene_pm_25.set(msg[1]);
  }, "/gene/pm2.5");

  OSCdef(\gene_pm_10, { |msg|
    q.gene_pm_10.set(msg[1]);
  }, "/gene/pm10");

  OSCdef(\gene_nox, { |msg|
    q.gene_nox.set(msg[1]);
  }, "/gene/nox");

  OSCdef(\gene_no2, { |msg|
    q.gene_no2.set(msg[1]);
  }, "/gene/no2");

);
"Setting parameters".postln;


(
  ~user_threshold = { \input.kr };
  ~user_threshold.set(\input, q.user_threshold.asMap);
  ~light = { \input.kr };
  ~light.set(\input, q.light.asMap);
  ~sck_pm_1 = { \input.kr };
  ~sck_pm_1.set(\input, q.sck_pm_1.asMap);
  ~sck_pm_25 = { \input.kr };
  ~sck_pm_25.set(\input, q.sck_pm_25.asMap);
  ~sck_pm_10 = { \input.kr };
  ~sck_pm_10.set(\input, q.sck_pm_10.asMap);
  ~sck_sfa30_f = { \input.kr };
  ~sck_sfa30_f.set(\input, q.sck_sfa30_f.asMap);
  ~sck_adc_49_1 = { \input.kr };
  ~sck_adc_49_1.set(\input, q.sck_adc_49_1.asMap);
  ~gene_pm_1 = { \input.kr };
  ~gene_pm_1.set(\input, q.gene_pm_1.asMap);
  ~gene_pm_25 = { \input.kr };
  ~gene_pm_25.set(\input, q.gene_pm_25.asMap);
  ~gene_pm_10 = { \input.kr };
  ~gene_pm_10.set(\input, q.gene_pm_10.asMap);
  ~gene_nox = { \input.kr };
  ~gene_nox.set(\input, q.gene_nox.asMap);
  ~gene_no2 = { \input.kr };
  ~gene_no2.set(\input, q.gene_no2.asMap);
);

~pm_1_release = 0.1;
~pm_25_release = 0.12;
~pm_10_release = 0.15;

~reverb_mix = 0.5;
~reverb_size = 1.0;
~reverb_damp = 0.15;

~lpg_limit = 0.7;

"Setting up harmony movement".postln;

~harmony_current_state = { \state.kr(0) };

(t = Task.new({
  loop({
    var state = q.harmony_transition_stream.next;
    ~harmony_current_state.set(\state, state);
    q.harmony_transition_base_time.wait * ((q.light.value/15000)*4.0);
  });
});
t.start);

"Setting up control signals".postln;

~noisiness = { LFNoise2.kr(500).range(0, 0.15) + LinLin.kr(~user_threshold, 0, 1, -1, 0) };
~dust_density = { LinLin.kr(~user_threshold, 0, 1, 0.1, 1.5) };
~osc_amp = { SinOsc.ar(0.1).range(0.1, 0.2) };
~pm_1_pitch = { Select.kr(~harmony_current_state, q.pm_1_notes) };
~pm_25_pitch = { Select.kr(~harmony_current_state, q.pm_25_notes) };
~pm_10_pitch = { Select.kr(~harmony_current_state, q.pm_10_notes) };

~attack =  { 0.01 + LinLin.kr(~user_threshold, 0, 1, 0.1, 0.0) };

"Setting up synths".postln;

(
SynthDef(\pm_synth, {
  var env = EnvGen.ar(Env.perc(\attack.kr, \release.kr), Dust.kr(\data.kr * ~dust_density));
  var osc = LPG.ar(XFade2.ar(AnalogFoldOsc.ar(\freq.kr, ~osc_amp), PinkNoise.ar, ~noisiness), env * ~lpg_limit);
  var reso = Resonator.ar(osc, LFNoise2.kr(500).range(-50, 50) + \freq.kr, damping: 0.2, position: 0.1, structure: 0.4);
  var distort = AnalogVintageDistortion.ar(reso, bias: 2.0, drivegain: 0.3, highgain: 0.3, shelvingfreq: 500);
  var mix = XFade2.ar(osc, distort, LinLin.ar(~user_threshold, 0, 1, -1, 1));
  Out.ar(\out.kr(0), mix * EnvGen.kr(Env.asr(\fadeTime.kr(0.1), 1, \fadeTime.kr(0.1)), \gate.kr(1.0), doneAction: Done.freeSelf))
}).add;
);

s.sync; // WILL ERROR WHEN RUNNING DIRECTLY FROM SC UI

(
~sck_pm_1_osc = \pm_synth;
~sck_pm_1_osc.set(\release, ~pm_1_release, \freq, ~pm_1_pitch, \data, ~sck_pm_1, \attack, ~attack);


~sck_pm_25_osc = \pm_synth;
~sck_pm_25_osc.set(\release, ~pm_25_release, \freq, ~pm_25_pitch, \data, ~sck_pm_25, \attack);

~sck_pm_10_osc = \pm_synth;
~sck_pm_10_osc.set(\release, ~pm_10_release, \freq, ~pm_10_pitch, \data, ~sck_pm_10);

~gene_pm_1_osc = \pm_synth;
~gene_pm_1_osc.set(\release, ~pm_1_release, \freq, ~pm_1_pitch, \data, ~gene_pm_1);

~gene_pm_25_osc = \pm_synth;
~gene_pm_25_osc.set(\release, ~pm_25_release, \freq, ~pm_25_pitch, \data, ~gene_pm_25);

~gene_pm_10_osc = \pm_synth;
~gene_pm_10_osc.set(\release, ~pm_10_release, \freq, ~pm_10_pitch, \data, ~gene_pm_10);
);

(~bass_osc = {
  var clean = SinOsc.ar(Select.kr(~harmony_current_state, q.bass_notes)) * SinOsc.ar(LinLin.kr(~user_threshold, 0, 1, 0.2, 5.0)).range(LinLin.kr(~user_threshold, 0, 1, 0.8, 0), 1.0);
  var distort = AnalogVintageDistortion.ar(clean, bias: SinOsc.ar(3).range(0, 2.5), lowgain:0.2,highgain:0.3, drivegain: LinLin.kr(~user_threshold, 0, 1, 0, 1));
  var comped = DCompressor.ar(XFade2.ar(clean, LPF.ar(distort, 600), LinLin.kr(~user_threshold, 0, 1, -1, 1)), ratio: 10);
  comped * LinLin.ar(~user_threshold, 0, 1, 1.2 , 0.75);
});

(~sck_adc_49_1_osc = {
  var pitch = Select.kr(~harmony_current_state, q.adc_49_1_notes);
  var fmPitch = (2 * pitch) + LFTri.ar(0.05).range(-0.2*pitch, 0.2*pitch) ;
  var fmAmt = SinOsc.kr(0.04).range(24, 32);
  var amp = LinLin.kr(~sck_adc_49_1, 0.0, 1.0, 0.5, 1.0) * LinLin.kr(~user_threshold, 0.0, 1.0, 0.0, 0.3);
  var clicks = Saw.ar(LinLin.kr(~sck_adc_49_1, 0.0, 1.0, 0.2, 10.0));
  var lfo = LFTri.ar(1/25.0, iphase: 1).range(0, 1);
  SinOsc.ar(pitch + SinOsc.kr(fmPitch, mul: fmAmt)) * amp * clicks * lfo;
})

(~gene_no2_osc = {
  var pitch = Select.kr(~harmony_current_state, q.gene_no2_notes);
  var fmPitch = (4 * pitch) + LFTri.ar(0.05).range(-0.2*pitch, 0.2*pitch) ;
  var fmAmt = SinOsc.kr(0.04).range(24, 32);
  var amp = LinLin.kr(~gene_no2, 0.0, 20.0, 0.5, 1.0) * LinLin.kr(~user_threshold, 0.0, 1.0, 0.0, 0.3);
  var clicks = Saw.ar(LinLin.kr(~gene_no2, 0.0, 13.0, 0.1, 7.0));
  var lfo = LFTri.ar(1/30.0).range(0, 1);
  SinOsc.ar(pitch + SinOsc.kr(fmPitch, mul: fmAmt)) * amp * clicks * lfo;
})

"Setting up sample players".postln;

(~ambience = {
  DCompressor.ar(XFade2.ar(
    PlayBuf.ar(1, q.countryside_ambience.bufnum, BufRateScale.kr(q.countryside_ambience.bufnum), loop: 1.0) * 3.0,
    XFade2.ar(
      PlayBuf.ar(1, q.refinery_ambience.bufnum, BufRateScale.kr(q.refinery_ambience.bufnum), loop: 1.0) * 2.0,
      PlayBuf.ar(1, q.machinery_loop.bufnum, BufRateScale.kr(q.machinery_loop.bufnum), loop: 0.5),
      SinOsc.ar(0.1).range(-1, 0.5) + LFNoise2.ar(1000).range(-0.3, 0.3)
    ),
    LinLin.kr(~user_threshold, 0, 1, -1, 1),
  ), ratio: 15)
});

(
SynthDef(\grain_sample_player, {
  var attack = \attack.kr(0);
  var release = \release.kr(0.1);
  var pitch_variation_range = \pitch_variation.kr(0.0);
  var pitch_variation = LFNoise2.kr(500).range(1.0 - pitch_variation_range, 1.0 + pitch_variation_range);
  var impulses = Dust.kr(\grain_density.kr(0));
  var bufnum = \bufnum.kr;
  var windows = EnvGen.ar(Env.perc(attack, release, curve: 0), impulses);
  var playHead = Phasor.ar(
    impulses,
    BufRateScale.kr(bufnum) * pitch_variation,
    0, BufFrames.kr(bufnum),
    WhiteNoise.kr(BufFrames.kr(bufnum))
  );
  var outSig = BufRd.ar(1, bufnum, playHead);
  var windowed = outSig * windows;
  Out.ar(\out.kr(0), windowed * EnvGen.kr(Env.asr(\fadeTime.kr(0.1), 1, \fadeTime.kr(0.1)), \gate.kr(1.0), doneAction: Done.freeSelf))
}).add;
);

s.sync; //WILL ERROR WHEN  RUNNING DIRECTLY FROM SC UI

(
~sck_sfa30_f_grain_density = {  ~sck_sfa30_f * ~user_threshold * 2 };
~sck_sfa30_f_release = { 0.2 * ~user_threshold };

~sck_sfa30_f_osc = \grain_sample_player;
~sck_sfa30_f_osc.set(
  \bufnum, q.bombona_hit.bufnum,
  \grain_density, ~sck_sfa30_f_grain_density,
  \attack, 0.0,
  \release, ~sck_sfa30_f_release,
  \pitch_variation, 0.2
);

~gene_nox_grain_density = {  ~gene_nox * ~user_threshold * 0.33 };
~gene_nox_release = { 0.2 * ~user_threshold };

~gene_nox_osc = \grain_sample_player;
~gene_nox_osc.set(
  \bufnum, q.bombona_hit.bufnum,
  \grain_density, ~gene_nox_grain_density,
  \attack, 0.0,
  \release, ~gene_nox_release,
  \pitch_variation, 0.5
);
);




"SETTING UP MIX".postln;

~base_mix = { (LinLin.kr(~light, 0, 15000, 0.1, 0.05) * ~bass_osc) + (0.5 * ~ambience) };

~gene_mix = { ~gene_pm_1_osc + ~gene_pm_25_osc + ~gene_pm_10_osc + (~gene_nox_osc * LinLin.kr(~light, 0, 15000, 0.3, 1.0)) + (~gene_no2_osc * LinLin.kr(~light, 0, 15000, 0.5, 0.15)) };

~sck_mix = { ~sck_pm_1_osc + ~sck_pm_25_osc + ~sck_pm_10_osc + (~sck_sfa30_f_osc * LinLin.kr(~light, 0, 15000, 0.3, 1.0)) + (~sck_adc_49_1_osc * LinLin.kr(~light, 0, 15000, 0.5, 0.15)) };

~left_mix = { (2.0 * ~gene_mix) + ~base_mix };

~right_mix = { (2.0 * ~sck_mix) + ~base_mix };

~out = { 0.5* FreeVerb.ar(DCompressor.ar([~left_mix, ~right_mix], ratio: 5), room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) };

~out.play;

~test = { ~sck_adc_49_1_osc + ~gene_no2_osc }
~test.pause


