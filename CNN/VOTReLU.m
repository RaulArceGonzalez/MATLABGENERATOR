% This function generates the module for the ReLU activation function
% INPUTS
% Number of the layer where the ReLU is located in each case
function [] = VOTReLU(layer, relu_act)
name = sprintf('CNN_Network/CNN/VOT_RELUL%d.vhd', layer);
fid = fopen(name, 'wt');
fprintf(fid, 'library IEEE;\n');
fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
fprintf(fid, 'entity VOT_RELUL%d is\n', layer);
fprintf(fid, '\t Port (\n');
for x = 1 : 3
        fprintf(fid, '\t\t    data_out_%d : in std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0);\n',x, layer, layer);
end
    fprintf(fid, '\t\t    data_out_v : out std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0));\n', layer, layer);
fprintf(fid, 'end VOT_RELUL%d;\n', layer);
fprintf(fid, 'architecture Behavioral of VOT_RELUL%d is\n', layer);
fprintf(fid, 'begin\n');
    fprintf(fid, 'data_out_v <= (data_out_1 and data_out_2) or (data_out_1 and data_out_3) or (data_out_2 and data_out_3);\n');
fprintf(fid, 'end Behavioral;\n');
fclose(fid);
end