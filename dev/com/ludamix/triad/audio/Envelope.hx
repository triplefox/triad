package com.ludamix.triad.audio;

class EnvelopeSegment
{
	
	public var start:Float;
	public var end:Float;
	public var distance:Float;
	public var curvature:Float;
	public var quantization:Float;
	public var next:EnvelopeSegment;
	public var attacks : Bool;
	public var sustains : Bool;
	public var releases : Bool;
	
	public function new(start : Float, end : Float, distance : Float, ?curvature : Float = 1.0, ?quantization : Float = 0.)	
	{
		this.start = start;  this.end = end; this.distance = distance; this.curvature = curvature; 
		this.quantization = quantization; next = this;
		attacks = false;  sustains = false; releases = false;
	}
	
	public inline function getLevel(pos : Float) : Float
	{
		return (end - start) * Math.pow(quantize(pos / distance), curvature) + start;
	}
	
	public inline function quantize(pos : Float) : Float	
	{
		if (quantization <= 0.)
			return pos;
		else
			return Std.int(pos * quantization) / quantization;
	}
	
}

typedef EnvelopeProfile = { attack:EnvelopeSegment, release:EnvelopeSegment, assigns:Array<Int>, endpoint:Float,
	curvature : Float};

class Envelope
{
	
	public var segment : EnvelopeSegment;
	public var release : EnvelopeSegment;
	public var position : Float;
	public var curvature : Float;
	public var level : Float;
	public var endpoint : Float;
	public var release_level : Float;
	public var assigns : Array<Int>;
	
	
	// note: env segments should be in the 0.0-1.0 range.
	
	public static inline var PEAK = 1.0;
	public static inline var MIN_POWER = 0.000016; // -96dB
	
	public function new(segment, release, assigns, endpoint, curvature)
	{
		this.segment = segment;
		this.release = release;
		this.assigns = assigns;
		this.endpoint = endpoint;
		this.curvature = curvature;
		position = 0.;
		release_level = PEAK;
		level = update(0.);
	}
	
	public function update(amount : Float)
	{
		if (segment == null) return endpoint;
		position += amount;
		while (position >= segment.distance || segment.distance <= 0.)
		{
			position -= segment.distance;
			segment = segment.next; 
			if (segment == null) { return endpoint; }
		}
		if (!releasing())
		{
			release_level = segment.getLevel(position);
			level = Math.pow(release_level, curvature);			
		}
		else
			level = Math.pow(segment.getLevel(position) * release_level,curvature);
		return level;
	}
	
	public function setRelease()
	{
		if (!releasing())
		{
			release_level = segment.getLevel(position);
			segment = release;
			position = 0.;
		}
	}
	
	public function setOff()
	{
		segment = null;
		release_level = 0.;
		level = 0.;
	}
	
	public inline function attacking() { return segment!=null && segment.attacks; }
	
	public inline function sustaining() { return segment!=null && segment.sustains; }
	
	public inline function releasing() { return segment==null || segment.releases; }
	
	public inline function isOff() { return segment == null && endpoint==0.; }
	
	public static function ADSR(secondsToFrames : Float->Float, 
		attack_time : Float, decay_time : Float, sustain_level : Float, release_time : Float,
		assigns : Array<Int>, curvature : Float) : EnvelopeProfile
	{
		return DSAHDSHR(secondsToFrames, 0., 0., attack_time, 0., decay_time, sustain_level, 0., release_time,
			1.0, 1.0, 1.0, assigns, curvature);
	}
	
	public static function DSAHDSHR(secondsToFrames : Float->Float, delay_time : Float, start_level : Float,
		attack_time : Float, attack_hold_time : Float, decay_time : Float, sustain_level : Float, 
		release_hold_time : Float, release_time : Float, attack_curve : Float, decay_curve : Float, release_curve : Float,
		assigns : Array<Int>, curvature : Float
	) : EnvelopeProfile
	{
		
		var l = delay_time<=0 ? null : [start_level, start_level, delay_time, attack_curve];		
		var a = attack_time<=0 ? null : [start_level, PEAK, attack_time, attack_curve];
		var a_h = attack_hold_time<=0 ? null : [PEAK, PEAK, attack_hold_time, attack_curve];	
		var d = decay_time<=0 ? null : [PEAK, sustain_level, decay_time, decay_curve];
		var s = sustain_level<=MIN_POWER ? null : [sustain_level, sustain_level, 10000, decay_curve];
		var r_h = release_hold_time<=0 ? null : [PEAK, PEAK, release_hold_time,release_curve];
		var r = release_time<=0 ? null : [PEAK, 0., release_time, release_curve];
		
		var base_atk = [l, a, a_h, d];
		var base_sus = [s];
		var base_rel = [r_h, r];
		
		var atk = new Array<Array<Float>>();
		var sus = new Array<Array<Float>>();
		var rel = new Array<Array<Float>>();
		for (n in base_atk) { if (n!=null && n[3] > 0) atk.push(n); }
		for (n in base_sus) { if (n!=null && n[3] > 0) sus.push(n); }
		for (n in base_rel) { if (n!=null && n[3] > 0) rel.push(n); }
		if (atk.length == 0) atk.push([start_level,PEAK,0.,attack_curve]);
		if (rel.length == 0) rel.push([PEAK,0.,0.,release_curve]);
		if (sus.length == 0) sus = null;
		
		return vector(secondsToFrames, atk, sus, rel, assigns, 0., curvature);
	}
	
	public static function vector(secondsToFrames : Float->Float, 
		i_attack : Array<Array<Float>>, i_sustain : Array<Array<Float>>, 
		i_release : Array<Array<Float>>, assigns : Array<Int>, endpoint : Float, curvature : Float)
	{
		// constructs a vector using more-or-less the exact syntax of EnvelopeSegment
		var convertVector = function(i : Array<Float>) : EnvelopeSegment
		{
			var t = secondsToFrames(i[2]);
			if (i.length == 3)
				return new EnvelopeSegment(i[0], i[1], t);
			if (i.length == 4)
				return new EnvelopeSegment(i[0], i[1], t, i[3]);							
			else
				return new EnvelopeSegment(i[0], i[1], t, i[3], i[4]);
		}
		var linkVectors = function(i : Array<Array<Float>>) : Array<EnvelopeSegment>
		{
			var result = new Array<EnvelopeSegment>();
			for ( n in i )
				result.push(convertVector(n));
			if (result.length > 1)
			{
				for (r in 0...result.length - 1)
					result[r].next = result[r + 1];
			}
			return result;
		}
		
		var attack = linkVectors(i_attack);
		for (a in attack) a.attacks = true;
		var release = linkVectors(i_release);
		for (r in release) r.releases = true;
		var sustain = linkVectors(i_sustain == null ? i_release : i_sustain);		
		for (s in sustain) s.sustains = true;
		
		attack[attack.length - 1].next = sustain[0];
		sustain[sustain.length - 1].next = i_sustain == null ? null : sustain[0];
		release[release.length - 1].next = null;
		
		return {attack:attack[0], release:release[0], assigns:assigns, endpoint:endpoint, curvature:curvature};
	}
	
}