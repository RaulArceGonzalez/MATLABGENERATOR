% This function generates the module for the control signal generator of
% the last layer of the CNN part of the network
% INPUTS
% Number of layer of the generator
% Number of layers of the convolutional filters (z dimension)
function [] = VOTControlLastLayer(layers, conv_z)
 name = sprintf('CNN_Network/CNN/VOT_GEN%d.vhd', layers);
        fid = fopen(name, 'wt');
        fprintf(fid, 'library IEEE;\n');
        fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
        fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
        fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
        fprintf(fid, 'entity VOT_GEN%d is\n', layers);
        fprintf(fid, '\t Port ( \n');
        for l = 1 : 3
        fprintf(fid, '\t\t dato_new_%d : in std_logic;\n',l);
        fprintf(fid,' \t\t layer_%d : in std_logic_vector(log2c(number_of_layers%d) - 1 downto 0);\n',l, layers);
        fprintf(fid, '\t\t index_%d : in std_logic;\n',l);
        fprintf(fid, '\t\t next_dato_pool_%d : in std_logic;\n',l);
        end
        fprintf(fid, '\t\t dato_new_v : out std_logic;\n');
        fprintf(fid,' \t\t layer_v : out std_logic_vector(log2c(number_of_layers%d) - 1 downto 0);\n', layers);
        fprintf(fid, '\t\t index_v : out std_logic;\n');
        fprintf(fid, '\t\t next_dato_pool_v : out std_logic);\n');
        fprintf(fid, 'end VOT_GEN%d; \n', layers);
        fprintf(fid, 'architecture Behavioral of VOT_GEN%d is\n', layers);
        fprintf(fid,'begin\n');

        fprintf(fid, 'next_dato_pool_v <= (next_dato_pool_1 and next_dato_pool_2) or (next_dato_pool_1 and next_dato_pool_3) or (next_dato_pool_2 and next_dato_pool_3);\n');
        fprintf(fid, 'dato_new_v <= (dato_new_1 and dato_new_2) or (dato_new_1 and dato_new_3) or (dato_new_2 and dato_new_3);\n');
        fprintf(fid, 'index_v <= (index_1 and index_2) or (index_1 and index_3) or (index_2 and index_3);\n');
        fprintf(fid, 'layer_v <= (layer_1 and layer_2) or (layer_1 and layer_3) or (layer_2 and layer_3);\n');

        fprintf(fid, 'end Behavioral;\n');
        fclose(fid);
           
end