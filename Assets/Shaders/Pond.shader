
// Water Reflection Effect for Unity

// Copyright (c) 2017 Shealyn Hindenlang

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

Shader "Unlit/Pond"
{
	Properties
	{
		_ReflectionTex ("Reflection Texture", 2D) = "black" {}
		_Color ("Water Tint", Color) = (0.9, 0.9, 0.9, 1)
	}

	SubShader
	{
		Tags 
		{ 
			"RenderType" = "Opaque" 
		}
		
		Blend Off
		Fog { Mode Off }

		Pass
		{
			CGPROGRAM

			#pragma exclude_renderers d3d11 gles
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			sampler2D _ReflectionTex;
			float4 _ReflectionTex_ST;
			fixed4 _Color;
			
			int _OrbCount;
			float4 _OrbArray[10];

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
				float4 vertex : SV_POSITION;
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _ReflectionTex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				
				return o;
			}
			
			fixed4 orb_glow(float3 pos)
			{
				fixed4 glow = fixed4(0.623, 0.949, 0.965, 0.8);
				float threshold = 0.75;

				fixed4 result = fixed4(0, 0, 0, 0);

				for (int i = 0; i < _OrbCount; i++)
				{
					float dist = length(_OrbArray[i].xyz - pos);

					fixed4 c = clamp(1 - dist / threshold, 0, 1) * glow;

					result.r = clamp(result.r + c.r, 0, 1);
					result.g = clamp(result.g + c.g, 0, 1);
					result.b = clamp(result.b + c.b, 0, 1);
					result.a = clamp(result.a + c.a, 0, 1);
				}

				return result;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float2 center = float2(0.5, 0.4);
				float period = 50;

				float2 uv = i.uv - center;				
				float len = length(uv);
				float time = _Time.y * 2;
				float distortion = 0.4 * sin(period * len - time);

				uv += distortion * uv;
				uv += center;

				float3 w = normalize(float3(i.worldPos.x, 0, i.worldPos.z));
				fixed4 col = tex2D(_ReflectionTex, uv) * _Color + orb_glow(i.worldPos + distortion * w);
				
				return col;
			}

			ENDCG
		}
	}
}
