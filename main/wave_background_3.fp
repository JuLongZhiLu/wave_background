// 定义常量块 (注意：名字要和材质编辑器里的 Name 一致)
uniform mediump vec4 time_data;
varying mediump vec2 var_texcoord0;

void main()
{
	float t = time_data.x;
	float speed_factor = t * 2.0; // 控制总速度

	// 关键点：改变 UV 的方式
	// 减去 speed_factor 会让图案向正方向移动
	// uv.x - speed_factor -> 向右移动
	// uv.y + speed_factor -> 向下移动 (注意：UV 的 0,0 通常在左下角)
	mediump vec2 uv = var_texcoord0 * 8.0; 

	// 核心算法修改：
	// 使用 uv.x - uv.y 改变波浪的倾斜方向（使其变成斜向上斜杠 / ）
	// 然后减去 speed_factor 让它整体向右下角滑动
	float wave = sin((uv.x - uv.y) - speed_factor + sin(uv.x * 0.5));

	// ... 后续颜色代码保持不变 ...
	lowp vec3 color_bright = vec3(0.0, 0.6, 1.0);
	lowp vec3 color_dark = vec3(0.0, 0.45, 0.9);
	lowp float mask = step(0.0, wave);
	gl_FragColor = vec4(mix(color_dark, color_bright, mask), 1.0);
}