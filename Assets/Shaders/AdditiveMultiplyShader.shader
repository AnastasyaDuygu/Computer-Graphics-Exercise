Shader "Unlit/AdditiveMultiply"
{
    Properties
    {
        _ColorA("Color A", Color) = (1,1,1,1)
        _ColorB("Color B", Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags { 
            "RenderType"="Transparent" //makes it so that objects behind it will also get rendered
            "Queue"="Transparent"
        }

        Pass
        {
            ZWrite Off // Disables writing to depth buffer

            Cull Off // default = Back, Front, Off = renders both sides (needs ZWrite to be off)
            Blend One One // additive , black doesnt change anything with additive rendering
           // Blend DstColor One // multiply

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define TAU 6.2831855

            float4 _ColorA;
            float4 _ColorB;

            struct MeshData // all of them are local space data
            {
                float4 vertex : POSITION; // vertex position
                float3 normals : NORMAL;
                float4 uv0 : TEXCOORD0; // uv0 diffuse/normal map textures
                //float4 uv1 : TEXCOORD1; // uv1 coordinates lightmap coordinates
                //float4 tangent : TANGENT;
                //float4 color : COLOR;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION; //clip space position
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            Interpolators vert (MeshData v) // just pass data from vertex shader to fragment shader 
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex); //local space to clip space
                o.normal = mul ((float3x3)UNITY_MATRIX_M, v.normals); // = UnityObjectToWorldNormal(v.normals) // when you rotate the sphere normals don't change
                //o.uv = (v.uv0 + _Offset) * _Scale;
                o.uv = v.uv0;
                return o;
            }

            float CreateMovingWaves(float coordinates, float repeat, float offset){ //Create dynamic triangle waves
                float speed = 10;
                float t = cos((coordinates + offset - _Time.y * speed/100) * TAU * repeat) * 0.5 + 0.5; // if - _Time then moves in the opposite direction
                t *= 1 - coordinates; //adds gradient to waves // 1 - coordinates => reverses gradient pos
                return t;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float wiggleIntensity = 1;
                float offset = cos (i.uv.x * TAU * 8) * wiggleIntensity/100; //creates wiggly lines

                float triangleWaves = CreateMovingWaves(i.uv.y, 5, offset);
                float topBottomRemover = abs(i.normal.y) < 0.999; // removes bottom and top cap
                
                float waves = triangleWaves * topBottomRemover;

                float4 gradient = lerp(_ColorA, _ColorB, i.uv.y);
                return gradient * waves; 
                
                
            }
            ENDCG
        }
    }
}
