function VOTRegisterFC(layer,layers_fc, number)
name = sprintf('CNN_Network/FC/VOT_Register_FCL%d.vhd', layer);
fid = fopen(name, 'wt');
fprintf(fid, 'library IEEE;\n');
fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
fprintf(fid, '\n');
fprintf(fid, 'entity VOT_Register_FCL%d is\n', layer);
fprintf(fid, '    Port (  \n');
for b = 1 : 3
        fprintf(fid, '       data_out_%d : in vector_L%dfc_activations(0 to number_of_inputs_L%dfc-1);\n',b, layer, layer+1);
end
    fprintf(fid, '       data_out_v : out vector_L%dfc_activations(0 to number_of_inputs_L%dfc-1));\n', layer, layer+1);
fprintf(fid, 'end VOT_Register_FCL%d;\n', layer);
fprintf(fid, '\n');
fprintf(fid, 'architecture Behavioral of VOT_Register_FCL%d is\n', layer);
fprintf(fid, '\n');
fprintf(fid, 'begin\n');
fprintf(fid, '\n');
for v = 0 : (number(layer)-1)
            fprintf(fid, 'data_out_v(%d) <= (data_out_1(%d) and data_out_2(%d)) or (data_out_1(%d) and data_out_3(%d)) or (data_out_2(%d) and data_out_3(%d));\n',v,v,v,v,v,v,v);
end
fprintf(fid, 'end Behavioral;\n');   
fclose(fid);
end
