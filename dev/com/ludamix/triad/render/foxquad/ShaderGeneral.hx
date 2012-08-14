package com.ludamix.triad.render.foxquad;

class ShaderGeneral {}

class ShaderGeneral2D extends format.hxsl.Shader {

	static var SRC = {
		var input : {
			pos : Float2,
			uv : Float2,
		};
		var tuv : Float2;
		var trgba : Float4;
		function vertex( mproj : M44, mtrans : M44, rgba : Float4) {
			out = pos.xyzw * mtrans * mproj;
			tuv = uv;
			trgba = rgba;
		}
		function fragment( tex : Texture ) {
			out = tex.get(tuv, clamp, nearest) * trgba;
		}
	};

}

class ShaderGeneral2PointFiveD extends format.hxsl.Shader {

	static var SRC = {
		var input : {
			pos : Float3,
			uv : Float2,
		};
		var tuv : Float2;
		var trgba : Float4;
		function vertex( mproj : M44, mtrans : M44, rgba : Float4) {
		   out = pos.xyzw * mtrans * mproj;
		   tuv = uv;
		   trgba = rgba;
		}
		function fragment( tex : Texture ) {
			out = tex.get(tuv, clamp, nearest) * trgba;
		}
	};

}
