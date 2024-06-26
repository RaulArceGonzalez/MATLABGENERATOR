function VOTRegisterLast(number_of_layers_fc,number)
name = sprintf('CNN_Network/FC/VOT_Register_FCLast.vhd');
fileID = fopen(name, 'wt');
fprintf(fileID, 'library IEEE;\n');
fprintf(fileID, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fileID, 'use work.tfg_irene_package.ALL;\n');
fprintf(fileID, 'use IEEE.NUMERIC_STD.ALL;\n\n');
fprintf(fileID, 'entity VOT_Register_FCLast is\n');
fprintf(fileID, '    Port ( \n');
for b = 1 : 3
    fprintf(fileID,'\t\t start_threshold_%d : in std_logic;\n',b);
    fprintf(fileID,'\t\t data_out_%d : in vector_sm_signed(0 to number_of_outputs_L%dfc-1);\n',b, number_of_layers_fc);
end
fprintf(fileID,'\t\t start_threshold : out std_logic;\n');
fprintf(fileID,'\t\t data_out : out vector_sm_signed(0 to number_of_outputs_L%dfc-1));\n', number_of_layers_fc);
fprintf(fileID, '   end VOT_Register_FCLast;\n\n');
fprintf(fileID, 'architecture Behavioral of VOT_Register_FCLast is\n');
fprintf(fileID, 'begin\n\n');
for v = 0 : (number-1)
         fprintf(fileID, 'data_out(%d) <= (data_out_1(%d) and data_out_2(%d)) or (data_out_1(%d) and data_out_3(%d)) or (data_out_2(%d) and data_out_3(%d));\n',v,v,v,v,v,v,v);
end
        fprintf(fileID, 'start_threshold <= (start_threshold_1 and start_threshold_2) or (start_threshold_1 and start_threshold_3) or (start_threshold_2 and start_threshold_3);\n');
fprintf(fileID, 'end Behavioral;\n');
fclose(fileID);
end