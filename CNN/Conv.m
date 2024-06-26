% This function generates the convolutional filters
% INPUTS
% Number of data to be computed by the neuron (x and y dimension)
% Parameters of each neurons, stored in a LUT
% Number of layer of the network
% Number of neuron of the layer
% Bias term fo each neuron
% Number of decimal bits of the weight
% Number of the integer bits of the weight
% Number of decimal bits of the activation
% Number of the integer bits of the activation
% Number of extra bits for the convolution operation
% Z dimension of each filter

function [] = Conv(mul, weights, layer, num, bias_term, n_decimal_w, n_integer_w, n_integer_act, n_decimales_act,n_extra_bits, conv_z)
        %This line has to be commented if all the input data are positive
        %bias_term = bias_term + sum(pesos, 'all')*(2^(n_enteros+n_decimales + 1));
        name = sprintf('CNN_Network/CNN/CONV%d%d.vhd', layer,num);
        fid = fopen(name, 'wt');
        fprintf(fid, '--------------------------CONV MODULE------------------------------------\n');
        fprintf(fid, '-- This module performs the convolution function which consists of the addition of each multiplication of a signal by its corresponding weight,\n');
        fprintf(fid, '-- depending on the position of the filter window. It is performed by adding a 1 each time the input pulse indicates that the signal is not \n');
        fprintf(fid, '-- zero. \n');
        fprintf(fid, '---INPUTS\n');
        fprintf(fid, '-- data_in : each bit of the input data.\n');
        fprintf(fid, '-- address : indicates which part of the filter we are calculating to select the corresponding weight, it will have size conv_col * conv_row * number_of_layers\n');
        fprintf(fid, '-- next_pipeline_step : notifies when a filter convolution is finished and moves on to the next one.\n');
        fprintf(fid, '-- bit select : indicates which bit of the input data we are receiving at each moment.\n');
        fprintf(fid, '---OUTPUTS\n');
        fprintf(fid, '-- data_out : the output is the accumulation of the input signals multiplied by the respective filters (convolution).\n');
        fprintf(fid, '-- weight : weight corresponding to the part of the filter we are currently calculating. as this layer is parallelized we transmit the weight to the parallel neurons.\n\n');
        fprintf(fid, 'library IEEE;\n');
        fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
        fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
        fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
        fprintf(fid, 'use IEEE.MATH_REAL.ALL;\n');
        fprintf(fid, 'entity CONV%d%d is\n', layer, num);
        fprintf(fid, '\t Port (data_in : in std_logic;\n');
        fprintf(fid, '\t\t    clk : in std_logic;\n');
        fprintf(fid, '\t\t    rst : in std_logic;\n');
        fprintf(fid, '\t\t    next_pipeline_step : in std_logic;\n');
        if(layer == 1) 
        fprintf(fid, '\t\t    address : in std_logic_vector(integer(ceil(log2(real(mult1))))  - 1 downto 0);\n');
        fprintf(fid,' \t\t    weight_out : out signed(weight_sizeL%d - 1 downto 0); \n', layer); 
        else
        fprintf(fid, '\t\t    address : in std_logic_vector(integer(ceil(log2(real(mult%d))))  + integer(ceil(log2(real(number_of_layers%d))))  - 1 downto 0);\n', layer, layer);
        end
        fprintf(fid, '\t\t    bit_select : in unsigned (log2c(input_sizeL%d)-1 downto 0);\n', layer);
        fprintf(fid, '\t\t    data_out : out STD_LOGIC_VECTOR(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0));\n', layer, layer);
        fprintf(fid, 'end CONV%d%d; \n', layer, num);
        fprintf(fid, 'architecture Behavioral of CONV%d%d is\n', layer, num);
        fprintf(fid,' signal weight : signed(weight_sizeL%d - 1 downto 0); \n', layer);
        fprintf(fid, 'signal mac_out_next, mac_out_reg : signed (input_sizeL%d+weight_sizeL%d+n_extra_bits-1 downto 0) := "%s"; -- signals to compute the convolution, we add extra bits for precision.\n', layer, layer, dec2q(bias_term, n_integer_w + n_integer_act + n_extra_bits  + 1 ,n_decimal_w + n_decimales_act , 'bin') );
        fprintf(fid, 'signal mux_out3 : signed (input_sizeL%d+weight_sizeL%d+n_extra_bits-1 downto 0) := (others => ''0'' );\n', layer, layer);
        fprintf(fid, 'signal mux_out1, mux_out2, extended_weight, shifted_weight_next, shifted_weight_reg : signed (weight_sizeL%d+input_sizeL%d-2 downto 0); -- Only need to shift (input_size-1) times - e.g. 7 shifts if input_size = 8, hence the "-2".\n', layer, layer);
        fprintf(fid, 'begin\n');
        fprintf(fid, 'process(clk)\n');
        fprintf(fid, 'begin\n');
        fprintf(fid, 'if rising_edge(clk) then\n');
        fprintf(fid, '\t if (rst = ''0'') then\n');
        fprintf(fid, '\t\tmac_out_reg <= "%s"; \n', dec2q(bias_term, n_integer_w + n_integer_act + n_extra_bits  + 1 ,n_decimal_w + n_decimales_act , 'bin') );
        fprintf(fid, '\t\tshifted_weight_reg <= (others => ''0'');\n');
        fprintf(fid, '\telse\n');
        fprintf(fid, '\t\t mac_out_reg <= mac_out_next;\n');
        fprintf(fid, '\t\t shifted_weight_reg <= shifted_weight_next;\n');
        fprintf(fid, '\t end if;\n');
        fprintf(fid, 'end if;\n');
        fprintf(fid, 'end process;\n');
        fprintf(fid, '\n');
        fprintf(fid, '-- Weight extension\n');
        fprintf(fid, 'extended_weight <= resize(weight, weight_sizeL%d+input_sizeL%d-1);   -- As we shift the signals (input_size - 1 we need to resize it accordingly (weight_size + input_size - 1).\n', layer, layer);
        fprintf(fid, '\n');
        fprintf(fid, '-- Shift block --\n');
        fprintf(fid, 'mux_out1 <= extended_weight when (bit_select = "000") else  -- Each time a new signal is received (bit_select = 0) we reset the shifted weight.\n');
        fprintf(fid, '\t\t shifted_weight_reg;\n');
        fprintf(fid, ' shifted_weight_next <= mux_out1(weight_sizeL%d+input_sizeL%d - n_extra_bits downto 0) & ''0'';   -- Logic Shift Left\n', layer, layer);
        fprintf(fid, '\n');
        fprintf(fid, '\t\t -- Addition block\n');
        fprintf(fid, 'process (data_in, mux_out1)  --If the input bit is 1 we add the shifted weight to the accumulated result. \n');
        fprintf(fid, 'begin\n');
        fprintf(fid, '\t if(data_in = ''1'') then\n');
        fprintf(fid, '\t\t mux_out2 <= mux_out1;\n');
        fprintf(fid, '\t else\n');
        fprintf(fid, '\t \t mux_out2<= (others => ''0''); \n');
        fprintf(fid, ' \t \t end if; \n');
        fprintf(fid, 'end process;\n');
        fprintf(fid, ' mux_out3 <= resize(mux_out2,input_sizeL%d+weight_sizeL%d+n_extra_bits );\n', layer, layer);
        fprintf(fid, '\n');
        fprintf(fid, 'process (next_pipeline_step, mac_out_reg, mac_out_next, mux_out3)    --if next_pipeline_step = ''1'' it means that the convolution is finished and we reset the result to the bias_term (offset) else we accumulate the result of the multiplications.\n');
        fprintf(fid, 'begin\n');
        fprintf(fid, 'if (next_pipeline_step = ''1'') then\n');
        fprintf(fid, '\t mac_out_next <= "%s"; --We add the bias_term as an offset at the beggining of each convolution.\n', dec2q(bias_term, n_integer_w + n_integer_act + n_extra_bits + 1 ,n_decimal_w + n_decimales_act  , 'bin'));
        fprintf(fid, 'else\n');
        fprintf(fid, '\t mac_out_next <= mac_out_reg + mux_out3;\n');
        fprintf(fid, 'end if;\n');
        fprintf(fid, 'end process;\n');
        fprintf(fid, 'data_out <= std_logic_vector(mac_out_reg);\n');
        fprintf(fid, 'with address select weight <= \n');
        if(layer == 1) 
            for i = 0:mul -1
                    fprintf(fid, '\t"%s" when "%s", -- %d\n', dec2q(weights(i + 1), n_integer_w, n_decimal_w, 'bin'), dec2bin(i, ceil(log2(mul))), i );
            end
            fprintf(fid, '\t\t "%s" when others; \n ', dec2q(0, n_integer_w, n_decimal_w, 'bin'));
            fprintf(fid, 'weight_out <= weight; \n ');
        else
            o = 1;
            for i = 0:mul -1
                for j = 0 : conv_z -1
                    fprintf(fid, '\t\t "%s" when "%s%s", -- %d \n', dec2q(weights(o), n_integer_w, n_decimal_w, 'bin'),  dec2bin(i, ceil(log2(mul))), dec2bin(j, ceil(log2(conv_z))), o );
                    o = o+ 1;
                end 
            end
          fprintf(fid, '\t\t "%s" when others; \n ', dec2q(0, n_integer_w, n_decimal_w, 'bin'));
        end       
        fprintf(fid, 'end Behavioral;\n\n');   
        fclose(fid);
           
end

