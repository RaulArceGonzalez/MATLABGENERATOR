% This function generates the MaxPool filter of the first layer
function [] = VOTLayer2MaxPool(activations)
name = sprintf('CNN_Network/CNN/VOT_MAXPOOL_Layer2.vhd');
fid = fopen(name, 'wt');
fprintf(fid, 'library IEEE;\n');
fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n\n');
if(activations == 1)
    fprintf(fid, 'entity VOT_MAXPOOL_LAYER2 is\n');
    fprintf(fid, '    Port (\n');
    for x = 1 : 3
        fprintf(fid, '  data_out_%d : in std_logic_vector(input_sizeL1  - 1 downto 0);\n',x);
    end
    fprintf(fid, '      data_out_v : out std_logic_vector(input_sizeL1  - 1 downto 0));\n');
    fprintf(fid, 'end VOT_MAXPOOL_LAYER2;\n\n');   
    fprintf(fid, 'architecture Behavioral of VOT_MAXPOOL_LAYER2 is\n');    
else
    fprintf(fid, 'entity VOT_MAXPOOL_LAYER2 is\n');
    fprintf(fid, '    Port (\n');
    for x = 1 : 3
        fprintf(fid, '      data_out_%d : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));\n',x);
    end
    fprintf(fid, '      data_out_v : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));\n');
    fprintf(fid, 'end VOT_MAXPOOL_LAYER2;\n\n');   
    fprintf(fid, 'architecture Behavioral of VOT_MAXPOOL_LAYER2 is\n');    
end
fprintf(fid, 'begin\n');
    fprintf(fid, 'data_out_v <= (data_out_1 and data_out_2) or (data_out_1 and data_out_3) or (data_out_2 and data_out_3);\n');
fprintf(fid, 'end Behavioral;\n');
fclose(fid);
end