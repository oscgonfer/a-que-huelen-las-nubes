
p = ProxySpace().push(s.boot);
q = ();
OSCFunc.trace(hideStatusMsg: true);

(
  ~sck_pm_1 = 0.0;
  ~sck_pm_25 = 0.0;
  ~sck_pm_10 = 0.0;
  ~gene_pm_1 = 0.0;
  ~gene_pm_25 = 0.0;
  ~gene_pm_10 = 0.0;
)

~user_threshold = 0 //{ SinOsc.ar(0.1).range(0, 1) };

~noisiness = { LFNoise2.kr(500).range(0, 0.15) + LinLin.kr(~user_threshold, 0, 1, -1, -0.5) };

~dust_density = { LinLin.kr(~user_threshold, 0, 1, 0.1, 1.5) };
~lpg_limit = 1.0;
~osc_amp = { SinOsc.ar(0.1).range(0.1, 0.3) };
~pm_1_pitch = Note("C5").freq;
~pm_25_pitch = Note("F4").freq;
~pm_10_pitch = Note("D4").freq;
~pm_1_release = 0.1;
~pm_25_release = 0.12;
~pm_10_release = 0.15;


~reverb_mix = 0.6
~reverb_size = 1.0
~reverb_damp = 0.4

~sck_pm_1_env = { EnvGen.ar(Env.perc(0.0, ~pm_1_release), Dust.kr(~sck_pm_1 * ~dust_density)) }
~sck_pm_1_osc = { LPG.ar(XFade2.ar(AnalogFoldOsc.ar(~pm_1_pitch, ~osc_amp), PinkNoise.ar, ~noisiness), ~sck_pm_1_env * ~lpg_limit) }

~sck_pm_25_env = { EnvGen.ar(Env.perc(0.0, ~pm_25_release), Dust.kr(~sck_pm_25 * ~dust_density)) }
~sck_pm_25_osc = { LPG.ar(XFade2.ar(AnalogFoldOsc.ar(~pm_25_pitch, ~osc_amp), PinkNoise.ar, ~noisiness), ~sck_pm_25_env * ~lpg_limit) }

~sck_pm_10_env = { EnvGen.ar(Env.perc(0.0, ~pm_10_release), Dust.kr(~sck_pm_10 * ~dust_density)) }
~sck_pm_10_osc = { LPG.ar(XFade2.ar(AnalogFoldOsc.ar(~pm_10_pitch, ~osc_amp), PinkNoise.ar, ~noisiness), ~sck_pm_10_env * ~lpg_limit) }

~gene_pm_1_env = { EnvGen.ar(Env.perc(0.0, ~pm_1_release), Dust.kr(~gene_pm_1 * ~dust_density)) }
~gene_pm_1_osc = { LPG.ar(XFade2.ar(AnalogFoldOsc.ar(~pm_1_pitch, ~osc_amp), PinkNoise.ar, ~noisiness), ~gene_pm_1_env * ~lpg_limit) }

~gene_pm_25_env = { EnvGen.ar(Env.perc(0.0, ~pm_25_release), Dust.kr(~gene_pm_25 * ~dust_density)) }
~gene_pm_25_osc = { LPG.ar(XFade2.ar(AnalogFoldOsc.ar(~pm_25_pitch, ~osc_amp), PinkNoise.ar, ~noisiness), ~gene_pm_25_env * ~lpg_limit) }

~gene_pm_10_env = { EnvGen.ar(Env.perc(0.0, ~pm_10_release), Dust.kr(~gene_pm_10 * ~dust_density)) }
~gene_pm_10_osc = { LPG.ar(XFade2.ar(AnalogFoldOsc.ar(~pm_10_pitch, ~osc_amp), PinkNoise.ar, ~noisiness), ~gene_pm_10_env * ~lpg_limit) }

~gene_mix = { ~gene_pm_1_osc + ~gene_pm_25_osc + ~gene_pm_10_osc }

~sck_mix = { ~sck_pm_1_osc + ~sck_pm_25_osc + ~sck_pm_10_osc }

~out = { FreeVerb.ar([~gene_mix, ~sck_mix], room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }


(
  OSCdef(\sck_pm_1, { |msg|
    ~sck_pm_1 = msg[1];
  }, "/sck/pm_avg_1");

  OSCdef(\sck_pm_25, { |msg|
    ~sck_pm_25 = msg[1];
  }, "/sck/pm_avg_2.5");

  OSCdef(\sck_pm_10, { |msg|
    ~sck_pm_10 = msg[1];
  }, "/sck/pm_avg_10");


  OSCdef(\gene_pm_1, { |msg|
    ~gene_pm_1 = msg[1];
  }, "/gene/pm1");

  OSCdef(\gene_pm_25, { |msg|
    ~gene_pm_25 = msg[1];
  }, "/gene/pm2.5");

  OSCdef(\gene_pm_10, { |msg|
    ~gene_pm_10 = msg[1];
  }, "/gene/pm10");
)
