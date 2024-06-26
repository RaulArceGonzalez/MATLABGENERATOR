function VOTexponential(layers_fc,input_size, n_integer, n_decimal, n_integer_act, n_decimal_act)
    name = sprintf('CNN_Network/Softmax/VOT_exponential.vhd');
    fid = fopen(name, 'wt');
    fprintf(fid, 'library IEEE;\n');
    fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
    fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
    fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
    fprintf(fid, 'use IEEE.MATH_REAL.ALL;\n');
    fprintf(fid, '\n');
    fprintf(fid, 'entity VOT_exponential is\n');
    fprintf(fid, '\t Port ( \n'); 
    for b = 1 : 3
    fprintf(fid, '        data_out_%d : in std_logic_vector (input_size_L%dfc-1 downto 0);\n', b, layers_fc);
    end
    fprintf(fid, '        data_out_v : out std_logic_vector (input_size_L%dfc-1 downto 0));\n', layers_fc);
    fprintf(fid, 'end VOT_exponential;\n');
    fprintf(fid, '\n');
    fprintf(fid, 'architecture Behavioral of VOT_exponential is\n');
    fprintf(fid, '\n');
    fprintf(fid, 'Begin\n');
            fprintf(fid, 'data_out_V <= (data_out_1 and data_out_2) or (data_out_1 and data_out_3) or (data_out_2 and data_out_3);\n');
    fprintf(fid, 'end Behavioral;\n\n');   
    fclose(fid);
end