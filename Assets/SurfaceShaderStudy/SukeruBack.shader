// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/SukeruBack"  {
    Properties {
            _MainTex ("Base (RGB)", 2D) = "white" {}
            _SubTex ("Base (RGB)", 2D) = "white" {}
    }
    SubShader {
        Pass {
            ZTest Greater
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
            
            struct v2f {
                float4  pos : SV_POSITION;
                float2  uv : TEXCOORD0;
            };
            
            
            sampler2D _MainTex;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos (v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            float4 frag (v2f i) : COLOR
            {
                return tex2D (_MainTex, i.uv);
            }
            
            ENDCG
        }
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
            
            struct v2f {
                float4  pos : SV_POSITION;
                float2  uv : TEXCOORD0;
            };
            
            sampler2D _SubTex;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos (v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            float4 frag (v2f i) : COLOR
            {
                return tex2D (_SubTex, i.uv);
            }
            
            ENDCG
        }
    }
	FallBack "Diffuse"
}
