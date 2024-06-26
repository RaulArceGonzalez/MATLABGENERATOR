function VOTThreshold(layers_fc)
file_name = 'CNN_Network/Softmax/VOT_threshold.vhd';
fid = fopen(file_name, 'w');
fprintf(fid, 'library IEEE;\n');
fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid,'use IEEE.NUMERIC_STD.ALL;\n\n');
fprintf(fid, '\n');
fprintf(fid, 'entity VOT_threshold is\n');
fprintf(fid, '    Port (\n');
for b = 1 : 3 
    fprintf(fid,'\t      y_out_%d : in unsigned(log2c(number_of_outputs_L%dfc) -1 downto 0);\n',b, layers_fc);
    fprintf(fid,'\t      finish_%d : in std_logic;\n',b);
end
fprintf(fid,'\t      y_out : out unsigned(log2c(number_of_outputs_L%dfc) -1 downto 0);\n', layers_fc);
fprintf(fid,'\t      finish : out std_logic);\n');
fprintf(fid, 'end VOT_threshold;\n');
fprintf(fid, '\n');
fprintf(fid, 'architecture Behavioral of VOT_threshold is\n');
fprintf(fid, 'begin\n');
        fprintf(fid, 'y_out <= (y_out_1 and y_out_2) or (y_out_1 and y_out_3) or (y_out_2 and y_out_3);\n');
        fprintf(fid, 'finish <= (finish_1 and finish_2) or (finish_1 and finish_3) or (finish_2 and finish_3);\n');
fprintf(fid, 'end Behavioral;\n');
fclose(fid);
end