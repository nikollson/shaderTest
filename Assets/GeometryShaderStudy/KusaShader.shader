Shader "Custom/KusaShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Factor ("Factor", Range(0., 2.)) = 0.2
        _GrassColor ("GrassColor", Color) = (0.6, 0.8, 0.3, 1)
        _GroundColor ("GroundColor", Color) = (0.4, 0.5, 0.2, 1)
        _Width ("Width", Float) = 0.03
        _Height ("Height", Float) = 0.06
        _Yure("Yure", Float) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Cull Off
 
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma geometry geom
 
            #include "UnityCG.cginc"
 
            struct v2g
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };
 
            struct g2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                fixed4 col : COLOR;
            };
            
	
            float rand(float3 co)
            {
                return frac(sin(dot(co.xyz, float3(12.9898, 78.233, 56.787))) * 43758.5453);
            }
	
            float noise(float3 pos)
            {
                float3 ip = floor(pos);
                float3 fp = smoothstep(0, 1, frac(pos));
                float4 a = float4(
                    rand(ip + float3(0, 0, 0)),
                    rand(ip + float3(1, 0, 0)),
                    rand(ip + float3(0, 1, 0)),
                    rand(ip + float3(1, 1, 0)));
                float4 b = float4(
                    rand(ip + float3(0, 0, 1)),
                    rand(ip + float3(1, 0, 1)),
                    rand(ip + float3(0, 1, 1)),
                    rand(ip + float3(1, 1, 1)));
             
                a = lerp(a, b, fp.z);
                a.xy = lerp(a.xy, a.zw, fp.y);
                return lerp(a.x, a.y, fp.x);
            }

            float perlin(float3 pos)
            {
                return 
                    (noise(pos) * 32 +
                    noise(pos * 2 ) * 16 +
                    noise(pos * 4) * 8 +
                    noise(pos * 8) * 4 +
                    noise(pos * 16) * 2 +
                    noise(pos * 32) ) / 63;
            }
 
            sampler2D _MainTex;
            float4 _MainTex_ST;
           
            v2g vert (appdata_base v)
            {
                v2g o;
                o.vertex = v.vertex;
                o.uv = v.texcoord;
                o.normal = v.normal;
                return o;
            }
 
            float _Factor;
            float _Width;
            float _Height;
            float _Yure;
            fixed4 _GroundColor;
            fixed4 _GrassColor;
 
            [maxvertexcount(93)]
            void geom(triangle v2g IN[3], inout TriangleStream<g2f> tristream)
            {
                g2f o;
                
                o.pos = UnityObjectToClipPos(IN[0].vertex);
                o.col = _GroundColor;
                o.uv = IN[0].uv;
                tristream.Append(o);
                
                o.pos = UnityObjectToClipPos(IN[1].vertex);
                o.col = _GroundColor;
                o.uv = IN[1].uv;
                tristream.Append(o);
                
                o.pos = UnityObjectToClipPos(IN[2].vertex);
                o.col = _GroundColor;
                o.uv = IN[2].uv;
                tristream.Append(o);
                
                tristream.RestartStrip();
                
                o.col = _GrassColor;
                
                float4 edgeA = IN[1].vertex - IN[0].vertex;
                float4 edgeB = IN[2].vertex - IN[0].vertex;
                
                float width = 0.01;
                float height = 0.05;
                for(int i=0;i<10;i++)
                {
                    float r1 = rand(float3(IN[0].vertex.x+i, IN[1].vertex.y+i, IN[2].vertex.z + i*2));
                    float r2 = rand(float3(IN[0].vertex.x+i, IN[1].vertex.y+i, IN[2].vertex.z + i*2+1));
                    
                    float4 center = IN[0].vertex + (edgeA * r1 + edgeB * (1-r1)) * r2;
                    
                    float moveA = sin(perlin(center*200)*0.2+(1+perlin(center)*0.2)+_Time.y*0.5) * _Yure * (sin(perlin(center*300)*2*_Time.z)+1)/2;
                    
                    float4 p1 = UnityObjectToClipPos(center + fixed4(0,0,0,0));
                    float4 p2 = UnityObjectToClipPos(center + fixed4(moveA,_Height/2,0,0));
                    float4 p3 = UnityObjectToClipPos(center + fixed4(moveA*2.5+_Width/2,_Height,0,0));
                    float4 p4 = UnityObjectToClipPos(center + fixed4(moveA+_Width,_Height/2,0,0));
                    float4 p5 = UnityObjectToClipPos(center + fixed4(_Width,0,0,0));
                    
                    
                    o.pos = p1;
                    o.col = _GroundColor * 1 + _GrassColor * 0;
                    tristream.Append(o);
                    
                    o.pos = p2;
                    o.col = _GroundColor * 0.5 + _GrassColor * 0.5;
                    tristream.Append(o);
                    
                    o.pos = p5;
                    o.col = _GroundColor * 1 + _GrassColor * 0;
                    tristream.Append(o);
                    
                    tristream.RestartStrip();
                    
                    o.pos = p2;
                    o.col = _GroundColor * 0.5 + _GrassColor * 0.5;
                    tristream.Append(o);
                    o.pos = p4;
                    o.col = _GroundColor * 0.5 + _GrassColor * 0.5;
                    tristream.Append(o);
                    o.pos = p5;
                    o.col = _GroundColor * 1 + _GrassColor * 0;
                    tristream.Append(o);
                    
                    tristream.RestartStrip();
                    
                    o.pos = p2;
                    o.col = _GroundColor * 0.5 + _GrassColor * 0.5;
                    tristream.Append(o);
                    o.pos = p3;
                    o.col = _GroundColor * 0 + _GrassColor * 1;
                    tristream.Append(o);
                    o.pos = p4;
                    o.col = _GroundColor * 0.5 + _GrassColor * 0.5;
                    tristream.Append(o);
                    
                    tristream.RestartStrip();
                }
            }
           
            fixed4 frag (g2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * i.col;
                return col;
            }
            ENDCG
        }
    }
}