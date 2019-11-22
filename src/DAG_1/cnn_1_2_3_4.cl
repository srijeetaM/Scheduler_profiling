__kernel void cnn_1_2_3_4( __global const float* b0, __global const float* b1, __global const float* b2, __global const float* b5, __global const float* b6, __global const float* b9, __global const float* b11, __global const float* b13, __global float* b3, __global float* b4, __global float* b7, __global float* b8, __global float* b10, __global float* b12, __global float* b14)
{
	int globalId = get_global_id(0);

	typedef float3 floatC;
	floatC data0_C,data1_C;
	int localId_C, w2 , h2, outputRow_C, outputCol_C, image2dIdx_C, plane_C, n_C, stride, pad, inputRow_C, inputCol_C;
	float dots;

	if(globalId < 32*16*16)
	{
		w2 = 16;
		h2 = 16;

		localId_C = globalId%(w2*h2);
		outputRow_C = localId_C / w2;
		outputCol_C = localId_C % w2;

		image2dIdx_C = globalId / (h2*w2);
		plane_C = image2dIdx_C % 32;
		n_C = image2dIdx_C / 32;
		dots = 0.0;
		stride = 1;
		pad=1;
		inputRow_C = outputRow_C * stride - pad;
		inputCol_C = outputCol_C * stride - pad;

		if(localId_C <256)
		{
			for(int j=0;j<16;j++)
			{
				for(int i=0;i<3;i++)
				{
					data0_C.xyz = (float3)(115.0f,212.0f,76.0f);
					if(inputRow_C+i<0 || inputRow_C+i>=16)
						data0_C.xyz = (float3)(0.0f,0.0f,0.0f);
					else if(inputCol_C<0)
					{
						data0_C = vload3(0,(__global const float *)b0+(j*16*16)+(inputRow_C+i)*16+inputCol_C);
						data0_C.x = 0;
					}
					else if(inputCol_C+3-1>=16)
					{
						data0_C = vload3(0,(__global const float *)b0+(j*16*16)+(inputRow_C+i)*16+inputCol_C);
						data0_C.z = 0;
					}
					else
					{
						data0_C = vload3(0,(__global const float *)b0+(j*16*16)+(inputRow_C+i)*16+inputCol_C);
					}
					data1_C = vload3(0,(__global const float *)b1+(plane_C*3*3*16)+(j*3*3)+i*3);
					dots += dot(data0_C,data1_C);
				}
			}
			if(outputRow_C<16 && outputCol_C<16)
				b3[plane_C*16*16+outputRow_C*16+outputCol_C] = dots + b2[plane_C];
		}
		printf("");
	}

	barrier(CLK_LOCAL_MEM_FENCE | CLK_GLOBAL_MEM_FENCE);

	typedef float2 floatP;
	floatP data0_P,data1_P;

	int localId_P, outputRow_P, outputCol_P, image2dIdx_P, plane_P, n_P, pool_size, inputRow_P, inputCol_P, inputImageOffset, poolInputOffset;
	float maxValue;
	bool process;

	if(globalId < 32*8*8)
	{
		localId_P = globalId % (8*8);
		outputRow_P = localId_P / 8;
		outputCol_P = localId_P % 8;
		image2dIdx_P = globalId / (8*8);
		plane_P = image2dIdx_P % 32;
		n_P = image2dIdx_P / 32;
		if(n_P > 1) 
			return;
		
		pool_size = 2;
		inputRow_P = outputRow_P * pool_size;
		inputCol_P = outputCol_P * pool_size;
		inputImageOffset  = (n_P*32 + plane_P)*16*16;
		poolInputOffset = inputImageOffset + inputRow_P * 16 + inputCol_P;
		maxValue = b3[ poolInputOffset ];

		process = (inputRow_P + 1 < 16) && (inputCol_P + 1 < 16);

		if(process)
		{
			data0_P = vload2(0,(__global float *)b3+poolInputOffset);
			data1_P = vload2(0,(__global float *)b3+poolInputOffset+16);

			data0_P = fmax(data0_P,data1_P);
			maxValue = fmax(data0_P.s0,data0_P.s1);
		}

		if(outputRow_P<8 && outputCol_P<8)
			b4[globalId] = maxValue;

		printf("");
	}

	barrier(CLK_LOCAL_MEM_FENCE | CLK_GLOBAL_MEM_FENCE);

	if(globalId < 64*8*8)
	{
		w2 = 8;
		h2 = 8;

		localId_C = globalId%(w2*h2);
		outputRow_C = localId_C / w2;
		outputCol_C = localId_C % w2;

		image2dIdx_C = globalId / (h2*w2);
		plane_C = image2dIdx_C % 64;
		n_C = image2dIdx_C / 64;
		dots = 0.0;
		stride = 1;
		pad=1;
		inputRow_C = outputRow_C * stride - pad;
		inputCol_C = outputCol_C * stride - pad;

		if(localId_C <64)
		{
			for(int j=0;j<32;j++)
			{
				for(int i=0;i<3;i++)
				{
					data0_C.xyz = (float3)(115.0f,212.0f,76.0f);
					if(inputRow_C+i<0 || inputRow_C+i>=8)
						data0_C.xyz = (float3)(0.0f,0.0f,0.0f);
					else if(inputCol_C<0)
					{
						data0_C = vload3(0,(__global float *)b4+(j*8*8)+(inputRow_C+i)*8+inputCol_C);
						data0_C.x = 0;
					}
					else if(inputCol_C+3-1>=8)
					{
						data0_C = vload3(0,(__global float *)b4+(j*8*8)+(inputRow_C+i)*8+inputCol_C);
						data0_C.z = 0;
					}
					else
					{
						data0_C = vload3(0,(__global float *)b4+(j*8*8)+(inputRow_C+i)*8+inputCol_C);
					}
					data1_C = vload3(0,(__global const float *)b5+(plane_C*3*3*32)+(j*3*3)+i*3);
					dots += dot(data0_C,data1_C);
				}
			}
			if(outputRow_C<8 && outputCol_C<8)
				b7[plane_C*8*8+outputRow_C*8+outputCol_C] = dots + b6[plane_C];
		}
		printf("");
	}

	barrier(CLK_LOCAL_MEM_FENCE | CLK_GLOBAL_MEM_FENCE);

	if(globalId < 64*4*4)
	{
		localId_P = globalId % (4*4);
		outputRow_P = localId_P / 4;
		outputCol_P = localId_P % 4;
		image2dIdx_P = globalId / (4*4);
		plane_P = image2dIdx_P % 64;
		n_P = image2dIdx_P / 64;
		if(n_P > 1) 
			return;
		
		pool_size = 2;
		inputRow_P = outputRow_P * pool_size;
		inputCol_P = outputCol_P * pool_size;
		inputImageOffset  = (n_P*64 + plane_P)*8*8;
		poolInputOffset = inputImageOffset + inputRow_P * 8 + inputCol_P;
		maxValue = b7[ poolInputOffset ];

		process = (inputRow_P + 1 < 8) && (inputCol_P + 1 < 8);

		if(process)
		{
			data0_P = vload2(0,(__global float *)b7+poolInputOffset);
			data1_P = vload2(0,(__global float *)b7+poolInputOffset+8);

			data0_P = fmax(data0_P,data1_P);
			maxValue = fmax(data0_P.s0,data0_P.s1);
		}

		if(outputRow_P<4 && outputCol_P<4)
			b8[globalId] = maxValue;

		printf("");
	}

	barrier(CLK_LOCAL_MEM_FENCE | CLK_GLOBAL_MEM_FENCE);

	typedef float4 floatX;
	floatX wt,temp;
	float dotProduct;

	dotProduct=0.0;
	if(globalId < 512)
	{
		for(int x=0; x<1024/4; x++)
		{
			temp= vload4(0,(__global float *)b8+(4*x));
			wt= vload4(0,(__global const float *)b9+(globalId*1024+4*x));
			dotProduct += dot(wt,temp);
/*			dotProduct += wt.x*temp.x + wt.y*temp.y + wt.z*temp.z + wt.w*temp.w;*/
		}
		b10[globalId] = dotProduct;
		printf("");
	}


	barrier(CLK_LOCAL_MEM_FENCE | CLK_GLOBAL_MEM_FENCE);

	dotProduct=0.0;
	if(globalId < 128)
	{
		for(int x=0; x<512/4; x++)
		{
			temp= vload4(0,(__global float *)b10+(4*x));
			wt= vload4(0,(__global const float *)b11+(globalId*512+4*x));
			dotProduct += dot(wt,temp);
/*			dotProduct += wt.x*temp.x + wt.y*temp.y + wt.z*temp.z + wt.w*temp.w;*/
		}
		b12[globalId] = dotProduct;
		printf("");
	}


	barrier(CLK_LOCAL_MEM_FENCE | CLK_GLOBAL_MEM_FENCE);

	dotProduct=0.0;
	if(globalId < 16)
	{
		for(int x=0; x<128/4; x++)
		{
			temp= vload4(0,(__global float *)b12+(4*x));
			wt= vload4(0,(__global const float *)b13+(globalId*128+4*x));
			dotProduct += dot(wt,temp);
/*			dotProduct += wt.x*temp.x + wt.y*temp.y + wt.z*temp.z + wt.w*temp.w;*/
		}
		b14[globalId] = dotProduct;
		printf("");
	}

}