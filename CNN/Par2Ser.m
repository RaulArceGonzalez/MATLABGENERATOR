% This function generates the module for the parallel to serial conversion
% with time control
function [] = Par2Ser()
name = sprintf('CNN_Network/CNN/PAR2SER.vhd');
fileID = fopen(name, 'wt');
fprintf(fileID, '--------------------PAR2SER MODULE----------------------\n');
fprintf(fileID, '--This module transforms the parallel input signal into a serial output.\n');
fprintf(fileID, '--INPUTS\n');
fprintf(fileID, '--data_in : input to convert\n');
fprintf(fileID, '--bit_select : auxiliary signal to choose the bit corresponding to each moment\n');
fprintf(fileID, '--en_neuron : auxiliary signal to know when the input data is valid\n');
fprintf(fileID, '--OUTPUTS\n');
fprintf(fileID, '--bit_out : converted signal\n');
fprintf(fileID, 'library IEEE;\n');
fprintf(fileID, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fileID, 'use work.tfg_irene_package.ALL;\n');
fprintf(fileID, 'use IEEE.NUMERIC_STD.ALL;\n');
fprintf(fileID, 'entity PAR2SER is\n');
fprintf(fileID, 'generic (input_size : integer := 8); --number of bits of the input signals\n');
fprintf(fileID, 'Port ( clk : in std_logic;\n');
fprintf(fileID, '       rst : in std_logic;\n');
fprintf(fileID, '       data_in : in std_logic_vector (input_size-1 downto 0);\n');
fprintf(fileID, '       en_neuron : in std_logic;\n');
fprintf(fileID, '       bit_select : in unsigned( log2c(input_size) - 1 downto 0);\n');
fprintf(fileID, '       bit_out : out std_logic);');
 fprintf(fileID, 'end PAR2SER; \n');
fprintf(fileID, 'architecture Behavioral of PAR2SER is\n');
fprintf(fileID, 'signal data_in_reg, data_in_next: std_logic_vector(input_size-1 downto 0);\n');
fprintf(fileID, 'begin \n\n');
fprintf(fileID, '--Register\n');
fprintf(fileID, '  process(clk)\n');
fprintf(fileID, '  begin\n');
fprintf(fileID, '  if (clk''event and clk = ''1'') then\n');
fprintf(fileID, '    if (rst = ''0'') then\n');
fprintf(fileID, '      data_in_reg <= (others => ''0'');\n');
fprintf(fileID, '    else\n');
fprintf(fileID, '        data_in_reg <= data_in_next;\n');
fprintf(fileID, '      end if;\n');
fprintf(fileID, '    end if;\n');
fprintf(fileID, '  end process;\n\n');
fprintf(fileID, '--Next state logic\n');
fprintf(fileID, '  process(bit_select, data_in, data_in_reg, en_neuron, data_in_next)\n');
fprintf(fileID, '  begin\n');
fprintf(fileID, '    if (bit_select = 0 and en_neuron = ''1'') then\n');
fprintf(fileID, '      data_in_next <= data_in;\n');
fprintf(fileID, '    else\n');
fprintf(fileID, '      data_in_next <= data_in_reg;\n');
fprintf(fileID, '    end if;\n');
fprintf(fileID, '  end process;\n\n');
fprintf(fileID, '--Output logic\n');
fprintf(fileID, '  bit_out <= data_in_next(to_integer(bit_select));\n');
fprintf(fileID, 'end Behavioral;\n');
           
end

