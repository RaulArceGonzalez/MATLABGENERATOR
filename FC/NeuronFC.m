% This function generates the fully connected neurons
% INPUTS
% Bias term of each neuron
% Parameters of each neurons, stored in a LUT
% Number of the integer bits of the weight
% Number of decimal bits of the weight
% Number of neuron of the layer
% Maximum number of input data in a neuron
% Number of the integer bits of the activation
% Number of decimal bits of the activation
% Numbber of extra bits for the operation
% Number of the last layer of the CNN part of the network
function NeuronFC(bias_term,weights, n_integer_w, n_decimal_w,number_of_neuron, biggest_ROM_size, n_integer_act, n_decimal_act, n_extra_bits,layer ,layer_conv, number_of_neuronsFC)
name = sprintf('CNN_Network/FC/layer%d_FCneuron_%d.vhd',layer, number_of_neuron);
fid = fopen(name, 'wt');
fprintf(fid, '--------------------------FC NEURON MODULE------------------------------------\n');
fprintf(fid, '-- This module performs the MAAC operation which consists of the addition of each multiplication of a signal by its corresponding weight.\n');
fprintf(fid, '-- It is performed by adding a 1 each time the input pulse indicates that the signal is not zero. \n');
fprintf(fid, '---INPUTS\n');
fprintf(fid, '-- data_in : each bit of the input data.\n');
fprintf(fid, '-- rom_addr : indicates which weight to operate with, corresponding to the input_data\n');
fprintf(fid, '-- next_pipeline_step : notifies when all the input data has been processed and moves on to the next set of data.\n');
fprintf(fid, '-- bit select : indicates which bit of the input data we are receiving at each moment.\n');
fprintf(fid, '---OUTPUTS\n');
fprintf(fid, '-- neuron_mac : the output is the accumulation of the input signals multiplied by the respective weights.\n');
fprintf(fid, 'library IEEE;\n');
fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
fprintf(fid, 'use IEEE.MATH_REAL.ALL;\n');
fprintf(fid, '\n');
fprintf(fid, 'entity layer%d_FCneuron_%d is\n', layer,number_of_neuron);
fprintf(fid, '\tPort ( clk : in STD_LOGIC;\n');
fprintf(fid, '\t\trst : in STD_LOGIC;\n');
fprintf(fid, '\t\tdata_in_bit : in STD_LOGIC;\n');
fprintf(fid, '\t\tnext_pipeline_step : in STD_LOGIC;\n');
fprintf(fid, '\t\tbit_select : in unsigned (log2c(input_size_L%dfc)-1 downto 0); \n', layer);
fprintf(fid, '\t\trom_addr : in STD_LOGIC_VECTOR  (log2c(number_of_layers%d) + log2c(result_size) - 1 downto 0); \n', layer_conv);
fprintf(fid, '\t\tneuron_mac : out STD_LOGIC_VECTOR (input_size_L%dfc+weight_size_L%dfc + n_extra_bits-1 downto 0));\n', layer, layer);
fprintf(fid, 'end layer%d_FCneuron_%d ;\n', layer,number_of_neuron);
fprintf(fid, '\n');
fprintf(fid, 'architecture Behavioral of layer%d_FCneuron_%d is\n', layer,number_of_neuron);
fprintf(fid, '\n');
fprintf(fid, 'signal mac_out_next, mac_out_reg : signed (input_size_L%dfc+weight_size_L%dfc+n_extra_bits-1 downto 0) := "%s"; --We add extra bits for precision.\n', layer, layer, dec2q(bias_term, n_integer_w + n_integer_act + n_extra_bits + 1 ,n_decimal_w + n_decimal_act  , 'bin'));
fprintf(fid, 'signal mux_out3 : signed (input_size_L%dfc+weight_size_L%dfc+n_extra_bits-1 downto 0) := (others=>''0'');\n', layer, layer);
fprintf(fid, 'signal weight, aux_weight : signed (weight_size_L%dfc-1 downto 0);\n', layer);
fprintf(fid, 'signal mux_out1, mux_out2, extended_weight, shifted_weight_next, shifted_weight_reg : signed (weight_size_L%dfc+input_size_L%dfc-2 downto 0);\n', layer, layer);
fprintf(fid, '-- Only need to shift (input_size-1) times - e.g. 7 shifts if input_size = 8, hence the "-2".\n');
fprintf(fid, '\n');
fprintf(fid, 'begin\n');
fprintf(fid, '\n');
fprintf(fid, '-- Register --\n');
fprintf(fid, 'process (clk)\n');
fprintf(fid, 'begin\n');
fprintf(fid, '\tif rising_edge(clk) then\n');
fprintf(fid, '\t\tif (rst = ''0'') then\n');
fprintf(fid, '\t\t\tmac_out_reg <="%s";  \n', dec2q(bias_term, n_integer_w + n_integer_act + n_extra_bits + 1 ,n_decimal_w + n_decimal_act  , 'bin'));
fprintf(fid, '\t\t\tshifted_weight_reg <= (others => ''0'');\n');
fprintf(fid, '\t\telse\n');
fprintf(fid, '\t\t\tmac_out_reg <= mac_out_next;\n');
fprintf(fid, '\t\t\tshifted_weight_reg <= shifted_weight_next;\n');
fprintf(fid, '\t\tend if;\n');
fprintf(fid, '\tend if;\n');
fprintf(fid, 'end process;\n');
fprintf(fid, '\n');
fprintf(fid, '-- Weight extension\n');
fprintf(fid, 'extended_weight <= resize(weight, weight_size_L%dfc+input_size_L%dfc-1);   -- As we shift the signals (input_size - 1 we need to resize it accordingly (weight_size + input_size - 1).\n', layer, layer);
fprintf(fid, '\n');
fprintf(fid, '-- Shift block --\n');
fprintf(fid, 'mux_out1 <= extended_weight when (bit_select = "000") else\n');
fprintf(fid, '\t\tshifted_weight_reg;\n');
fprintf(fid, '\n');
fprintf(fid, 'shifted_weight_next <= mux_out1(weight_size_L%dfc+input_size_L%dfc -n_extra_bits downto 0) & ''0'';   -- Logic Shift Left\n', layer, layer);
fprintf(fid, '\n');
fprintf(fid, '-- Addition block\n');
fprintf(fid, 'process (data_in_bit, mux_out1) --If the input bit is 1 we add the shifted weight to the accumulated result.  \n');
fprintf(fid, 'begin\n');
fprintf(fid, '\t if(data_in_bit = ''1'') then\n');
fprintf(fid, '\t\t mux_out2 <= mux_out1;\n');
fprintf(fid, '\t else\n');
fprintf(fid, '\t \t mux_out2<= (others => ''0''); \n');
fprintf(fid, ' \t \t end if; \n');
fprintf(fid, 'end process;\n');
fprintf(fid, ' mux_out3 <= resize(mux_out2,input_size_L%dfc+weight_size_L%dfc+n_extra_bits );\n', layer, layer);
fprintf(fid, '\n');
fprintf(fid, 'process (next_pipeline_step, mac_out_reg, mac_out_next, mux_out3)   --if next_pipeline_step = ''1'' it means that the MAAC operation is finished and we reset the result to the bias_term (offset) else we accumulate the result of the multiplications.\n');
fprintf(fid, 'begin\n');
fprintf(fid, 'if (next_pipeline_step = ''1'') then\n');
fprintf(fid, '\t mac_out_next <= "%s"; --We add the bias_term as an offset at the beggining of each operation.\n', dec2q(bias_term, n_integer_w + n_integer_act + n_extra_bits + 1 ,n_decimal_w + n_decimal_act  , 'bin'));
fprintf(fid, 'else\n');
fprintf(fid, '\t mac_out_next <= mac_out_reg + mux_out3;\n');
fprintf(fid, 'end if;\n');
fprintf(fid, 'end process;\n');
fprintf(fid, 'neuron_mac <= std_logic_vector(mac_out_reg);\n');
fprintf(fid, '-- ROM --\n');
fprintf(fid, '\twith rom_addr select weight <=\n\n');
count= 1;
if(layer == 1)
    for i = 0 : biggest_ROM_size - 1
        fprintf(fid, '\t\t "%s" when "%s", -- Weight %d  \n', dec2q(weights(i + 1), n_integer_w, n_decimal_w, 'bin'),  dec2bin(i, ceil(log2(biggest_ROM_size - 1))), i);
        count= count + 1;
    end
else
    for i = 0 : number_of_neuronsFC(layer - 1) - 1
        fprintf(fid, '\t\t "%s" when "%s", -- Weight %d  \n', dec2q(weights(i + 1), n_integer_w, n_decimal_w, 'bin'),  dec2bin(i, ceil(log2(biggest_ROM_size - 1))), i);
        count= count + 1;
    end
end
fprintf(fid, '\t\t "%s" when others; \n ', dec2bin(0, (n_integer_w + n_decimal_w + 1 )));
fprintf(fid, 'end Behavioral;\n\n');
fclose(fid);

