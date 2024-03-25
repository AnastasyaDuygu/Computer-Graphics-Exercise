Shader "Unlit/ColorAlbedoShader"
{
    Properties
    {
        _RockAlbedo ("Albedo", 2D) = "white" {}
        _Tint("Color", Color) = (1,1,1,1)
        _Gloss("Gloss", Float ) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass // 1st pass is only for directional lighting
        {
            Tags{ "LightMode" = "ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define IS_IN_BASE_PASS
            #include "ColorAlbedoCGINC.cginc"
            ENDCG
        }

        Pass
        {
            Tags{ "LightMode" = "ForwardAdd"}
            Blend One One //Additive
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd //makes sure all lights are compiled correctly

            #include "ColorAlbedoCGINC.cginc"
            ENDCG
        }
    }
}
