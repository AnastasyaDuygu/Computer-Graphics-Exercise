Shader "Unlit/RoundedCorner"
{
    Properties
    {
        _Health("Health Bar", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float _Health;

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

            float4 frag(Interpolators i) : SV_Target
            {
                float2 coords = i.uv;
                coords.x *= 8; // makes the bar uv.x coords in between 0-8 instead of 0-1

                float2 pointOnLineSeg = float2(clamp(coords.x, 0.5, 7.5), 0.5); //the bar starts from 0 to 8 and the radius of end circles are 0.5
                float sdf = distance(coords, pointOnLineSeg) * 2 - 1;
                clip(-sdf); //remove the outer edges

                //return float4(frac(coords), 0, 1); //rounded edge bar w/ fractioned uv to visualise better

                float healthbarMask = _Health > i.uv.x; //if uv.x is greater than health make it black

                return float4(healthbarMask.xxx, 1);

            }
            ENDCG
        }
    }
}
