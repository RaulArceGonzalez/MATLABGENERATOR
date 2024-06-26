function VOTsigmoidFC(layer,input_size, n_integer, n_decimal)
    name = sprintf('CNN_Network/FC/VOT_sigmoidFCL%d.vhd', layer);
    fid = fopen(name, 'wt');
    fprintf(fid, 'library IEEE;\n');
    fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
    fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
    fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
    fprintf(fid, 'use IEEE.MATH_REAL.ALL;\n');
    fprintf(fid, '\n');
    fprintf(fid, 'entity VOT_sigmoidFCL%d is\n', layer);
    fprintf(fid, '\tPort ( \n'); 
    for b = 1 : 3
            fprintf(fid, '\t\t data_out_%d : in std_logic_vector(input_size_L%dfc-1 downto 0);\n',b, layer);
    end
        fprintf(fid, '\t\tdata_out_v : out std_logic_vector(input_size_L%dfc-1 downto 0));\n', layer);
    fprintf(fid, 'end VOT_sigmoidFCL%d;\n', layer);
    fprintf(fid, '\n');
    fprintf(fid, 'architecture Behavioral of VOT_sigmoidFCL%d is\n', layer);
    fprintf(fid, '\n');
    fprintf(fid, 'Begin\n');
            fprintf(fid, 'data_out_v <= (data_out_1 and data_out_2) or (data_out_1 and data_out_3) or (data_out_2 and data_out_3);\n');
    fprintf(fid, 'end Behavioral;\n\n');   
    fclose(fid);
end