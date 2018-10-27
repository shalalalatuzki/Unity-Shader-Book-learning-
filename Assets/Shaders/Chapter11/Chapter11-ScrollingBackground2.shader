Shader "Unity Shaders Books/Chapter11/ScrollingBackground2"
{
	Properties
	{
		_MainTex ("First layer(RGB)", 2D) = "white" {}
		_DetailTex("Second Layer (RGB)")="white"{}
		_ScrollX("Base layer Scroll Speed",Float)=1.0
		_Scroll2X("2nd layer Scroll Speed",Float)=1.0
		_Multiplier("Layer Multiplier",Float)=1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			Tags{"LightMode"="ForwardBase"}

			CGPROGRAM
			
			ENDCG
		}
	}
}