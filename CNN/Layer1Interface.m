% This function generates the generator of the computation of the
% directions for layer 1 data
% INPUTS
% Number of layers in the network
% Indicates if there is parallelism in layer 1
function [] = Layer1Interface(layer, layers_cnn, parallelism_layer1, padding)
name = sprintf('CNN_Network/CNN/Interfaz_ET1.vhd');
fid = fopen(name, 'wt');
fprintf(fid, '--------------------INTERFACE LAYER 1----------------------\n');
fprintf(fid, '--This module indicates the address of the input RAM data we need, the operation is identical\n');
fprintf(fid, '--to the interfaces of the other stages but in this case the address is also calculated, in addition we do not send data_zero\n');
fprintf(fid, '--because the generator of this stage will have to process a data independently if it is zero or if it comes from the RAM.\n');
fprintf(fid, '--INPUTS\n');
fprintf(fid, '--p_rowx, p_colx : signals indicating the amount of padding that affects each of the convolutional filter architecture\n');
fprintf(fid, '--padding_col, padding_row : signals indicating whether the column/row position will be miscalculated due to padding\n');
fprintf(fid, '--data_in : signal indicating the need to compute a new data in this layer\n');
fprintf(fid, '--poolx_col : signal indicating the position of the columns of the filter pool of the following layers, if there is no other layer this input signal does not exist\n');
fprintf(fid, '--poolx_row : signal indicating the position of the rows of the filter pool of the following layers, if there is no other layer this input signal does not exist\n');
fprintf(fid, '--convx_col : signal indicating the position of the columns of the convolution filter of the next layer, if there is no other layer this input signal does not exist\n');
fprintf(fid, '--convx_row : signal indicating the position of the rows of the convolution filter of the next layer, if there is no other layer this input signal does not exist.\n');
fprintf(fid, '--OUTPUTS\n');
fprintf(fid, '--zero, zero2 : signal that is kept at 1 or zero depending if the data to process is in padding zone or not, it is passed to a multiplexer at the input of the par2ser converter.\n');
fprintf(fid, '--dato_out : signal indicating if a new data is needed, it is passed to the generator of the previous layer.\n');
fprintf(fid, '--address, address2 : address of the required data in RAM\n');
fprintf(fid, '--data_zero1, data_zero2 : signals to indicate that the data to be processed is a zero from the padding zone\n');
fprintf(fid,'\n');
fprintf(fid,'library IEEE;\n');
fprintf(fid,'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid,'use IEEE.NUMERIC_STD.ALL;\n');
fprintf(fid,'\n');
fprintf(fid,'entity INTERFAZ_ET%d is\n', layer);
fprintf(fid, 'Port (clk : in STD_LOGIC;\n');
fprintf(fid, '      rst : in STD_LOGIC;\n');
fprintf(fid, '      rst_red : in std_logic;\n');
fprintf(fid, '      data_in : in std_logic;\n');
fprintf(fid, '      padding_col%d : in std_logic;\n',layer + 1);
fprintf(fid, '      padding_row%d : in std_logic;\n',layer + 1);
fprintf(fid, '      col%d : in unsigned(log2c(column_size%d + 2*(conv%d_padding)) - 1 downto 0);\n',layer + 1,layer + 1,layer + 1);
for i = layer + 1 : layers_cnn -1
    fprintf(fid, '      p_row%d: in unsigned( log2c(conv%d_padding) downto 0); \n',i,i);
    fprintf(fid, '      p_col%d : in unsigned( log2c(conv%d_padding) downto 0);  \n',i,i);
    fprintf(fid, '      conv%d_col : in unsigned(log2c(conv%d_column) - 1 downto 0);\n', i, i);
    fprintf(fid, '      conv%d_fila : in  unsigned(log2c(conv%d_row) - 1 downto 0);\n', i, i);
    fprintf(fid, '      pool%d_col : in unsigned(log2c(pool%d_column) - 1 downto 0);\n', i + 1, i + 1);
    fprintf(fid, '      pool%d_fila : in  unsigned(log2c(pool%d_row) - 1 downto 0);\n', i + 1, i + 1);
end
fprintf(fid, '      data_out : out std_logic;\n');
fprintf(fid, '      zero : out std_logic;\n');
fprintf(fid, '      zero2 : out std_logic;\n');
fprintf(fid, '      data_zero1 : out std_logic;\n');
fprintf(fid, '      data_zero2 : out std_logic;\n');
fprintf(fid, '      data_addr : out std_logic;\n');
fprintf(fid, '      address : out std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);\n');
fprintf(fid, '      address2 : out std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0));\n');
fprintf(fid,'end Interfaz_ET%d;\n', layer);
fprintf(fid,'architecture Behavioral of Interfaz_ET%d is\n', layer);
fprintf(fid,'type state_type is (idle , s_wait, s0, s1,s2);\n');
fprintf(fid,'signal state_reg, state_next : state_type;\n');
fprintf(fid,'signal col_reg, col_next : unsigned(log2c(column_limit1)  downto 0) := (others => ''0'');\n');
fprintf(fid,'signal row_reg, row_next :  unsigned(log2c(row_limit1)  downto 0) := (others => ''0'');\n');
cont = 1;
for i = layer + 1 : layers_cnn -1
    fprintf(fid,'signal sum_row%d, sum_col%d : unsigned(bits_sum%d_et%d  downto 0) := (others => ''0'');\n', i,i,cont, layer);
    cont = cont + 1;
end

fprintf(fid,'--Layer 1\n');
fprintf(fid,'signal conv1_col_reg, conv1_col_next : unsigned(log2c(conv1_column) - 1 downto 0) := (others => ''0'');\n');
fprintf(fid,'signal conv1_row_reg, conv1_row_next : unsigned(log2c(conv1_row) - 1 downto 0) := (others => ''0'');\n');
fprintf(fid,'signal count_layer_reg, count_layer_next :  unsigned(log2c(number_of_layers1) - 1 downto 0) := (others => ''0'');\n');
if (layers_cnn > 1)
    fprintf(fid,'-- Layer 2\n');
    if(parallelism_layer1 ==1)
        fprintf(fid,'--');
    end
    fprintf(fid,'signal pool2_col_reg, pool2_col_next : unsigned(log2c(pool2_column) - 1 downto 0) := (others => ''0'');\n');
    fprintf(fid,'signal pool2_row_reg, pool2_row_next : unsigned(log2c(pool2_row) - 1 downto 0) := (others => ''0'');\n');
end
fprintf(fid,'--REGISTERS\n');
for i = layer + 2 : layers_cnn -1
    fprintf(fid,'signal p_row%d_reg, p_row%d_next : unsigned(log2c(conv%d_padding) downto 0);\n', i,i,i);
    fprintf(fid,'signal p_col%d_reg, p_col%d_next : unsigned(log2c(conv%d_padding) downto 0);\n', i,i,i);
end
fprintf(fid,'signal address_reg , address_next :  unsigned(log2c(column_limit1) + log2c(column_limit1) + 1 downto 0) := (others => ''0'');\n');
fprintf(fid,'signal address2_reg , address2_next :  unsigned(log2c(row_limit1) + log2c(row_limit1) + 1   downto 0) := (others => ''0'');\n');
fprintf(fid,'signal condition0, condition1,first_reg, first_next, data_out_reg, data_out_next, zero_reg, zero_next, zero2_reg, zero2_next, data_zero1_reg, data_zero1_next, data_zero2_reg, data_zero2_next , data_addr_next, data_addr_reg : std_logic := ''0'';\n');
fprintf(fid,'signal p_flag_reg, p_flag_next, c_reg, c_next: std_logic := ''0'';\n');
c = 1;
for i = layer + 1 : layers_cnn -1
    fprintf(fid,'signal stride%d : unsigned(stride%d_et%d - 1  downto 0);\n', c ,c * 2,layer);
    c = c+1;
end
fprintf(fid, '\n');
fprintf(fid, 'begin\n');
fprintf(fid, 'process(clk)\n');
fprintf(fid, 'begin\n');
fprintf(fid, 'if (clk''event and clk = ''1'') then\n');
fprintf(fid, 'if (rst = ''0'') then\n');
fprintf(fid, 'state_reg <= idle;\n');
fprintf(fid, 'else\n');
fprintf(fid, 'state_reg <= state_next;\n');
fprintf(fid, 'col_reg <= col_next;\n');
fprintf(fid, 'row_reg <= row_next;\n');
fprintf(fid, 'data_zero1_reg <= data_zero1_next;\n');
fprintf(fid, 'data_zero2_reg <= data_zero2_next;\n');
fprintf(fid, '--pool2_col_reg <= pool2_col_next;\n');
fprintf(fid, 'pool2_row_reg <= pool2_row_next;\n');
fprintf(fid, 'conv1_col_reg <= conv1_col_next;\n');
fprintf(fid, 'conv1_row_reg <= conv1_row_next;\n');
fprintf(fid, 'count_layer_reg <= count_layer_next;\n');
fprintf(fid, 'address_reg <= address_next;\n');
fprintf(fid, 'address2_reg <= address2_next;\n');
fprintf(fid, 'first_reg <= first_next;\n');
fprintf(fid, 'data_out_reg <= data_out_next;\n');
fprintf(fid, 'zero_reg <= zero_next;\n');
fprintf(fid, 'zero2_reg <= zero2_next;\n');
for i  = 3:layers_cnn-1
    fprintf(fid,'p_row%d_reg <= p_row%d_next; \n', i, i);
    fprintf(fid,'p_col%d_reg <= p_col%d_next; \n', i, i);
end
fprintf(fid, 'p_flag_reg <= p_flag_next;\n');
fprintf(fid, 'data_addr_reg <= data_addr_next;\n');
fprintf(fid, 'c_reg <= c_next;\n');
fprintf(fid, 'end if;\n');
fprintf(fid, 'end if;\n');
fprintf(fid, 'end process;\n');
fprintf(fid, '\n');
fprintf(fid,'process(p_flag_reg ');
for j = 3: layers_cnn-1
    fprintf(fid,' , p_row%d, p_col%d,p_row%d_reg, p_col%d_reg ', j,j,j,j);
end
fprintf(fid,') \n');
fprintf(fid, 'begin\n');
fprintf(fid,'if(p_flag_reg = ''1'') then\n');
for j = i: layers_cnn-1
    fprintf(fid,'\t p_row%d_next <= p_row%d; \n', j,j);
    fprintf(fid,'\t p_col%d_next <= p_col%d; \n', j,j);
end
fprintf(fid,'else \n');
for j = i: layers_cnn-1
    fprintf(fid,'\t p_row%d_next <= p_row%d_reg; \n', j,j);
    fprintf(fid,'\t p_col%d_next <= p_col%d_reg; \n', j,j);
end
fprintf(fid,'end if; \n');
fprintf(fid,'end process; \n');
fprintf(fid, 'process (condition0, condition1, c_reg, rst_red, data_zero1_reg, data_zero2_reg, p_flag_reg, col2, padding_row2, padding_col2, zero_reg, zero2_reg, address_next, count_layer_next, address_reg, address2_reg, data_out_reg, conv1_col_reg, conv1_row_reg, pool2_row_reg, row_reg, col_reg, data_in, count_layer_reg, col_next, row_next, first_reg, state_reg, address2_next, data_addr_reg ');
cont = 1;
for i = layer +1 : layers_cnn - 1
    fprintf(fid,', sum_row%d,', i);
    fprintf(fid,' sum_col%d,', i);
    fprintf(fid,' stride%d', cont);
    fprintf(fid, ', p_row%d', i);
    fprintf(fid, ', p_col%d', i);
    fprintf(fid, ', conv%d_col', i);
    fprintf(fid, ', conv%d_fila', i);
    fprintf(fid, ', pool%d_col', i + 1);
    fprintf(fid, ', pool%d_fila', i + 1);
    cont = cont + 1;
end
for i = layer + 2 : layers_cnn - 1
    fprintf(fid, ',  p_row%d_reg', i);
    fprintf(fid, ',  p_col%d_reg', i);
end
fprintf(fid, ')\n');
fprintf(fid, 'begin\n');
fprintf(fid, 'data_addr_next <= data_addr_reg;\n');
fprintf(fid, 'state_next <= state_reg;\n');
fprintf(fid, 'col_next <= col_reg;\n');
fprintf(fid, 'row_next <= row_reg;\n');
fprintf(fid, 'conv1_col_next <= conv1_col_reg;\n');
fprintf(fid, 'conv1_row_next <= conv1_row_reg;\n');
fprintf(fid, 'p_flag_next <= p_flag_reg;\n');
fprintf(fid, 'count_layer_next <= count_layer_reg;\n');
fprintf(fid, '--pool2_col_next <= pool2_col_reg;\n');
fprintf(fid, 'pool2_row_next <= pool2_row_reg;\n');
fprintf(fid, 'address_next <= address_reg;\n');
fprintf(fid, 'address2_next <= address2_reg;\n');
fprintf(fid, 'first_next <= first_reg;\n');
fprintf(fid, 'data_out_next <= data_out_reg;\n');
fprintf(fid, 'zero_next <= zero_reg;\n');
fprintf(fid, 'zero2_next <= zero2_reg;\n');
fprintf(fid, 'data_zero1_next <= data_zero1_reg;\n');
fprintf(fid, 'data_zero2_next <= data_zero2_reg;\n');
fprintf(fid,'sum_row%d <= unsigned(stride%d * p_row%d);\n', layer + 1,1,layer + 1);
fprintf(fid,'sum_col%d <=unsigned(stride%d * p_col%d);\n', layer + 1,1,layer + 1);
cont = 2;
for i = layer + 2 : layers_cnn -1
    fprintf(fid,'sum_row%d <= unsigned(stride%d * p_row%d_reg);\n', i,cont,i);
    fprintf(fid,'sum_col%d <=unsigned(stride%d * p_col%d_reg);\n', i,cont,i);
    cont = cont + 1;
end
fprintf(fid, 'c_next <= c_reg;\n');
fprintf(fid,'condition0 <= ''0'';\n');
fprintf(fid,'condition1 <= ''0'';\n');
fprintf(fid,' case state_reg is \n');
fprintf(fid,' when idle =>  \n');
fprintf(fid, 'col_next <= (others => ''0'');\n');
fprintf(fid, 'row_next <= (others => ''0'');\n');
fprintf(fid, 'data_zero1_next <= ''0'';\n');
fprintf(fid, 'data_zero2_next <= ''0'';\n');
fprintf(fid, 'conv1_col_next <= (others => ''0'');\n');
fprintf(fid, 'conv1_row_next <= (others => ''0'');\n');
fprintf(fid, 'count_layer_next <= (others => ''0'');\n');
fprintf(fid, '--pool2_col_next <= (others => ''0'');\n');
fprintf(fid, 'pool2_row_next <= (others => ''0'');\n');
fprintf(fid, 'address_next <= (others => ''0'');\n');
fprintf(fid, 'address2_next <= (others => ''0'');\n');
fprintf(fid, 'zero_next <= ''0'';\n');
fprintf(fid, 'zero2_next <= ''0'';\n');
fprintf(fid, 'first_next <= ''0'';\n');
fprintf(fid, 'data_out_next <= ''0'';\n');
fprintf(fid, 'state_next <= s_wait;\n');
fprintf(fid, 'p_flag_next <= ''0'';\n');
fprintf(fid, 'data_addr_next <= ''0'';\n');
fprintf(fid, 'when s_wait => \n\n');
fprintf(fid, '     data_out_next <= ''0'';\n');
fprintf(fid, '     data_zero1_next <= ''0'';\n');
fprintf(fid, '     data_zero2_next <= ''0'';\n');
fprintf(fid, ' if(data_in = ''1'') then   --We calculate the direction of the memory we need at each stage\n');
fprintf(fid, '    p_flag_next <= ''1'';\n');
fprintf(fid, '    state_next <= s0;\n');
fprintf(fid, ' end if;\n');
fprintf(fid, ' if(rst_red = ''1'') then\n');
fprintf(fid, '    state_next <= idle;\n');
fprintf(fid, ' end if;\n');
fprintf(fid, 'when s0 =>\n');
fprintf(fid,'if((padding_row%d = ''0'' and padding_col%d = ''0''))then \n', layer + 1, layer + 1 );
fprintf(fid,'condition0 <= ''1'';\n');
fprintf(fid,'else\n');
fprintf(fid,'condition0 <= ''0'';\n');
fprintf(fid,'end if;\n');
fprintf(fid,'if((padding_row%d = ''1'' or padding_col%d = ''1'')) then\n',layer + 1, layer + 1 );
fprintf(fid,'condition1 <= ''1'';\n');
fprintf(fid,'else\n');
fprintf(fid,'condition1 <= ''0'';\n');
fprintf(fid,'end if;\n');
fprintf(fid, '    p_flag_next <= ''0'';\n');
fprintf(fid, '    if(first_reg = ''0'') then\n');
if(padding == 1)
    fprintf(fid, '        first_next <= ''1'';\n');
    fprintf(fid, '        state_next <= s1;\n');
    fprintf(fid, '        zero_next <= ''1'';\n');
else
    fprintf(fid, '        first_next <= ''1'';\n');
    fprintf(fid, '        state_next <= s1;\n');
    fprintf(fid, '        zero_next <= ''0'';\n');
end

fprintf(fid, '    else\n');
fprintf(fid, '        if (conv1_col_reg /= conv1_column - 1) then\n');
fprintf(fid, '            col_next <= col_reg + loop_columns1_1;\n');
fprintf(fid, '            conv1_col_next <= conv1_col_reg + 1;\n');
fprintf(fid, '        else\n');
fprintf(fid, '            conv1_col_next <= (others => ''0'');\n');
fprintf(fid, '            if (conv1_row_reg /= (conv1_row - 1)) then\n');
fprintf(fid, '                col_next <= col_reg - loop_columns1_2;\n');
fprintf(fid, '                row_next <= row_reg + loop_rows1_1;\n');
fprintf(fid, '                conv1_row_next <= conv1_row_reg + 1;\n');
fprintf(fid, '            else\n');
fprintf(fid, '                conv1_row_next <= (others => ''0'');\n');
fprintf(fid, '                if(count_layer_reg /= number_of_layers1 - 1) then\n');
fprintf(fid, '                    col_next <= col_reg - loop_columns1_2;\n');
fprintf(fid, '                    row_next <= row_reg - loop_rows1_2;\n');
fprintf(fid, '                    count_layer_next <= count_layer_reg + 1;\n');
fprintf(fid, '                else\n');
fprintf(fid, '                    count_layer_next <= (others => ''0'');\n');
if(parallelism_layer1 == 0)
    fprintf(fid, 'if (pool2_col_reg /= (pool2_column - 1)) then\n');
    fprintf(fid, 'col_next <= col_reg - loop_columns1_3;\n');
    fprintf(fid, 'row_next <= row_reg - loop_rows1_2;\n');
    fprintf(fid, 'pool2_col_next <= pool2_col_reg + 1;\n');
    fprintf(fid, 'else\n');
    fprintf(fid, 'pool2_col_next <= (others => ''0'');\n');
end
fprintf(fid, '                    if (pool2_row_reg /= (pool2_row - 1)) then\n');
fprintf(fid, '                        col_next <= col_reg - loop_columns1_4;\n');
fprintf(fid, '                        row_next <= row_reg - loop_rows1_3;\n');
fprintf(fid, '                        pool2_row_next <= pool2_row_reg + 1;\n');
fprintf(fid, '                    else\n');
fprintf(fid, '                        pool2_row_next <= (others => ''0'');\n');
fprintf(fid, '              if(padding_col%d = ''1'' and padding_row%d = ''1'') then\n', layer + 1, layer + 1);
fprintf(fid, '                 row_next <= (others => ''0'');\n');
fprintf(fid, '                 col_next <= (others => ''0'');\n');
fprintf(fid, '              else\n');
fprintf(fid, '                 if((conv%d_col /= 0) and (padding_col%d = ''0'')) then\n', layer + 1, layer + 1);
fprintf(fid, '                    row_next <= row_reg - loop_rows%d_4;\n', layer);
fprintf(fid, '                    col_next <= col_reg - loop_columns%d_5;\n', layer);
fprintf(fid, '                 else\n');
fprintf(fid, '                    if(((conv%d_fila /= 0 and padding_col%d = ''0'') or (padding_col%d = ''1'' and conv%d_fila /= 0)) and padding_row%d = ''0'') then\n', layer + 1, layer + 1, layer + 1, layer + 1, layer + 1);
fprintf(fid, '                         row_next <= row_reg - loop_rows%d_5;\n', layer);
fprintf(fid, '                         col_next <= col_reg - loop_columns%d_6 + sum_col%d;\n', layer, layer + 1);
fprintf(fid, '                    else\n');
fprintf(fid, '                         if((pool%d_col /= 0) and (condition0 = ''1'')) or ((condition1 = ''1'') and (pool%d_col /= 0)) then\n', layer + 2, layer + 2);
fprintf(fid, '                            row_next <= row_reg - loop_rows%d_6 + sum_row%d;\n', layer, layer + 1);
fprintf(fid, '                            col_next <= col_reg - loop_columns%d_7 + sum_col%d;\n', layer , layer + 1);
fprintf(fid, '                         else\n');
fprintf(fid, '                            if(((pool%d_fila /= 0) and (condition0 = ''1'')) or ((condition1 = ''1'') and ((pool%d_col = 0) and (pool%d_fila /= 0)))) then\n', layer + 2, layer + 2, layer + 2);
fprintf(fid, '                               row_next <= row_reg - loop_rows%d_7 + sum_row%d;\n', layer, layer + 1);
fprintf(fid, '                               col_next <= col_reg - loop_columns%d_8 + sum_col%d;\n', layer, layer + 1);
cont_col = 9;
cont_row = 8;
for i = layer + 2 : layers_cnn - 1
    fprintf(fid, 'else\n');
    fprintf(fid, '\tif (((conv%d_col /= 0 ) and (padding_col%d = ''0'')) or (padding_col%d = ''1'' and conv%d_col > p_col%d)) then\n', i, layer + 1, layer + 1, i, i);
    fprintf(fid, '\t\tcol_next <= col_reg - loop_columns1_%d ', cont_col);
    for j = layer + 2  : i - 2
        fprintf(fid, '+ sum_col%d ', j);
    end
    fprintf(fid, ' + sum_col%d; \n', i - 1);
    fprintf(fid, '\t\trow_next <= row_reg - loop_rows1_%d ', cont_row);
    for j = layer + 2  : i - 2
        fprintf(fid, '+ sum_row%d ', j);
    end
    fprintf(fid, ' + sum_row%d; \n', i - 1);
    cont_col= cont_col +1;
    cont_row = cont_row + 1;
    fprintf(fid, '\telse\n');
    fprintf(fid, '\t\tif (((conv%d_fila /= 0 ) and (padding_row%d = ''0'')) or (padding_row%d = ''1'' and conv%d_fila > p_row%d)) then\n', i, layer + 1, layer + 1, i, i);
    fprintf(fid, '\t\t\tcol_next <= col_reg - loop_columns1_%d ', cont_col);
    for j = layer + 2  : i - 2
        fprintf(fid, '+ sum_col%d ', j);
    end
    fprintf(fid, ' + sum_col%d + sum_col%d; \n', i - 1, i);
    fprintf(fid, '\t\t\trow_next <= row_reg - loop_rows1_%d ', cont_row);
    for j = layer + 2  : i - 2
        fprintf(fid, '+ sum_row%d ', j);
    end
    fprintf(fid, ' + sum_row%d; \n', i - 1);
    cont_col= cont_col +1;
    cont_row = cont_row + 1;
    fprintf(fid, '\t\telse\n');
    fprintf(fid, '\t\t\tif ((pool%d_col /= 0 and(condition0 = ''1'')) or ((condition1 = ''1'') and (pool%d_col /= 0)))  then\n', i +1, i +1);
    fprintf(fid, '\t\t\t\tcol_next <= col_reg - loop_columns1_%d ', cont_col);
    for j = layer + 2  : i - 2
        fprintf(fid, '+ sum_col%d ', j);
    end
    fprintf(fid, ' + sum_col%d + sum_col%d; \n', i - 1, i);
    fprintf(fid, '\t\t\t\trow_next <= row_reg - loop_rows1_%d ', cont_row);
    for j = layer + 2  : i - 2
        fprintf(fid, '+ sum_row%d ', j);
    end
    fprintf(fid, ' + sum_row%d + sum_row%d; \n', i - 1, i);
    fprintf(fid, '\t\t\telse\n');
    cont_col= cont_col +1;
    cont_row = cont_row + 1;
    fprintf(fid, '\t\t\t\tif (((pool%d_fila/= 0) and (condition0 = ''1'')) or ((condition1 = ''1'') and ((pool%d_col = 0) and (pool%d_fila /= 0))))  then\n',i +1, i +1, i+1);
    fprintf(fid, '\t\t\t\t\tcol_next <= col_reg - loop_columns1_%d ', cont_col);
    for j = layer + 2  : i - 2
        fprintf(fid, '+ sum_col%d ', j);
    end
    fprintf(fid, ' + sum_col%d + sum_col%d; \n', i - 1, i);
    fprintf(fid, '\t\t\t\t\trow_next <= row_reg - loop_rows1_%d ', cont_row);
    for j = layer + 2  : i - 2
        fprintf(fid, '+ sum_row%d ', j);
    end
    fprintf(fid, ' + sum_row%d + sum_row%d; \n', i - 1, i);
    cont_col= cont_col +1;
    cont_row = cont_row + 1;
end
fprintf(fid, '\t\t\t\telse\n');
fprintf(fid, '\t\t\t\t\tif ((col_reg /= (column_limit%d - 1 ', layer);
if (parallelism_layer1 == 1)
    fprintf(fid, ' - stride1_et1 ');
end
fprintf(fid, ')) or (col%d > conv%d_padding)) then\n', layer + 1, layer + 1);
fprintf(fid, '\t\t\t\t\t\tcol_next <= col_reg - loop_columns1_%d ', cont_col);
for j = layer + 1  : layers_cnn - 1
    fprintf(fid, '+ sum_col%d ', j);
end
fprintf(fid, ' ; \n');
fprintf(fid, '\t\t\t\t\t\trow_next <= row_reg - loop_rows1_%d ', cont_row);
for j = layer + 1  : layers_cnn - 1
    fprintf(fid, '+ sum_row%d ', j);
end
fprintf(fid, ' ; \n');
fprintf(fid, '\t\t\t\t\telse\n');
cont_row = cont_row + 1;
fprintf(fid, '\t\t\t\t\t\t\trow_next <= row_reg - loop_rows1_%d ', cont_row);
for j = layer + 1  : layers_cnn - 1
    fprintf(fid, '+ sum_row%d ', j);
end
fprintf(fid, ' ; \n');
fprintf(fid, '\t\t\t\t\t\tcol_next <= (others => ''0'');\n');
fprintf(fid, '\t\t\t\t\t\tif(row_reg = row_limit%d) then\n', layer);
fprintf(fid, '\t\t\t\t\t\t\trow_next <= (others => ''0'');\n');
if(parallelism_layer1 ==1)
    c = 3;
else
    c = 2;
end
for i = c : 12 + 4 * ((layers_cnn - 1) -(layer + 1))
    fprintf(fid,'end if;\n');
end
fprintf(fid, '\tif(padding_row%d /= ''0'') then\n', layer+ 1);
fprintf(fid, '\t\trow_next <= (others => ''0'');\n');
fprintf(fid, '\tend if;\n');
fprintf(fid, '\tif(padding_col%d /= ''0'') then\n', layer+ 1);
fprintf(fid, '\t\tcol_next <= (others => ''0'');\n');
fprintf(fid, '\tend if;\n');
fprintf(fid, 'end if;\n');
fprintf(fid, 'address_next <= col_next + (row_size1 * row_next);\n');
fprintf(fid, 'address2_next <= col_next + (row_size1 * row_next);\n');
fprintf(fid, 'state_next <= s1;\n');
fprintf(fid, 'end if;\n');
fprintf(fid, 'when s1 =>\n');
if(padding == 1)
    fprintf(fid, 'if((conv1_padding > col_reg) or (col_reg >=column_size1 + conv1_padding) or (conv1_padding > row_reg)  or (row_reg >= row_size1 + conv1_padding) ) then\n');
    fprintf(fid, 'zero_next <= ''1'';\n');
    fprintf(fid, 'data_zero1_next <= ''1'';\n');
    fprintf(fid, 'else\n');
    fprintf(fid, 'zero_next <= ''0'';\n');
    fprintf(fid, 'address_next <= address_reg - (conv1_padding + (row_size1 * conv1_padding)) + (count_layer_next & "0000000000");\n');
    fprintf(fid, 'end if;\n');
    fprintf(fid, 'if((conv1_padding > (col_reg + stride1_et1)) or ((col_reg + stride1_et1)  >=column_size1 + conv1_padding) or (conv1_padding > row_reg)  or (row_reg >= row_size1 + conv1_padding) ) then\n');
    fprintf(fid, 'zero2_next <= ''1'';\n');
    fprintf(fid, 'data_zero2_next <= ''1'';\n');
    fprintf(fid, 'else\n');
    fprintf(fid, 'zero2_next <= ''0'';\n');
    fprintf(fid, 'address2_next <= address2_reg - (conv1_padding + (row_size1 * conv1_padding)) + (count_layer_next & "0000000000") + stride1_et1;\n');
    fprintf(fid, 'end if;\n');
else
    fprintf(fid, 'zero_next <= ''0'';\n');
    fprintf(fid, 'address_next <= address_reg - (conv1_padding + (row_size1 * conv1_padding)) + (count_layer_next & "0000000000");\n');
    fprintf(fid, 'zero2_next <= ''0'';\n');
    fprintf(fid, 'address2_next <= address2_reg - (conv1_padding + (row_size1 * conv1_padding)) + (count_layer_next & "0000000000") + stride1_et1;\n');
end
fprintf(fid, 'data_addr_next <= ''1'';\n');
fprintf(fid, 'state_next <= s2;\n');
fprintf(fid, 'when s2 =>\n');
fprintf(fid, 'c_next <= ''1'';\n');
fprintf(fid, 'if(c_reg = ''1'') then\n');
fprintf(fid, 'c_next <= ''0'';\n');
fprintf(fid, 'state_next <= s_wait;\n');
fprintf(fid, 'data_out_next <= ''1'';\n');
fprintf(fid, 'end if;\n');
fprintf(fid, 'data_addr_next <= ''0'';\n');
fprintf(fid,'end case;\n');
fprintf(fid,'end process;\n');

cont = 1;
for i = layer + 1 : layers_cnn -1
    fprintf(fid,'stride%d <= to_unsigned(stride%d_et%d, stride%d_et%d);\n', cont,cont * 2,layer,cont * 2,layer);
    cont = cont + 1;
end
fprintf(fid,'\n');
fprintf(fid, '-- Output signals\n');
fprintf(fid, 'address <= std_logic_vector(address_reg(log2c(number_of_inputs + 1) - 1 downto 0)) when zero_reg = ''0'' else (others => ''0'');\n');
fprintf(fid, 'address2 <= std_logic_vector(address2_reg(log2c(number_of_inputs + 1) - 1 downto 0)) when zero2_reg = ''0'' else (others => ''0'');\n');
fprintf(fid, 'data_out <= data_out_reg;\n');
fprintf(fid, 'zero <= zero_reg;\n');
fprintf(fid, 'zero2 <= zero2_reg;\n');
fprintf(fid, 'data_zero1 <= data_zero1_reg;\n');
fprintf(fid, 'data_zero2 <= data_zero2_reg;\n');
fprintf(fid, 'data_addr <= data_addr_reg;\n');
fprintf(fid, 'end Behavioral;\n');
fclose(fid);
end

