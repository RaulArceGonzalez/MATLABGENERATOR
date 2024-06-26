function VOTReg_softmax_2(layers_fc)

    name = sprintf('CNN_Network/Softmax/VOT_Reg_softmax_2.vhd');
    fid = fopen(name, 'wt');
    fprintf(fid, 'library IEEE;\n');
    fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
    fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
    fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
    fprintf(fid, 'use IEEE.MATH_REAL.ALL;\n');
    fprintf(fid, '\n');
    fprintf(fid, 'entity VOT_Reg_softmax_2 is\n');
    fprintf(fid, ' Port ( \n');
    for b = 1 : 3
        fprintf(fid, '       data_out_%d : in std_logic_vector(input_size_L%dfc - 1 downto 0); \n',b, layers_fc);
    end
    fprintf(fid, '       data_out_v : out std_logic_vector(input_size_L%dfc - 1 downto 0));\n', layers_fc);
    fprintf(fid, 'end VOT_Reg_softmax_2;\n');
    fprintf(fid, '\n');
    fprintf(fid, 'architecture Behavioral of VOT_Reg_softmax_2 is\n');
    fprintf(fid, '    begin\n');
            fprintf(fid, 'data_out_v <= (data_out_1 and data_out_2) or (data_out_1 and data_out_3) or (data_out_2 and data_out_3);\n');
    fprintf(fid, 'end Behavioral;\n');
    
    fclose(fid);
end