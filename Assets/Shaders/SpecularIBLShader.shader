Shader "Unlit/DiffuseIBLightShader"
{
    Properties
    {
        _RockAlbedo ("Albedo", 2D) = "white" {}
        [NoScaleOffset] _RockNormals ("Normals", 2D) = "bump" {}
        [NoScaleOffset] _RockHeight ("Height", 2D) = "bump" {}
        _NormalIntensity ("Normal Intensity", Range(0,1)) = 1
        _DisplacementIntensity ("Displacemnet Intensity", Range(0,0.2)) = 0.1
        _Tint("Color", Color) = (1,1,1,1)
        _Gloss("Gloss", Float ) = 1
        
        _AmbientLight("Ambient Light", Color) = (1,1,1,1)
        
        _SpecularIBL("Specular IBL", 2D) = "black" {}
        _SpecIBLIntensity("Specular IBL Intensity", Range(0,1)) = 1
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
            #include "SpecularIBLCGINC.cginc"
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

            #include "SpecularIBLCGINC.cginc"
            ENDCG
        }
    }
}
