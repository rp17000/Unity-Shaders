﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Cody/Zoom" {
    Properties {
        _Zoom ("Zoom", Range(0, 200)) = 0
    }
    SubShader {
        GrabPass { "_GrabTexture" }
 
        Pass {
            Tags { "Queue"="Transparent" "RenderType"="Transparent" }

            ZTest Always
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
 
            struct v2f {
                half4 pos : SV_POSITION;
                half4 grabPos : TEXCOORD0;
            };
 
            sampler2D _GrabTexture;
            float _Zoom;
 
            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.grabPos = ComputeGrabScreenPos(o.pos + half4(0, 0, 0, _Zoom));
                return o;
            }
 
            half4 frag(v2f i) : COLOR {
                fixed4 color = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.grabPos));
                fixed val = (color.x  + color.y + color.z) / 3;
                return fixed4(val, val, val, color.a);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}