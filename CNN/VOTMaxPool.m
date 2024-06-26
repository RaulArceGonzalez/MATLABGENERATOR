% This function generates the MaxPool filter module
function [] =  VOTMaxPool(activations, layer)
name = sprintf('CNN_Network/CNN/VOT_MAXPOOL_L%d.vhd', layer);
fid = fopen(name, 'wt');
fprintf(fid, 'library IEEE;\n');
fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n\n');
fprintf(fid, '--library UNISIM;\n');
fprintf(fid, '--use UNISIM.VComponents.all;\n');
if(activations == 1)
    fprintf(fid, 'entity VOT_MAXPOOL_L%d is\n', layer);
    fprintf(fid, ' generic (\n');
    fprintf(fid, ' input_size : integer := 8; \n');
    fprintf(fid, ' weight_size : integer := 8);\n');
    fprintf(fid, 'Port (\n');
    for x = 1: 3
            fprintf(fid, '      data_out_%d : in STD_LOGIC_VECTOR(input_size - 1 downto 0);\n',x);
    end
        fprintf(fid, '      data_out_v : out STD_LOGIC_VECTOR(input_size - 1 downto 0));\n');
    fprintf(fid, 'end VOT_MAXPOOL_L%d;\n\n', layer);
    fprintf(fid, 'architecture Behavioral of VOT_MAXPOOL_L%d is\n', layer);
else
    fprintf(fid, 'entity VOT_MAXPOOL_L%d is\n', layer);
    fprintf(fid, ' generic (\n');
    fprintf(fid, ' input_size : integer := 8; \n');
    fprintf(fid, ' weight_size : integer := 8);\n');
    fprintf(fid, 'Port (\n');
    for x = 1: 3
            fprintf(fid, 'data_out_%d : in STD_LOGIC_VECTOR(input_size + weight_size + n_extra_bits - 1 downto 0);\n',x);
    end
    fprintf(fid, 'data_out_v : out STD_LOGIC_VECTOR(input_size + weight_size + n_extra_bits - 1 downto 0));\n');
    fprintf(fid, 'end VOT_MAXPOOL_L%d;\n\n', layer);
    fprintf(fid, 'architecture Behavioral of VOT_MAXPOOL_L%d is\n', layer);
end
fprintf(fid, 'begin\n');
    fprintf(fid, 'data_out_v <= (data_out_1 and data_out_2) or (data_out_1 and data_out_3) or (data_out_2 and data_out_3);\n');
fprintf(fid, 'end Behavioral;\n');
fclose(fid);
end