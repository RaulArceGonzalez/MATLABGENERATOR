% This function generates the module for the control signal generator of each layer of the CNN part of the network
% INPUTS
% Number of layer of the generator
% Number of data to be processed by the convolutional filters
% Number of bits of the input data of the layer
% Number of layers of the convolutional filters (z dimension)
function [] = VOTLayerControl(layer, mult, input_size, conv_z)
        name = sprintf('CNN_Network/CNN/VOT_GEN%d.vhd', layer);
        fid = fopen(name, 'wt');
        fprintf(fid, 'library IEEE;\n');
        fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
        fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
        fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
        fprintf(fid, 'entity VOT_GEN%d is\n', layer);
        fprintf(fid,' Port ( \n');
        for h=1 : 3
        fprintf(fid, '\t\t layer_%d : in std_logic_vector(log2c(number_of_layers%d) - 1 downto 0);\n',h , layer);
        fprintf(fid, '\t\t count_%d : in unsigned( log2c(input_sizeL%d)-1 downto 0);\n',h, layer);
        fprintf(fid, '\t\t mul_%d: in std_logic_vector(log2c(mult%d) - 1 downto 0);\n',h, layer);
        fprintf(fid, '\t\t dato_out1_%d: in std_logic; \n',h);
        fprintf(fid, '\t\t dato_out2_%d : in std_logic;\n',h);
        fprintf(fid, '\t\t index_%d : in std_logic;\n',h);
        fprintf(fid, '\t\t en_neurona_%d : in std_logic;\n',h);
        fprintf(fid, '\t\t next_dato_pool_%d : in std_logic;\n',h);
        fprintf(fid, '\t\t next_pipeline_step_%d : in std_logic;\n',h);
        end
        fprintf(fid, '\t\t layer_v : out std_logic_vector(log2c(number_of_layers%d) - 1 downto 0);\n', layer);
        fprintf(fid, '\t\t count_v : out unsigned( log2c(input_sizeL%d)-1 downto 0);\n', layer);
        fprintf(fid, '\t\t mul_v: out std_logic_vector(log2c(mult%d) - 1 downto 0);\n', layer);
        fprintf(fid, '\t\t dato_out1_v: out std_logic; \n');
        fprintf(fid, '\t\t dato_out2_v : out std_logic;\n');
        fprintf(fid, '\t\t index_v : out std_logic;\n');
        fprintf(fid, '\t\t en_neurona_v : out std_logic;\n');
        fprintf(fid, '\t\t next_dato_pool_v : out std_logic;\n');
        fprintf(fid, '\t\t next_pipeline_step_v : out std_logic);\n');
        fprintf(fid, 'end VOT_GEN%d; \n', layer);
        fprintf(fid, 'architecture Behavioral of VOT_GEN%d is\n', layer);
        fprintf(fid, 'begin\n\n');
        fprintf(fid, 'next_dato_pool_v <= (next_dato_pool_1 and next_dato_pool_2) or (next_dato_pool_1 and next_dato_pool_3) or (next_dato_pool_2 and next_dato_pool_3);\n');
        fprintf(fid, 'next_pipeline_step_v <= (next_pipeline_step_1 and next_pipeline_step_2) or (next_pipeline_step_1 and next_pipeline_step_3) or (next_pipeline_step_2 and next_pipeline_step_3);\n');
        fprintf(fid, 'dato_out2_v <= (dato_out2_1 and dato_out2_2) or (dato_out2_1 and dato_out2_3) or (dato_out2_2 and dato_out2_3);\n');
        fprintf(fid, 'dato_out1_v <= (dato_out1_1 and dato_out1_2) or (dato_out1_1 and dato_out1_3) or (dato_out1_2 and dato_out1_3);\n');
        fprintf(fid, 'en_neurona_v <= (en_neurona_1 and en_neurona_2) or (en_neurona_1 and en_neurona_3) or (en_neurona_2 and en_neurona_3);\n');
        fprintf(fid, 'count_v <= (count_1 and count_2) or (count_1 and count_3) or (count_2 and count_3);\n');
        fprintf(fid, 'mul_v <= (mul_1 and mul_2) or (mul_1 and mul_3) or (mul_2 and mul_3);\n');
        fprintf(fid, 'index_v <= (index_1 and index_2) or (index_1 and index_3) or (index_2 and index_3);\n');
        fprintf(fid, 'layer_v <= (layer_1 and layer_2) or (layer_1 and layer_3) or (layer_2 and layer_3);\n');
        fprintf(fid, 'end Behavioral;\n');
        fclose(fid);
end