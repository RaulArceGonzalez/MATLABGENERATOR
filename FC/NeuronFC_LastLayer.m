% This function generates the neurons of the last layer of fully connected part
% INPUTS
% Number of neuron of the layer
% Number of layers of the FC part of the network
function NeuronFC_LastLayer(number_of_neuron, number_of_layers_fc)

    name = sprintf('CNN_Network/FC/layer_out_neuron_%d.vhd', number_of_neuron);
    fid = fopen(name, 'wt');
         fprintf(fid, '--------------------------LAST LAYER NEURON MODULE------------------------------------\n');
        fprintf(fid, '-- This module is part of the implementation of the softmax function, it performs the multiplication of each element by the inverse of the summatory, thus making the division\n');
        fprintf(fid, '-- It is performed by adding a 1 each time the input pulse indicates that the signal is not zero. \n');
        fprintf(fid, '---INPUTS\n');
        fprintf(fid, '-- data_in : each bit of the input data, which corresponds to the inverse of the summatory .\n');
        fprintf(fid, '-- weight : the result of the exponential for each output\n');
        fprintf(fid, '-- next_pipeline_step : notifies when the input data has been processed and moves on to the next.\n');
        fprintf(fid, '-- bit select : indicates which bit of the input data we are receiving at each moment.\n');
        fprintf(fid, '---OUTPUTS\n');
        fprintf(fid, '-- neuron_mac : the output is the result of the division, which represents the probability of each different output.\n');
    % Escritura en fichero de las líneas comunes a todas las neuronas %
    
    fprintf(fid, 'library IEEE;\n');
    fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
    fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
    fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
    fprintf(fid, 'use IEEE.MATH_REAL.ALL;\n');
    fprintf(fid, '\n');

    fprintf(fid, 'entity layer_out_neuron_%d is\n', number_of_neuron);
    fprintf(fid, '\tPort ( clk : in STD_LOGIC;\n');
    fprintf(fid, '\t\trst : in STD_LOGIC;\n');
    fprintf(fid, '\t\tdata_in_bit : in STD_LOGIC;\n');
    fprintf(fid, '\t\tbit_select : in unsigned (log2c(input_size_L%dfc)-1 downto 0);\n', number_of_layers_fc);
    fprintf(fid, '\t\tweight : in signed(input_size_L%dfc-1 downto 0);\n', number_of_layers_fc);
    fprintf(fid, '\t\tnext_pipeline_step : in std_logic;\n');
    fprintf(fid, '\t\tneuron_mac : out STD_LOGIC_VECTOR (input_size_L%dfc-1 downto 0));\n', number_of_layers_fc);
    fprintf(fid, 'end layer_out_neuron_%d;\n', number_of_neuron);
    fprintf(fid, '\n');

    fprintf(fid, 'architecture Behavioral of layer_out_neuron_%d is\n', number_of_neuron);
    fprintf(fid, '\n');

    fprintf(fid, 'signal mac_out_next, mac_out_reg, mux_out3 : signed (input_size_L%dfc+weight_size_L%dfc+n_extra_bits-1 downto 0) := (others => ''0''); --We add extra bits for precision.\n', number_of_layers_fc, number_of_layers_fc);
    fprintf(fid, 'signal mux_out1, mux_out2, extended_weight, shifted_weight_next, shifted_weight_reg : signed (weight_size_L%dfc+input_size_L%dfc-2 downto 0);\n', number_of_layers_fc, number_of_layers_fc);
    fprintf(fid, '-- Only need to shift (input_size-1) times - e.g. 7 shifts if input_size = 8, hence the "-2".\n');
    fprintf(fid, '\n');
    
    fprintf(fid, 'begin\n');
    fprintf(fid, '\n');
     fprintf(fid, '-- Register --\n');
    fprintf(fid, 'process (clk)\n');
    fprintf(fid, 'begin\n');
    fprintf(fid, '\tif rising_edge(clk) then\n');
    fprintf(fid, '\t\tif (rst = ''0'') then\n');
    fprintf(fid, '\t\t\tmac_out_reg <= (others => ''0'');  \n');
	fprintf(fid, '\t\t\tshifted_weight_reg <= (others => ''0'');\n');
    fprintf(fid, '\t\telse\n');
    fprintf(fid, '\t\t\tmac_out_reg <= mac_out_next;\n');
    fprintf(fid, '\t\t\tshifted_weight_reg <= shifted_weight_next;\n');
    fprintf(fid, '\t\tend if;\n');
    fprintf(fid, '\tend if;\n');
    fprintf(fid, 'end process;\n');
    fprintf(fid, '\n');


    fprintf(fid, '-- Weight extension\n');
    fprintf(fid, 'extended_weight <= resize(weight, weight_size_L%dfc+input_size_L%dfc-1);   -- As we shift the signals (input_size - 1 we need to resize it accordingly (weight_size + input_size - 1).\n', number_of_layers_fc, number_of_layers_fc);
    fprintf(fid, '\n');

    fprintf(fid, '-- Shift block --\n');
    fprintf(fid, 'mux_out1 <= extended_weight when (bit_select = "000") else\n');
    fprintf(fid, '\t\tshifted_weight_reg;\n');  
    fprintf(fid, '\n');

    fprintf(fid, 'shifted_weight_next <= mux_out1(weight_size_L%dfc+input_size_L%dfc - n_extra_bits downto 0) & ''0'';   -- Logic Shift Left\n', number_of_layers_fc, number_of_layers_fc);
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
        fprintf(fid, ' mux_out3 <= resize(mux_out2,input_size_L%dfc+weight_size_L%dfc+n_extra_bits );\n', number_of_layers_fc, number_of_layers_fc);
        fprintf(fid, '\n');
        fprintf(fid, 'process (next_pipeline_step, mac_out_reg, mac_out_next, mux_out3)   --if next_pipeline_step = ''1'' it means that the MAAC operation is finished and we reset the result to the bias_term (offset) else we accumulate the result of the multiplications.\n');
        fprintf(fid, 'begin\n');
        fprintf(fid, 'if (next_pipeline_step = ''1'') then\n');
        fprintf(fid, '\t mac_out_next <= (others=>''0'') ; --We add the bias_term as an offset at the beggining of each operation.\n');
        fprintf(fid, 'else\n');
        fprintf(fid, '\t mac_out_next <= mac_out_reg + mux_out3;\n');
        fprintf(fid, 'end if;\n');
        fprintf(fid, 'end process;\n');
        fprintf(fid, 'neuron_mac <= std_logic_vector(mac_out_next(fractional_size_L%dfc + weight_size_L%dfc - 1 downto fractional_size_L%dfc)); \n', number_of_layers_fc, number_of_layers_fc, number_of_layers_fc);

    fprintf(fid, 'end Behavioral;\n\n');   
    fclose(fid);
           
     