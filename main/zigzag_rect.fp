// varying mediump vec2 var_texcoord0;
// 
// uniform fs_uniforms {
// 	mediump vec4 time; // 材质中设置为 Time 类型
// };
// 
// void main()
// {
// 	// 1. 获取基础坐标
// 	vec2 uv = var_texcoord0;
// 
// 	// 2. 波浪参数设置
// 	float speed = time.x * 2.0;    // 移动速度
// 	float frequency = 30.0;        // 频率（波浪有多密）
// 	float amplitude = 0.02;         // 振幅（波浪有多高）
// 	float thickness = 0.2;        // 线条粗细
// 
// 	// 3. 计算波浪的 Y 坐标
// 	// 我们以 0.5 为中心基准线
// 	float wave_y = 0.5 + sin(uv.x * frequency + speed) * amplitude;
// 
// 	// 4. 计算当前像素距离波浪线的距离
// 	float dist = abs(uv.y - wave_y);
// 
// 	//





// varying mediump vec2 var_texcoord0;
// 
// uniform fs_uniforms {
// 	mediump vec4 time;
// };
// 
// void main()
// {
// 	vec2 uv = var_texcoord0;
// 	float t = time.x * 2.0;
// 
// 	// 1. 坐标旋转/投影到 45 度
// 	// d1 是沿着对角线的方向（用来计算波浪的起伏）
// 	// d2 是垂直于对角线的方向（用来计算线条的位置）
// 	// 0.707 是 sin(45°) 和 cos(45°) 的近似值
// 	float d1 = (uv.x + uv.y) * 0.707;
// 	float d2 = (uv.x - uv.y) * 0.707;
// 
// 	// 2. 波浪参数
// 	float frequency = 15.0;   // 频率
// 	float amplitude = 0.06;   // 振幅
// 	float thickness = 0.2;   // 粗细
// 
// 	// 3. 计算 45 度方向的波浪
// 	// 我们让波浪在 d2（垂直对角线方向）上产生偏移
// 	float wave = sin(d1 * frequency + t) * amplitude;
// 
// 	// 4. 计算像素到波浪中心的距离
// 	// 这里的 0.0 表示波浪线穿过图片中心对角线
// 	float dist = abs(d2 - wave);
// 
// 	// 5. 渲染线条
// 	float line_mask = smoothstep(thickness, thickness - 0.005, dist);
// 
// 	// 6. 输出结果
// 	gl_FragColor = vec4(vec3(1.0, 1.0, 1.0) * line_mask, line_mask);
// }






// varying mediump vec2 var_texcoord0;
// 
// uniform fs_uniforms {
// 	mediump vec4 time;
// };
// 
// void main()
// {
// 	vec2 uv = var_texcoord0;
// 	float t = time.x * 2.0;
// 
// 	// 1. 坐标投影到 45 度 (保持不变)
// 	float d1 = (uv.x + uv.y) * 0.707;
// 	float d2 = (uv.x - uv.y) * 0.707;
// 
// 	// 2. 波浪参数 (保持不变)
// 	float frequency = 15.0;   
// 	float amplitude = 0.06;   
// 	float thickness = 0.2;   
// 
// 	// 3. 计算波浪 (保持不变)
// 	float wave = sin(d1 * frequency + t) * amplitude;
// 
// 	// 4. 计算像素到波浪中心的距离 (保持不变)
// 	float dist = abs(d2 - wave);
// 
// 	// 5. 渲染线条掩码 (1.0 表示线条，0.0 表示背景)
// 	float line_mask = smoothstep(thickness, thickness - 0.005, dist);
// 
// 	// 6. 【核心修改】：定义两种蓝色并混合
// 	// 浅蓝色 (线条颜色)
// 	vec3 lightBlue = vec3(0.5, 0.8, 1.0); 
// 	// 较深的蓝色 (背景颜色)
// 	vec3 darkBlue  = vec3(0.2, 0.4, 0.8); 
// 
// 	// 使用 mix 函数根据 mask 混合颜色
// 	// 当 line_mask 为 1 时，输出 lightBlue；为 0 时，输出 darkBlue
// 	vec3 finalColor = mix(darkBlue, lightBlue, line_mask);
// 
// 	// 输出最终颜色，Alpha 设为 1.0（不透明）
// 	gl_FragColor = vec4(finalColor, 1.0);
// }





varying mediump vec2 var_texcoord0;

uniform fs_uniforms {
	mediump vec4 time;
};

void main()
{
	vec2 uv = var_texcoord0;
	float t = time.x * 3.0;

	// ======= 角度控制区 =======
	float angle_deg = 120.0;             // 直接输入角度，想改多少改多少
	float angle_rad = radians(angle_deg); // 转换为弧度

	float s = sin(angle_rad);
	float c = cos(angle_rad);

	// 使用旋转公式计算新的坐标轴
	// d1: 沿着线条的方向（用于波浪起伏）
	// d2: 垂直于线条的方向（用于控制间隔和重复）
	float d1 = uv.x * c + uv.y * s;
	float d2 = -uv.x * s + uv.y * c;
	// ===========================

	// ======= 可调节变量区 =======
	float lineSpacing = 0.5;    // 线条之间的间隔 (数值越小，线条越密)
	float thickness = 0.12;     // 线条的粗细
	float frequency = 100.0;     // 波浪的频率 (弯曲程度)
	float amplitude = 0.01;     // 波浪的振幅 (弯曲深度)
	// ===========================

	// 2. 实现多条线的核心逻辑：使用 fract 进行周期性重复
	// fract(d2 / lineSpacing) 会把坐标变成不断重复的 0 到 1
	// 减去 0.5 是为了让线条居于每个周期的中心
	float repeated_d2 = (fract(d2 / lineSpacing) - 0.5) * lineSpacing;

	// 3. 计算波浪偏移 (应用在重复后的坐标上)
	float wave = sin(d1 * frequency + t) * amplitude;

	// 4. 计算像素到波浪中心的距离
	float dist = abs(repeated_d2 - wave);

	// 5. 渲染线条掩码
	float line_mask = smoothstep(thickness, thickness - 0.01, dist);

	// 6. 颜色混合
	vec3 lightBlue = vec3(187.0/255.0, 68.0/255.0, 255.0/255.0); 
	vec3 darkBlue  = vec3(177.0/255.0, 64.0/255.0, 242.0/255.0); 

	vec3 finalColor = mix(darkBlue, lightBlue, line_mask);

	gl_FragColor = vec4(finalColor, 1.0);
}


