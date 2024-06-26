% This function generates the parallel convolutional filters
% INPUTS
% Number of layer of the network
% Number of neuron of the layer
% Bias term fo each neuron
% Number of decimal bits of the weight
% Number of the integer bits of the weight
% Number of decimal bits of the weight
% Number of the integer bits of the weight
% Number of extra bits for the convolution operation
function [] = ConvParallel( layer, num, bias_term, n_decimal_w, n_integer_w, n_integer_act, n_decimales_act, n_extra_bits)
        name = sprintf('CNN_Network/CNN/CONVP%d%d.vhd', layer,num);
        fid = fopen(name, 'wt');
        fprintf(fid, '--------------------------MODULO CONV------------------------------------\n');
        fprintf(fid, '--Este modulo realiza la función de convolución que cosiste en la suma de cada multiplicación de una señal por su peso correspondiente\n');
        fprintf(fid, '--según en que posición de la ventana del filtro se encuentra, se realiza sumando un 1 cada vez que el pulso de entrada indique que la señal no \n');
        fprintf(fid, '--es nula. Además si el pulso de entrada indica que la señal es negativa se invertirá el peso.\n');
        fprintf(fid, '---ENTRADAS\n');
        fprintf(fid, '-- data_in : los datos de entrada uno por uno como un pulso en serie\n');
        fprintf(fid, '-- mul : indica en que parte del filtro nos encontramos, tendrá tamaño conv_col * conv_row * number_of_layers\n');
        fprintf(fid, '-- weight : peso correspondiente a la parte del filtro en la que nos encontremos\n');
        fprintf(fid, '-- next_pipeline_step : notifica de cuando termina una pasada del filtro y se pasa a la siguiente\n');
        fprintf(fid, '---SALIDAS\n');
        fprintf(fid, '--data_out : como salida se produce la acumulación de las señales de entrada multiplicadas por sus respectivos filtros\n');
        fprintf(fid, 'library IEEE;\n');
        fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
        fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
        fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
        fprintf(fid, 'entity CONVP%d%d is\n', layer, num);
        fprintf(fid, '\t Port (data_in : in std_logic;\n');
        fprintf(fid, '\t\t    clk : in std_logic;\n');
        fprintf(fid, '\t\t    rst : in std_logic;\n');
        fprintf(fid, '\t\t    next_pipeline_step : in std_logic;\n');
        fprintf(fid,' \t\t    weight : in signed(weight_sizeL%d - 1 downto 0); \n', layer); 
        fprintf(fid, '\t\t    bit_select : in unsigned (log2c(input_sizeL%d)-1 downto 0);\n', layer);
        fprintf(fid, '\t\t    data_out : out STD_LOGIC_VECTOR(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0));\n', layer, layer);
        fprintf(fid, 'end CONVP%d%d; \n', layer, num);
        fprintf(fid, 'architecture Behavioral of CONVP%d%d is\n', layer, num);
        fprintf(fid, 'signal mac_out_next, mac_out_reg : signed (input_sizeL%d+weight_sizeL%d+n_extra_bits-1 downto 0) := "%s"; --se añade precisión hasta llegar al doble de decimales que para el LSB \n', layer, layer, dec2q(bias_term, n_integer_w + n_integer_act + n_extra_bits + 1 ,n_decimal_w + n_decimales_act, 'bin'));
        fprintf(fid, 'signal mux_out3 : signed (input_sizeL%d+weight_sizeL%d+n_extra_bits-1 downto 0) := (others => ''0'' ); --se añade precisión hasta llegar al doble de decimales que para el LSB \n', layer, layer);
        fprintf(fid, 'signal mux_out1, mux_out2, extended_weight, shifted_weight_next, shifted_weight_reg : signed (weight_sizeL%d+input_sizeL%d-2 downto 0); -- Solo se necesita desplazar (input_size-1) veces - ej: 7 desplazamientos si input_size = 8, por eso el "-2".\n', layer, layer);
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
        fprintf(fid, '-- Weight extension\n');
        fprintf(fid, 'extended_weight <= resize(weight, weight_sizeL%d+input_sizeL%d-1);   -- La señal se deplaza (input_size-1) veces => (input_size-1) bits adicionales.\n', layer, layer);
        fprintf(fid, '-- Shift block --\n');
        fprintf(fid, 'mux_out1 <= extended_weight when (bit_select = "000") else\n');
        fprintf(fid, '\t\t shifted_weight_reg;\n');
        fprintf(fid, ' shifted_weight_next <= mux_out1(weight_sizeL%d+input_sizeL%d - n_extra_bits downto 0) & ''0'';   -- Logic Shift Left\n', layer, layer);
        fprintf(fid, '\t\t -- Addition block\n');
        fprintf(fid, 'process (data_in, mux_out1)   \n');
        fprintf(fid, 'begin\n');
        fprintf(fid, '\t if(data_in = ''1'') then\n');
        fprintf(fid, '\t\t mux_out2 <= mux_out1;\n');
        fprintf(fid, '\t else\n');
        fprintf(fid, '\t \t mux_out2<= (others => ''0''); \n');
        fprintf(fid, ' \t \t end if; \n');
        fprintf(fid, 'end process;\n');
        fprintf(fid, ' mux_out3 <= resize(mux_out2,input_sizeL%d+weight_sizeL%d+n_extra_bits );\n', layer, layer);
        fprintf(fid, 'process (next_pipeline_step, mac_out_reg, mac_out_next, mux_out3)    --si la señal next-pipeline_step esta activa reseteamos el registro, si no lo es acumulamos el valor de las sumas\n');
        fprintf(fid, 'begin\n');
        fprintf(fid, 'if (next_pipeline_step = ''1'') then\n');
        fprintf(fid, '\t mac_out_next <= "%s";  --Añadimos el bias_term como offset al principio de cada operación MAAC\n', dec2q(bias_term, n_integer_w + n_integer_act+ n_extra_bits  + 1  ,n_decimal_w + n_decimales_act, 'bin'));
        fprintf(fid, 'else\n');
        fprintf(fid, '\t mac_out_next <= mac_out_reg + mux_out3;\n');
        fprintf(fid, 'end if;\n');
        fprintf(fid, 'end process;\n');
        fprintf(fid, 'data_out <= std_logic_vector(mac_out_reg);\n');
        fprintf(fid, 'end Behavioral;\n\n');   
        fclose(fid);
           
end
