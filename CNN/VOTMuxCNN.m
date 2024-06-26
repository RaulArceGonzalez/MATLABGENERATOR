% This function generates the multiplexers of the CNN network
% INPUTS
% Number of layer of the network
% Z dimension of the previous layer 
function [] = VOTMuxCNN(num,number_of_layers)
    name = sprintf('CNN_Network/CNN/VOT_MUX_%d.vhd',num);
    fid = fopen(name, 'wt'); 
    fprintf(fid, 'library IEEE;\n');
    fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
    fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
    fprintf(fid, 'use work.tfg_irene_package.all;\n\n');
    fprintf(fid, 'entity  VOT_MUX_%d is\n', num);
    fprintf(fid, '\tPort( \n');
    for d = 1 : 3
        fprintf(fid, '\t\t data_out_%d : in std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits -1  downto 0); \n', d ,num - 1, num - 1);
    end
        fprintf(fid, '\t\t data_out_v : out std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits -1  downto 0));\n', num - 1, num - 1);
    fprintf(fid, 'end VOT_MUX_%d; \n', num);
    fprintf(fid, 'architecture Behavioral of VOT_MUX_%d is\n', num');
    fprintf(fid, 'begin\n');
    fprintf(fid, 'data_out_v <= (data_out_1 and data_out_2) or (data_out_1 and data_out_3) or (data_out_2 and data_out_3);\n');
    fprintf(fid, 'end Behavioral;\n\n');        
    fclose(fid);
end