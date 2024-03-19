Shader "Unlit/Texture"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _RockTex("Texture", 2D) = "gray" {}
        _Pattern("Pattern", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define TAU 6.2831855

            sampler2D _MainTex;
            sampler2D _Pattern;
            float4 _MainTex_ST;
            sampler2D _RockTex;

            struct MeshData
            {
                float4 vertex : POSITION; // vertex position
                float3 normals : NORMAL;
                float4 uv0 : TEXCOORD0; // uv0 diffuse/normal map textures
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION; //clip space position
                float2 uv : TEXCOORD0;
                float3 worldPosition : TEXCOORD1;
            };

            float GetPattern(float coord){ //creates pattern
                float t = cos((coord - _Time.y * 0.1) * TAU * 5) * 0.5 + 0.5; // if - _Time then moves in the opposite direction  //* 0.5 + 0.5
                t *= 1 - coord; // gradient
                return t;
            }

            Interpolators vert (MeshData v) // just pass data from vertex shader to fragment shader 
            {
                Interpolators o;
                o.worldPosition = mul (UNITY_MATRIX_M, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex); //local space to clip space
                o.uv = TRANSFORM_TEX(v.uv0, _MainTex);
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float2 topDownProjection = i.worldPosition.xz;
                float4 moss = tex2D(_MainTex, topDownProjection);
                float pattern = tex2D(_Pattern, i.uv).x;
                float4 rock = tex2D(_RockTex, topDownProjection);

                 //return GetPattern( pattern );

                 float4 finalColor = lerp(rock, moss, pattern); // float4( 1, 0, 0, 1 ) = RED
                 return finalColor;
            }
            ENDCG
        }
    }
}
