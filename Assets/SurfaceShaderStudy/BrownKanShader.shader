Shader "Custom/BrownKanShader" {
	Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }
	SubShader
	{
	    Tags{ "Queue" = "Geometry" "RenderType" = "Opaque"}
		LOD 200
		
        Pass
        {
		    ZWrite On
		    
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
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                o.uv = v.uv;
                return o;
            }
            
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 sliceNoise = 1 - 0.5 * step(sin(i.vertex.y), -0.8);
                fixed4 runNoise = min(fixed4(1,1,1,1), abs(i.vertex.y - (_Time.y/2 - floor(_Time.y/2))*2000)/50.0) * 0.1 + 0.9;
                
                col.r = col.r * min(sliceNoise.r, runNoise.r);
                col.g = col.g * min(sliceNoise.g, runNoise.g);
                col.b = col.b * min(sliceNoise.b, runNoise.b);
                

                return col;
            }
            ENDCG
        }
	   
	}
	FallBack "Diffuse"
}
