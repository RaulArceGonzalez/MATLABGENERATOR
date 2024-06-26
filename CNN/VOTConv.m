% This function generates the convolutional filters
% INPUTS
% Number of data to be computed by the neuron (x and y dimension)
% Parameters of each neurons, stored in a LUT
% Number of layer of the network
% Number of neuron of the layer
% Bias term fo each neuron
% Number of decimal bits of the weight
% Number of the integer bits of the weight
% Number of decimal bits of the activation
% Number of the integer bits of the activation
% Number of extra bits for the convolution operation
% Z dimension of each filter

function [] = VOTConv(mul, weights, layer, num, bias_term, n_decimal_w, n_integer_w, n_integer_act, n_decimales_act,n_extra_bits, conv_z)
        %This line has to be commented if all the input data are positive
        %bias_term = bias_term + sum(pesos, 'all')*(2^(n_enteros+n_decimales + 1));
        name = sprintf('CNN_Network/CNN/VOT_CONV%d%d.vhd', layer,num);
        fid = fopen(name, 'wt');fprintf(fid, 'library IEEE;\n');
        fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
        fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
        fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
        fprintf(fid, 'use IEEE.MATH_REAL.ALL;\n');
        fprintf(fid, 'entity VOT_CONV%d%d is\n', layer, num);
        fprintf(fid, '\t Port (\n');
        if(layer == 1)
            for x = 1 : 3
                fprintf(fid,' \t\t    weight_out_%d : in signed(weight_sizeL%d - 1 downto 0); \n',x, layer);
            end 
            fprintf(fid,' \t\t    weight_out_v : out signed(weight_sizeL%d - 1 downto 0); \n', layer);
        end
        for o = 1 : 3
            fprintf(fid, '\t\t    data_out_%d : in std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0);\n',o, layer, layer);
        end
        fprintf(fid, '\t\t    data_out_v : out std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0));\n', layer, layer);
        fprintf(fid, 'end VOT_CONV%d%d; \n', layer, num);
        fprintf(fid, 'architecture Behavioral of VOT_CONV%d%d is\n', layer, num);
        fprintf(fid, 'begin\n');
        if(layer == 1)
            fprintf(fid, 'weight_out_v <= (weight_out_1 and weight_out_2) or (weight_out_1 and weight_out_3) or (weight_out_2 and weight_out_3);\n');
        end
        fprintf(fid, 'data_out_v <= (data_out_1 and data_out_2) or (data_out_1 and data_out_3) or (data_out_2 and data_out_3);\n');
        fprintf(fid, 'end Behavioral;\n\n');   
        fclose(fid);
           
end