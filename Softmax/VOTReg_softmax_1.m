function VOTReg_softmax_1(layers_fc,number)

    name = sprintf('CNN_Network/Softmax/VOT_Reg_softmax_1.vhd');
    fid = fopen(name, 'wt');
    fprintf(fid, 'library IEEE;\n');
    fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
    fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
    fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
    fprintf(fid, 'use IEEE.MATH_REAL.ALL;\n');
    fprintf(fid, '\n');
    fprintf(fid, 'entity VOT_Reg_softmax_1 is\n');
    fprintf(fid, ' Port ( \n');
    for b = 1 : 3
        fprintf(fid, '       data_out_%d : in vector_sm(number_of_outputs_L%dfc - 1 downto 0);\n',b, layers_fc);
    end
    fprintf(fid, '       data_out_v : out vector_sm(number_of_outputs_L%dfc - 1 downto 0));\n', layers_fc);
    fprintf(fid, 'end VOT_Reg_softmax_1;\n');
    fprintf(fid, '\n');
    fprintf(fid, 'architecture Behavioral of VOT_Reg_softmax_1 is\n');
    fprintf(fid, '    begin\n');
    for v = 0 : (number-1)
            fprintf(fid, 'data_out_v(%d) <= (data_out_1(%d) and data_out_2(%d)) or (data_out_1(%d) and data_out_3(%d)) or (data_out_2(%d) and data_out_3(%d));\n',v,v,v,v,v,v,v);
    end
    fprintf(fid, 'end Behavioral;\n');
    
    fclose(fid);
end