Shader "Custom/ShindoShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
        Tags { "RenderType"="Opaque" }
        LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			uniform sampler2D _CameraDepthTexture;


			fixed4 Bulr(float weght,v2f i)
			{
				float2 sift = (1.0f - _ScreenParams.zw)*weght;
				float4 col = tex2D(_MainTex, i.uv);
				//float4 col[8];
				col += tex2D(_MainTex, i.uv + float2(sift.x, 0));
				col += tex2D(_MainTex, i.uv + float2(-sift.x, 0));
				col += tex2D(_MainTex, i.uv + float2(0, -sift.y));
				col += tex2D(_MainTex, i.uv + float2(0, sift.y));
				col += tex2D(_MainTex, i.uv + float2(sift.x, sift.y));
				col += tex2D(_MainTex, i.uv + float2(-sift.x, -sift.y));
				col += tex2D(_MainTex, i.uv + float2(-sift.x, sift.y));
				col += tex2D(_MainTex, i.uv + float2(sift.x, -sift.y));

				col /= 9.0f;

				return col;
			}

			float4 GetDepth(float2 uv)
			{
				return UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, uv));
			}

			fixed4 frag (v2f i) : SV_Target
			{
				//DOFもどき
				//return Bulr(saturate((1.0-GetDepth(i.uv)*100.0f))*8.0f,i);
				
				float d = (1-GetDepth(i.uv))*100;

				float4 col = tex2D(_MainTex,i.uv);

				fixed4 fogColor = fixed4(0.2f,0.0f,0.0f,1.0f);

				return col + (max(0,(1-d))*fogColor);
			}
			ENDCG
		}
	}
}