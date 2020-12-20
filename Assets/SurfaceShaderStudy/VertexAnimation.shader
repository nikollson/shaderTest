Shader "Custom/VertexAnimation" {
	
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }
	SubShader
	{
	    Tags{ "RenderType" = "Opaque" }
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
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
            
            sampler2D _MainTex;
            
            v2f vert(appdata v)
            {
                v2f o;
                float pal = v.vertex.x + v.vertex.y + v.vertex.x*v.vertex.y - v.vertex.x*v.vertex.y*1.3;
//                v.vertex *= 1+0.5*sin(pal);
                v.vertex *= sin(pal*_Time.y*4)*1.5;
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                o.uv = v.uv;
                return o;
            }
            
            fixed4 frag(v2f i) : SV_Target
            {
//                fixed4 col = tex2D(_MainTex, i.uv);
//                col.r = 0;
//                col.g = 0;
//                return col;

//                    float d = distance(float2(0.5, 0.5), i.uv);
//                    return d;

                    float d = distance(float2(0.5, 0.5), i.uv);
                    float a = abs(sin(_Time.y)) * 0.4; // 閾値  
                    return step(a, d);
            }
            ENDCG
        }
	   
	}
	FallBack "Diffuse"
}
