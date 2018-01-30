__kernel void cnn_2( __global const float* b0, __global const float* b1, __global const float* b2, __global float* b3)
{
	int globalId = get_global_id(0);

	typedef float4 floatC;
	floatC data0_C,data1_C;
	int localId_C, w2 , h2, outputRow_C, outputCol_C, image2dIdx_C, plane_C, n_C, stride, pad, inputRow_C, inputCol_C;
	float dots;

	if(globalId < 32*8*8)
	{
		w2 = 8;
		h2 = 8;

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

			for(int j=0;j<16;j++)
			{
				for(int i=0;i<3;i++)
				{
					if(inputRow_C+i<0 || inputRow_C+i>=8)
						data0_C.xyz = (float3)(0.0f,0.0f,0.0f);
					else if(inputCol_C<0)
					{
						if(inputRow_C+i==0 && j==0)
						{
							data0_C.y = b0[0];
							data0_C.z = b0[1];
						}
						else
							data0_C.xyz = vload3(0,(__global const float *)b0+(j*8*8)+(inputRow_C+i)*8+inputCol_C);
						data0_C.x = 0;
					}
					else if(inputCol_C+3-1>=8)
					{
						if(inputRow_C+i==8 && j==2)
						{
							data0_C.x = b0[(j*8*8)+(inputRow_C+i)*8+2];
							data0_C.y = b0[(j*8*8)+(inputRow_C+i)*8+3];
						}
						else
						data0_C.xyz = vload3(0,(__global const float *)b0+(j*8*8)+(inputRow_C+i)*8+inputCol_C);
						data0_C.z = 0;
					}
					else
					{
						data0_C.xyz = vload3(0,(__global const float *)b0+(j*8*8)+(inputRow_C+i)*8+inputCol_C);
					}
					data0_C.w = 0.0;
					data1_C.xyz = vload3(0,(__global const float *)b1+(plane_C*3*3*16)+(j*3*3)+i*3);
					dots += dot(data0_C,data1_C);
				}
			}
			if(outputRow_C<8 && outputCol_C<8)
				b3[plane_C*8*8+outputRow_C*8+outputCol_C] = dots + b2[plane_C];
		}

}