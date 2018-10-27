Shader "Unity Shaders Book/Chapter11/SceneImage"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color("Color Tint",Color)=(1,1,1,1)
		_HorizontalAmount("Horizonta Amount",Float)=4
		_VerticalAmount("Vertical Amount",Float)=4
		_Speed("Speed",Range(1,100))=30
	}
	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }

		Pass
		{
			Tags { "LightMode"="ForwardBase"}
			ZWrite Off
			Blend SrcAlpha oneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "lighting.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
			float _HorizontalAmount;
			float _VerticalAmount;
			float _Speed;

			struct a2f{
				float4 vertex:POSITION;
				float3 texcoord:TEXCOORD0;
			};
			struct v2f{
				float4 pos:POSITION;
				float2 uv:TEXCOORD0;
			};
			v2f vert(a2f v){
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				o.uv=TRANSFORM_TEX(v.texcoord,_MainTex);
				return o;
			}
			fixed4 frag(v2f i):SV_TARGET{
				float time=floor(_Time.y*_Speed);
				float row=floor(time/_HorizontalAmount);
				float column=time-row*_HorizontalAmount;

				half2 uv=i.uv+half2(column,-row);
				uv.x/=_HorizontalAmount;
			    uv.y/=_VerticalAmount;

				fixed4 c=tex2D(_MainTex,uv);
				c.rgb*=_Color;
				return c;
			}
			ENDCG
		}
	}
	Fallback "transparent/VertexLit"
}