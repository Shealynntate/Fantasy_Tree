
// Burn Reveal Effect for Unity

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

Shader "Unlit/HoverOrb"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BaseColor ("Tint", Color) = (0.1, 0.1, 0.1, 1)
		_GlowColor ("Glow Color", Color) = (1, 1, 1, 1)
		[Space(15)]
		_DistortionLevel ("Distortion Level", Range(0, 0.5)) = 0.01
		_TexCutoff ("Texture Cutoff", Range(0, 1)) = 0.5
		_GlowAmount ("Glow Amount", Range(0, 1)) = 0.5
		_NoiseTex ("Noise Texture", 2D) = "black" {}
	}

	SubShader
	{
		Tags 
		{ 
			"RenderType" = "Transparent"
			"Queue" = "Transparent" 
			"IgnoreProjector" = "True"
		}

		Blend SrcAlpha OneMinusSrcAlpha
		Fog { Mode Off }

		Pass
		{
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _BaseColor;
			fixed4 _GlowColor;
			sampler2D _NoiseTex;
			float4 _NoiseTex_ST;
			float _DistortionLevel;
			float _TexCutoff;
			float _GlowAmount;
			float _EffectRadius;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float2 noise_uv : TEXCOORD1;
				float4 vertex : SV_POSITION;
				float3 worldPos : TEXCOORD2;
				float3 viewDir : TEXCOORD3;
			};
			
			v2f vert (appdata v)
			{
				v2f o;

				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.noise_uv = TRANSFORM_TEX(v.uv, _NoiseTex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.viewDir = _WorldSpaceCameraPos - o.worldPos;
				o.vertex = UnityObjectToClipPos(v.vertex);

				return o;
			}
			
			float tex_brightness(fixed4 c)
			{
				return c.r * 0.3 + c.g * 0.59 + c.b * 0.11;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float3 localPos = normalize(i.worldPos -  mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz);
				float3 localView = normalize(mul(unity_WorldToObject, float4(i.viewDir, 0)).xyz);

				// Edge Glow Effect
				float scale = length(localPos - i.viewDir);
				float dotProduct = 1.0 - dot(localPos, localView);

				fixed4 tex = tex2D(_MainTex, i.uv) * _BaseColor;
				fixed4 _color = lerp(tex, _GlowColor, dotProduct);

				// Burn Reveal Effect;
				float tex_alpha_cutoff = 1 - _TexCutoff;
				float noise_tex_alpha = tex_brightness(tex2D(_NoiseTex, i.noise_uv));
		
				float brightness = clamp(noise_tex_alpha * _DistortionLevel + (1 - dotProduct) -  _EffectRadius, 0, 1);
				float glow_cutoff_alpha = tex_alpha_cutoff - _GlowAmount * brightness;
	
				float tex_visible = step(tex_alpha_cutoff, brightness);
				float glow_visible = (1 - tex_visible) * step(glow_cutoff_alpha, brightness);

				_color = (1 - glow_visible) * _color + glow_visible * _GlowColor;
				_color.a = clamp(tex_visible + glow_visible, 0, 1);

				return _color;
			}

			ENDCG
		}
	}
}
