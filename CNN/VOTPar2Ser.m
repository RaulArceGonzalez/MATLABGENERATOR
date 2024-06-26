% This function generates the module for the parallel to serial conversion
% with time control
function [] = VOTPar2Ser()
name = sprintf('CNN_Network/CNN/VOT_PAR2SER.vhd');
fileID = fopen(name, 'wt');
fprintf(fileID, 'library IEEE;\n');
fprintf(fileID, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fileID, 'use work.tfg_irene_package.ALL;\n');
fprintf(fileID, 'use IEEE.NUMERIC_STD.ALL;\n');
fprintf(fileID, 'entity VOT_PAR2SER is\n');
fprintf(fileID, 'Port ( \n');
        for a = 1 : 3
        fprintf(fid, '\t\t serial_out_%d : in STD_LOGIC;\n',a);
        end
        fprintf(fid, '\t\t serial_out_v : out STD_LOGIC);\n');
 fprintf(fileID, 'end VOT_PAR2SER; \n');
fprintf(fileID, 'architecture Behavioral of VOT_PAR2SER is\n');
fprintf(fileID, 'begin \n\n');
    fprintf(fid, 'serial_out_v <= (serial_out_1 and serial_out_2) or (serial_out_1 and serial_out_3) or (serial_out_2 and serial_out_3);\n');
fprintf(fileID, 'end Behavioral;\n');
fclose(fid);           
end