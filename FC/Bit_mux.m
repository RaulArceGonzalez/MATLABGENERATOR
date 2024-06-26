% This function generates the module for the parallel to serial conversion
% without any time control
function Bit_mux()
filename = 'CNN_Network/FC/bit_mux.vhd';
fileID = fopen(filename, 'w');
    fprintf(fileID, '--------------------BIT_MUX MODULE----------------------\n');
    fprintf(fileID, '--This module transforms the parallel input signal into a serial output, it differs from PAR2SER because here we don''t need to register the input data, as the operations in this layer of the network are all done without having to wait between processed data\n');
    fprintf(fileID, '--INPUTS\n');
    fprintf(fileID, '--data_in : input to convert\n');
    fprintf(fileID, '--bit_select : auxiliary signal to choose the bit corresponding to each moment\n');
    fprintf(fileID, '--OUTPUTS\n');
    fprintf(fileID, '--bit_out : converted signal\n\n');
    fprintf(fileID, 'library IEEE;\n');
    fprintf(fileID, 'use IEEE.STD_LOGIC_1164.ALL;\n');
    fprintf(fileID, 'use work.tfg_irene_package.ALL;\n\n');
    fprintf(fileID, 'use IEEE.NUMERIC_STD.ALL;\n\n');
    fprintf(fileID, 'entity bit_mux is\n');
    fprintf(fileID, ' generic (input_size : integer := 8);    --number of bits of the input data\n');
    fprintf(fileID, '    Port ( \n');
    fprintf(fileID, '           data_in : in std_logic_vector (input_size-1 downto 0);\n');
    fprintf(fileID, '           bit_select : in unsigned (log2c(input_size)-1 downto 0);\n');
    fprintf(fileID, '           bit_out : out std_logic);\n');
    fprintf(fileID, 'end bit_mux;\n\n');
    fprintf(fileID, 'architecture Behavioral of bit_mux is\n');
    fprintf(fileID, 'begin\n\n');
    fprintf(fileID, 'bit_out <= data_in(to_integer(bit_select));\n\n');
fprintf(fileID, 'end Behavioral;\n');
fclose(fileID);