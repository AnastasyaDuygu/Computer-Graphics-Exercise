// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/MyFirstShader"
{
	Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
	}
    SubShader {

		Pass {
			CGPROGRAM

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "UnityCG.cginc"
			//return UnityObjectToClipPos(position);
			float4 _Tint;

			struct Interpolators {
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			struct VertexData {
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
			};

			Interpolators MyVertexProgram (VertexData v) {
				Interpolators i;
				i.position = UnityObjectToClipPos(v.position);
				i.uv = v.uv;
				return i;
			}

			float4 MyFragmentProgram (Interpolators i) : SV_TARGET {
				return float4(i.uv, 1, 1);
			}
			ENDCG
		}
	}
}
