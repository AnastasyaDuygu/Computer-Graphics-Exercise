Shader "Unlit/HealthBar"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Health("Health Bar", Range(0,1)) = 1
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

            float4 _Tint;

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
                //without texture:
                //-------------------------------------------------
                /*
                    float healthbarMask = _Health > i.uv.x; //if uv.x is greater than health make it black
                    //clip(healthbarMask - 0.5); //removes values outside of heathbar mask

                    float tHealthColor = saturate(InverseLerp(0.2, 0.8, _Health)); // makes it so health is clamped btw 0.2-0.8
                    float3 healthbarColor = lerp(float3(1, 0, 0), float3(0, 1, 0), tHealthColor); //red if health is low, green if high

                    //return float4 (healthbarColor, healthbarMask); //makes background transparent, partial transparency => float4(healthbarColor, healthbarMask * 0.5) //ALPHA BLENDING

                    //float3 outColor = lerp(float3(0, 0, 0), healthbarColor, healthbarMask); //healthbarcolor where there is healthbarmask, black where there is not
                    return float4(healthbarColor * healthbarMask, 1); //healthbarcolor where there is healthbarmask, black where there is not
                */
                //-------------------------------------------------
                //with texture:
                float healthbarMask = _Health > i.uv.x; //if uv.x is greater than health make it black
                //float3 healthbarColor = tex2D(_MainTex, i.uv); //adds the whole texture as healthbar
                //texture sampling: //clamp the texture to avoid blended edges
                float3 healthbarColor = tex2D(_MainTex, float2 (_Health, i.uv.y));
                return float4(healthbarColor * healthbarMask, 1);
            }
            ENDCG
        }
    }
}
