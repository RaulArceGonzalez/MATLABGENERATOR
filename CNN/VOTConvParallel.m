% This function generates the parallel convolutional filters
% INPUTS
% Number of layer of the network
% Number of neuron of the layer
% Bias term fo each neuron
% Number of decimal bits of the weight
% Number of the integer bits of the weight
% Number of decimal bits of the weight
% Number of the integer bits of the weight
% Number of extra bits for the convolution operation
function [] = VOTConvParallel( layer, num, bias_term, n_decimal_w, n_integer_w, n_integer_act, n_decimales_act, n_extra_bits)
        name = sprintf('CNN_Network/CNN/VOT_CONVP%d%d.vhd', layer,num);
        fid = fopen(name, 'wt');
        fprintf(fid, 'library IEEE;\n');
        fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
        fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
        fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
        fprintf(fid, 'entity VOT_CONVP%d%d is\n', layer, num);
        fprintf(fid, '\t Port ( \n');
        for x = 1 : 3
            fprintf(fid, '	     data_out_%d : in std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0);\n',x,layer,layer);
        end
        fprintf(fid, '	     data_out_v : out std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0));\n',layer,layer);
        fprintf(fid, 'end VOT_CONVP%d%d; \n', layer, num);
        fprintf(fid, 'architecture Behavioral of VOT_CONVP%d%d is\n', layer, num);
        fprintf(fid, 'begin\n');
        fprintf(fid, 'data_out_v <= (data_out_1 and data_out_2) or (data_out_1 and data_out_3) or (data_out_2 and data_out_3);\n');
        fprintf(fid, 'end Behavioral;\n\n');   
        fclose(fid);
           
end