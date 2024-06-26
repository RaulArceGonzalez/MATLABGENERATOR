function VOTMuxFC(layer, layers_fc)
name = sprintf('CNN_Network/FC/VOT_Mux_FCL%d.vhd', layer);
fid = fopen(name, 'wt');
fprintf(fid, 'library IEEE;\n');
fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n\n');
fprintf(fid, 'entity VOT_Mux_FCL%d is\n', layer);
fprintf(fid, '    Port ( \n' );
for b = 1 : 3
        fprintf(fid, '       data_out_%d : in std_logic_vector(input_size_L%dfc-1 downto 0);\n',b,  layer +1);
end
    fprintf(fid, '       data_out_v : out std_logic_vector(input_size_L%dfc-1 downto 0));\n',  layer +1);
fprintf(fid, 'end VOT_Mux_FCL%d;\n', layer);
fprintf(fid, 'architecture Behavioral of VOT_Mux_FCL%d is\n\n', layer);
fprintf(fid, 'begin\n\n');
        fprintf(fid, 'data_out_v <= (data_out_1 and data_out_2) or (data_out_1 and data_out_3) or (data_out_2 and data_out_3);\n');
fprintf(fid, '\n end Behavioral;');
fclose(fid);
end