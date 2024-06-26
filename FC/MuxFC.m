% This function generates the multiplexers of the FC network
% INPUTS
% Number of layer of the network
function MuxFC(layer, layers_fc)
name = sprintf('CNN_Network/FC/Mux_FCL%d.vhd', layer);
fid = fopen(name, 'wt');
fprintf(fid, '--------------------MULTIPLEXER MODULE----------------------\n');
fprintf(fid, '--This module selects the data to be sent at each moments to the neurons in the layer, it also saturates the inputdata if its to big or to small\n');
fprintf(fid, '--INPUTS\n');
fprintf(fid, '--data_in : output from the neurons\n');
fprintf(fid, '--ctrl : control signal to know which data is to be sent\n');
fprintf(fid, '--mac_max, mac_min : maximum and minimum value that each input data can take (stauration values)\n');
fprintf(fid, '--OUTPUTS\n');
fprintf(fid, '--data_out : input data send to the following layer\n');
fprintf(fid, 'library IEEE;\n');
fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n\n');
fprintf(fid, 'entity Mux_FCL%d is\n', layer);
fprintf(fid, '    Port ( data_in : in vector_L%dfc_activations(0 to number_of_inputs_L%dfc-1);\n', layer, layer + 1);
fprintf(fid, '           ctrl : in std_logic_vector(log2c(number_of_outputs_L%dfc) - 1 downto 0 );\n', layer);
fprintf(fid, '           mac_max : in signed (input_size_L%dfc+weight_size_L%dfc+n_extra_bits-1 downto 0);\n', layer + 1 , layer + 1);
fprintf(fid, '           mac_min : in signed (input_size_L%dfc+weight_size_L%dfc+n_extra_bits-1 downto 0);\n',  layer  + 1, layer + 1);
fprintf(fid, '           data_out : out STD_LOGIC_VECTOR(input_size_L%dfc-1 downto 0));\n', layer +1);
fprintf(fid, 'end Mux_FCL%d;\n', layer);
fprintf(fid, 'architecture Behavioral of Mux_FCL%d is\n\n', layer);
fprintf(fid, 'signal index : unsigned (log2c(number_of_outputs_L%dfc) - 1 downto 0 ) := (others => ''0'');\n', layer);
fprintf(fid, 'signal data_out_pre : std_logic_vector(input_size_L%dfc+weight_size_L%dfc+n_extra_bits-1 downto 0) := (others => ''0'');\n\n', layer , layer);
fprintf(fid, 'begin\n\n');
fprintf(fid, 'index <= unsigned(ctrl);\n\n');
fprintf(fid, 'process(data_in, index)\n');
fprintf(fid, 'begin\n');
fprintf(fid, '    if (index < number_of_outputs_L%dfc) then\n', layer);
fprintf(fid, '        data_out_pre <= data_in(to_integer(index));\n');
fprintf(fid, '    else\n');
fprintf(fid, '        data_out_pre(input_size_L%dfc+weight_size_L%dfc+n_extra_bits-1) <= ''1'';\n', layer , layer );
fprintf(fid, '        data_out_pre(input_size_L%dfc+weight_size_L%dfc+n_extra_bits-2 downto 0) <= (others => ''0'');\n', layer, layer );
fprintf(fid, '    end if;\n\n');
fprintf(fid, 'end process;\n\n');
fprintf(fid, '-- Selection of the output value taking into account the saturation values\n');
fprintf(fid, 'process(mac_max, mac_min, data_out_pre)\n');
fprintf(fid, 'begin\n');
fprintf(fid, '\tif (signed(data_out_pre) >= mac_max) then\n');
fprintf(fid, '\t\tdata_out(input_size_L%dfc-1) <= ''0'';\n', layer + 1);
fprintf(fid, '\t\tdata_out(input_size_L%dfc-2 downto 0) <= (others => ''1'');\n', layer + 1);
fprintf(fid, '\telsif (signed(data_out_pre) <= mac_min) then\n');
fprintf(fid, '\t\tdata_out(input_size_L%dfc-1) <= ''1'';\n', layer + 1);
fprintf(fid, '\t\tdata_out(input_size_L%dfc-2 downto 0) <= (others => ''0'');\n', layer + 1);
fprintf(fid, '\telse\n');
fprintf(fid, '\t\tdata_out <= data_out_pre(w_fractional_size_L%dfc + input_size_L%dfc - 1 downto w_fractional_size_L%dfc);\n', layer , layer + 1 , layer);
fprintf(fid, '\tend if;\n');
fprintf(fid, 'end process;\n');
fprintf(fid, '\nend Behavioral;');
fclose(fid);
end