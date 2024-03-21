Shader "Unlit/RoundedHealthBar"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Health("Health Bar", Range(0,1)) = 1
        _Frequency("Flash Frequency", Float) = 4
        _Amplitude("flash Amplitude", Range(0,1)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"}

        Pass
        {
            ZWrite Off
            //src * srcAlpha + dst * (1-srcAlpha) //src = color output of shader, dst = existing color in the frame buffer
            Blend SrcAlpha OneMinusSrcAlpha // Alpha blending

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float _Health;

            float _Frequency;
            float _Amplitude;

            struct MeshData
            {
                float4 vertex : POSITION; // vertex position
                float3 normals : NORMAL;
                float4 uv0 : TEXCOORD0; // uv0 diffuse/normal map textures
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION; //clip space position
                float2 uv : TEXCOORD1;
            };


            Interpolators vert (MeshData v) // just pass data from vertex shader to fragment shader 
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex); //local space to clip space
                o.uv = v.uv0;
                return o;
            }
            float InverseLerp(float a, float b, float v) {
                return (v - a) / (b - a);
            }

            float4 frag(Interpolators i) : SV_Target
            {
                //rounded corners
                float2 coords = i.uv;
                coords.x *= 8; // makes the bar uv.x coords in between 0-8 instead of 0-1

                float2 pointOnLineSeg = float2(clamp(coords.x, 0.5, 7.5), 0.5); //the bar starts from 0 to 8 and the radius of end circles are 0.5
                float sdf = distance(coords, pointOnLineSeg) * 2 - 1;
                clip(-sdf); //remove the outer edges

                float healthbarMask = _Health > i.uv.x; //if uv.x is greater than health make it black
                float3 healthbarColor = tex2D(_MainTex, float2 (_Health, i.uv.y));
                //pulsating effect:
                if (_Health < 0.2) {
                    float flash = cos(_Time.y * _Frequency) * _Amplitude + 1;
                    healthbarColor *= flash;  // * -> retain hue when flashing, + -> still flashes but hue is changed
                }

                return float4(healthbarColor * healthbarMask, 1);

            }
            ENDCG
        }
    }
}
