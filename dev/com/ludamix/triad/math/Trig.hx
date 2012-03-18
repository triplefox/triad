class Trig
{
	
	public static inline function xRadian(ang : Float) {return Math.cos(ang);}
	public static inline function yRadian(ang : Float) {return Math.sin(ang);}
	
	public static inline function deg2rad(ang : Float) { return ang * 0.0174532925; }
	public static inline function rad2deg(ang : Float) { return ang * 57.2957795; }

	public static inline function nearestCardinal(deg : Float) : Float
	{
		while (deg < 0) deg += 360;
		deg = deg % 360;
		if (deg<=45 || deg > 360-45)
			return 0.;
		else if (deg<=90+45 || deg > 90-45)
			return 90.;
		else if (deg<=180+45 || deg > 180-45)
			return 180.;
		else
			return 270.;
	}
	
	public static inline function vec2rad(x : Float, y : Float) : Float
	{
		return Math.atan2(y, x);
	}
	
}