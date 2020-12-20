// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/GlassShader"
{
	Properties {
        _CenterX("CenterX", float) = 0
        _CenterY("CenterY", float) = 0
        _AreaSize("AreaSize", float) = 1.2
        _Power("Power", float) = 1.2
        _Whity("Whity", float) = 0.1
	}

	SubShader {
		Tags {
			"Queue"      = "Transparent"
			"RenderType" = "Transparent"
		}

		GrabPass {}
		
		
        Pass
        {
            CGPROGRAM
// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct v2f members normalDirection,viewDirection)
#pragma exclude_renderers d3d11
            
			#pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

			sampler2D _GrabTexture;
			float _CenterX;
			float _CenterY;
            float _AreaSize;
            float _Power;
            float _Whity;
            
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };
            
            
            struct v2f
            {
                float4 position : POSITION;
                float4 screenPos : TEXCOORD0;
                float3 normalDirection : NORMAL0;
                float3 viewDirection : NORMAL1;
            };
            
            
            v2f vert (appdata v)
            {
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
                o.screenPos = ComputeGrabScreenPos(o.position);
                
                
                float4x4 modelMatrix        = unity_ObjectToWorld;
                float4x4 modelMatrixInverse = unity_WorldToObject;

                o.normalDirection = normalize(mul(v.normal, modelMatrixInverse)).xyz;
                o.viewDirection   = normalize(_WorldSpaceCameraPos - mul(modelMatrix, v.vertex).xyz);
                return o;
            }
            

            float4 frag (v2f v) : COLOR 
            {
                float2 renderPos = v.screenPos.xy / v.screenPos.w;
                float2 center = float2(_CenterX, _CenterY);
                
                float3 normalDirection = normalize(v.normalDirection);
                float3 viewDirection   = normalize(v.viewDirection);
                float strength = abs(dot(viewDirection, normalDirection));
                
                float2 diff = renderPos - center;
                float2 grabUV = center - diff * _AreaSize * pow(strength, _Power);
                
                float3 grab = tex2D(_GrabTexture, grabUV).rgb;
                float4 color = float4(grab.x,grab.y,grab.z,1) + float4(_Whity, _Whity, _Whity, 0);
                
                return color;
            }
            
            ENDCG
            
        }
		
		/*
		CGPROGRAM
			#pragma target 3.0
			#pragma surface surf Standard fullforwardshadows

			sampler2D _GrabTexture;
			float _CenterX;
			float _CenterY;
            float _AreaSize;
            
			struct Input {
				float4 screenPos;
				float3 normal:NORMAL;
			};


            void surf (Input IN, inout SurfaceOutputStandard o) {
                float2 renderPos = (IN.screenPos.xy / IN.screenPos.w);
                float2 center = float2(_CenterX, _CenterY);
                
                float2 diff = renderPos - center;
                float2 grabUV = center - diff * _AreaSize;
                
                fixed3 grab = tex2D(_GrabTexture, grabUV).rgb;
                
				o.Emission = grab;
                o.Albedo = fixed3(0, 0, 0);
            }
		ENDCG
		*/
	}

	FallBack "Transparent/Diffuse"
}