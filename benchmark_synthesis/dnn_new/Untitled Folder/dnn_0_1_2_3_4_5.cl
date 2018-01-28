#define v0 1024
#define v1 4096
#define v2 4096
#define v3 4096
#define v4 4096
#define v5 2048
#define v6 2048
#define v7 1024
#define v8 1024
#define v9 512
#define v10 512
#define v11 16

__kernel void dnn_0_1_2_3_4_5( __global const float* b0, __global const float* b1, __global const float* b2, __global const float* b3, __global const float* b4, __global const float* b5, __global const float* b6, __global const float* b7, __global const float* b8, __global const float* b9, __global const float* b10, __global const float* b11, __global const float* b12, __global float* b13, __global float* b14, __global float* b15, __global float* b16, __global float* b17, __global float* b18)
{
	int globalId = get_global_id(0);

	typedef float4 floatX;
	floatX wt,temp;
	float dotProduct;


	dotProduct=0.0;
	if(globalId < v0)
	{
		for(int x=0; x<v1/4; x++)
		{
			temp= vload4(0,(__global const float *)b0+(4*x));
			wt= vload4(0,(__global const float *)b1+(globalId*v1+4*x));
			dotProduct += dot(wt,temp);
		}
		b13[globalId] = dotProduct+b2[globalId];
	}

	barrier(CLK_LOCAL_MEM_FENCE | CLK_GLOBAL_MEM_FENCE);

	dotProduct=0.0;
	if(globalId < v2)
	{
		for(int x=0; x<v3/4; x++)
		{
			temp= vload4(0,(__global const float *)b13+(4*x));
			wt= vload4(0,(__global const float *)b3+(globalId*v3+4*x));
			dotProduct += dot(wt,temp);
		}
		b14[globalId] = dotProduct+b4[globalId];
	}

	barrier(CLK_LOCAL_MEM_FENCE | CLK_GLOBAL_MEM_FENCE);

	dotProduct=0.0;
	if(globalId < v4)
	{
		for(int x=0; x<v5/4; x++)
		{
			temp= vload4(0,(__global const float *)b14+(4*x));
			wt= vload4(0,(__global const float *)b5+(globalId*v5+4*x));
			dotProduct += dot(wt,temp);
		}
		b15[globalId] = dotProduct+b6[globalId];
	}

	barrier(CLK_LOCAL_MEM_FENCE | CLK_GLOBAL_MEM_FENCE);

	dotProduct=0.0;
	if(globalId < v6)
	{
		for(int x=0; x<v7/4; x++)
		{
			temp= vload4(0,(__global const float *)b15+(4*x));
			wt= vload4(0,(__global const float *)b7+(globalId*v7+4*x));
			dotProduct += dot(wt,temp);
		}
		b16[globalId] = dotProduct+b8[globalId];
	}

	barrier(CLK_LOCAL_MEM_FENCE | CLK_GLOBAL_MEM_FENCE);

	dotProduct=0.0;
	if(globalId < v8)
	{
		for(int x=0; x<v9/4; x++)
		{
			temp= vload4(0,(__global const float *)b16+(4*x));
			wt= vload4(0,(__global const float *)b9+(globalId*v9+4*x));
			dotProduct += dot(wt,temp);
		}
		b17[globalId] = dotProduct+b10[globalId];
	}

	barrier(CLK_LOCAL_MEM_FENCE | CLK_GLOBAL_MEM_FENCE);

	dotProduct=0.0;
	if(globalId < v10)
	{
		for(int x=0; x<v11/4; x++)
		{
			temp= vload4(0,(__global const float *)b17+(4*x));
			wt= vload4(0,(__global const float *)b11+(globalId*v11+4*x));
			dotProduct += dot(wt,temp);
		}
		b18[globalId] = dotProduct+b12[globalId];
	}

}