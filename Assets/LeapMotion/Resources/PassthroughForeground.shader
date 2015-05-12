﻿Shader "LeapMotion/Passthrough/Foreground" {
	Properties {
    _ColorSpaceGamma ("Color Space Gamma", Float) = 1.0
	}

	SubShader {
		Tags {"Queue"="Geometry" "IgnoreProjector"="True" "RenderType"="Opaque"}

		Cull Off
		Zwrite Off
		Blend One Zero

		Pass{
		CGPROGRAM
		#pragma multi_compile LEAP_FORMAT_IR LEAP_FORMAT_RGB
		#include "LeapCG.cginc"
		#include "UnityCG.cginc"
		
		#pragma vertex vert
		#pragma fragment frag
    
    uniform float _ColorSpaceGamma;

		struct frag_in{
			float4 position : SV_POSITION;
			float4 screenPos  : TEXCOORD1;
		};

		frag_in vert(appdata_img v){
			frag_in o;
			o.position = mul(UNITY_MATRIX_MVP, v.vertex);
			o.screenPos = ComputeScreenPos(o.position);
			return o;
		}

		float4 frag (frag_in i) : COLOR {
			return pow(float4(LeapColor(i.screenPos), 1), 1/_ColorSpaceGamma);
		}

		ENDCG
		}
	} 
	Fallback off
}
