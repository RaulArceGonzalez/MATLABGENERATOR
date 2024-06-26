% This function generates the module for the registers of the FC network
% INPUTS
% Number of the layer where the register is located in each case
function RegisterFC(layer, layers_fc)
name = sprintf('CNN_Network/FC/Register_FCL%d.vhd', layer);
fid = fopen(name, 'wt');
fprintf(fid, '--------------------------REGISTER------------------------------------\n');
fprintf(fid, '-- This module regster the results from the neurons of one layer of the FC and stores them until they are sent to the following layer\n');
fprintf(fid, '---INPUTS\n');
fprintf(fid, '-- data_in :Results of the MAAC operations of this layer.\n');
fprintf(fid, '-- next_pipeline_step : notifies when the input data has been processed and is sent to the following layer\n');
fprintf(fid, '---OUTPUTS\n');
fprintf(fid, '-- data_out : Data sent to the next layer.\n');   
fprintf(fid, 'library IEEE;\n');
fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
fprintf(fid, '\n');
fprintf(fid, 'entity Register_FCL%d is\n', layer);
fprintf(fid, '    Port ( clk : in STD_LOGIC; \n');
fprintf(fid, '           rst : in STD_LOGIC;\n');
fprintf(fid, '           data_in : in vector_L%dfc_activations(0 to number_of_inputs_L%dfc-1);\n', layer, layer + 1);
fprintf(fid, '           next_pipeline_step : in STD_LOGIC;\n');
fprintf(fid, '           data_out : out vector_L%dfc_activations(0 to number_of_inputs_L%dfc-1));\n', layer, layer + 1);
fprintf(fid, 'end Register_FCL%d;\n', layer);
fprintf(fid, '\n');
fprintf(fid, 'architecture Behavioral of Register_FCL%d is\n', layer);
fprintf(fid, '\n');
fprintf(fid, 'begin\n');
fprintf(fid, '\n');
fprintf(fid, 'process(clk)\n');
fprintf(fid, 'begin\n');
fprintf(fid, '    if rising_edge(clk) then\n');
fprintf(fid, '        if (rst = ''0'') then\n');
fprintf(fid, '            data_out <= (others => (others => ''0''));\n');
fprintf(fid, '        elsif (next_pipeline_step = ''1'') then\n');
fprintf(fid, '                data_out <= data_in;                   \n');
fprintf(fid, '        end if;\n');
fprintf(fid, '    end if;\n');
fprintf(fid, 'end process;\n');
fprintf(fid, '\n');
fprintf(fid, 'end Behavioral;\n');   
fclose(fid);
end
           
     