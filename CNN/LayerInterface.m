% This function generates the generator of the computation of the directions for each layer
% INPUTS
% Layer of the Interface
% Number of layers of the network
function [] = LayerInterface(layer, layers_cnn, padding,padding_conv)
name = sprintf('CNN_Network/CNN/Interfaz_ET%d.vhd', layer);
fid = fopen(name, 'wt');
fprintf(fid, '--------------------INTERFACE LAYER %d----------------------\n', layer );
fprintf(fid, '--This module indicates the position of the filters to calculate the data we need in the input matrix\n');
fprintf(fid, '--INPUTS\n');
fprintf(fid, '--p_rowx, p_colx : signals indicating the amount of padding that affects each of the convolutional filter architecture\n');
fprintf(fid, '--padding_col, padding_row : signals indicating whether the column/row position will be miscalculated due to padding\n');
fprintf(fid, '--data_in : signal indicating the need to compute a new data in this layer\n');
fprintf(fid, '--poolx_col : signal indicating the position of the columns of the filter pool of the following layerst\n');
fprintf(fid, '--poolx_row : signal indicating the position of the rows of the filter pool of the following layers\n');
fprintf(fid, '--convx_col : signal indicating the position of the columns of the convolution filter of the following layer\n');
fprintf(fid, '--convx_row : signal indicating the position of the rows of the convolution filter of the following layer\n');
fprintf(fid, '--OUTPUTS\n');
fprintf(fid, '--poolx_col : signal indicating the position of the columns of the filter pool of the current layerst\n');
fprintf(fid, '--poolx_row : signal indicating the position of the rows of the filter pool of the current layers\n');
fprintf(fid, '--convx_col : signal indicating the position of the columns of the convolution filter of the current layer\n');
fprintf(fid, '--convx_row : signal indicating the position of the rows of the convolution filter of the current layer\n');
fprintf(fid, '--zero,: signal that is kept at 1 or zero depending if the data to process is in padding zone or not, it is passed to a multiplexer at the input of the par2ser converter.\n');
fprintf(fid, '--dato_out : signal indicating if a new data is needed, it is passed to the generator of the previous layer.\n');
fprintf(fid, '--data_zero : signals to indicate that the data to be processed is a zero from the padding zone\n');
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
fprintf(fid, '      zero : out std_logic;\n');
fprintf(fid, '      data_zero : out std_logic;\n');
fprintf(fid, '      data_out : out std_logic;\n');
if(layer  ~= layers_cnn - 1)
    fprintf(fid, '      padding_col%d : in std_logic;\n',layer + 1);
    fprintf(fid, '      padding_row%d : in std_logic;\n',layer + 1);
    fprintf(fid, '      col%d : in unsigned(log2c(column_size%d + 2*(conv%d_padding)) - 1 downto 0);\n',layer + 1,layer + 1,layer + 1);
end
for i = layer + 1 : layers_cnn -1
    fprintf(fid, '      p_row%d: in unsigned( log2c(conv%d_padding) downto 0); \n',i,i);
    fprintf(fid, '      p_col%d : in unsigned( log2c(conv%d_padding) downto 0);  \n',i,i);
    fprintf(fid, '      conv%d_col : in unsigned(log2c(conv%d_column) - 1 downto 0);\n', i, i);
    fprintf(fid, '      conv%d_fila : in  unsigned(log2c(conv%d_row) - 1 downto 0);\n', i, i);
    fprintf(fid, '      pool%d_col : in unsigned(log2c(pool%d_column) - 1 downto 0);\n', i + 1, i + 1);
    fprintf(fid, '      pool%d_fila : in  unsigned(log2c(pool%d_row) - 1 downto 0);\n', i + 1, i + 1);
end
fprintf(fid, '      padding_col%d : out std_logic;\n',layer);
fprintf(fid, '      padding_row%d : out std_logic;\n', layer);
fprintf(fid, '      col%d : out unsigned(log2c(column_size%d + 2*(conv%d_padding)) - 1 downto 0);\n', layer, layer, layer);
fprintf(fid, '      p_row%d: out unsigned( log2c(conv%d_padding) downto 0); \n', layer, layer);
fprintf(fid, '      p_col%d : out unsigned( log2c(conv%d_padding) downto 0);  \n', layer, layer);
fprintf(fid,'       conv%d_col : out unsigned(log2c(conv%d_column) - 1 downto 0);\n', layer, layer);
fprintf(fid,'       conv%d_fila : out  unsigned(log2c(conv%d_row) - 1 downto 0);\n', layer, layer);
fprintf(fid,'       pool%d_col : out unsigned(log2c(pool%d_column) - 1 downto 0);\n', layer+1, layer+1);
fprintf(fid,'       pool%d_fila : out  unsigned(log2c(pool%d_row) - 1 downto 0));\n', layer+1, layer+1);
fprintf(fid,'end Interfaz_ET%d;\n', layer);
fprintf(fid,'architecture Behavioral of Interfaz_ET%d is\n', layer);
fprintf(fid,'type state_type is (idle , s_wait, s0, s1,s2);\n');
fprintf(fid,'signal state_reg, state_next : state_type;\n');
if(padding_conv(layer - 1) == 0)
    fprintf(fid,'signal p_col_aux : unsigned(log2c(column_size%d) - 1 downto 0);\n',layer);
    fprintf(fid,'signal p_row_aux: unsigned(log2c(row_size%d) - 1 downto 0);\n', layer);
else
    fprintf(fid,'signal p_col_aux : unsigned(log2c(column_size%d) downto 0);\n',layer);
    fprintf(fid,'signal p_row_aux: unsigned(log2c(row_size%d) downto 0);\n', layer);
end

fprintf(fid,'signal p_row_reg, p_row_next : unsigned(log2c(conv%d_padding) downto 0);\n', layer);
fprintf(fid,'signal p_col_reg, p_col_next : unsigned(log2c(conv%d_padding) downto 0);\n', layer);
fprintf(fid,'signal col_reg, col_next : unsigned(log2c(column_size%d + 2*(conv%d_padding))  downto 0) := (others => ''0'');\n', layer, layer);
fprintf(fid,'signal row_reg, row_next :  unsigned(log2c(row_size%d + 2*(conv%d_padding))  downto 0) := (others => ''0'');\n', layer, layer);
fprintf(fid,'signal c_col_reg, c_col_next, c_row_reg, c_row_next, flag_reg, flag_next ');
if layers_cnn > 4
    fprintf(fid, ', p_flag_reg, p_flag_next');
end
fprintf(fid,': std_logic := ''0'';\n');
cont = 1;
for i = layer + 1 : layers_cnn -1
    fprintf(fid,'signal sum_row%d, sum_col%d : unsigned(bits_sum%d_et%d  downto 0) := (others => ''0'');\n', i,i,cont, layer);
    cont = cont + 1;
end
fprintf(fid,'--Layer %d\n', layer);
fprintf(fid,'signal conv%d_col_reg, conv%d_col_next : unsigned(log2c(conv%d_column) - 1 downto 0) := (others => ''0'');\n', layer , layer, layer);
fprintf(fid,'signal conv%d_row_reg, conv%d_row_next : unsigned(log2c(conv%d_row) - 1 downto 0) := (others => ''0'');\n', layer, layer, layer);
fprintf(fid,'-- Layer %d\n', layer + 1);
fprintf(fid,'signal pool%d_col_reg, pool%d_col_next : unsigned(log2c(pool%d_column) - 1 downto 0) := (others => ''0'');\n', layer + 1, layer + 1,layer + 1);
fprintf(fid,'signal pool%d_row_reg, pool%d_row_next : unsigned(log2c(pool%d_row) - 1 downto 0) := (others => ''0'');\n', layer + 1, layer + 1,layer + 1);
fprintf(fid,'\n');
fprintf(fid,'--Registers\n');
fprintf(fid,'signal condition0, condition1,first_reg, first_next, zero_reg, zero_next, data_zero_reg, data_zero_next, data_out_reg, data_out_next ');
fprintf(fid,' : std_logic;\n');
for i = layer + 2 : layers_cnn -1
    fprintf(fid,'signal  p_row%d%d_reg, p_row%d%d_next : unsigned(log2c(conv%d_padding) downto 0);\n',layer, i,layer,i,i);
    fprintf(fid,'signal  p_col%d%d_reg, p_col%d%d_next : unsigned(log2c(conv%d_padding) downto 0);\n',layer, i,layer,i,i);
end
c = 1;
for i = layer + 1 : layers_cnn -1
    fprintf(fid,'signal stride%d : unsigned(stride%d_et%d - 1  downto 0);\n', c ,c * 2,layer);
    c = c+1;
end
fprintf(fid,'begin\n');
fprintf(fid,'process(clk) \n');
fprintf(fid,'begin \n');
fprintf(fid,'if (clk''event and clk = ''1'') then \n');
fprintf(fid,'\t if (rst = ''0'') then \n');
fprintf(fid,'\t \t state_reg <= idle;\n');
fprintf(fid,'\t else\n');
fprintf(fid,'\t\t state_reg <= state_next; \n');
fprintf(fid,'\t\t col_reg <= col_next; \n');
fprintf(fid,'\t\t row_reg <= row_next; \n');
fprintf(fid,'\t\t pool%d_col_reg <= pool%d_col_next; \n', layer + 1, layer + 1);
fprintf(fid,'\t\t pool%d_row_reg <= pool%d_row_next; \n', layer + 1, layer + 1);
fprintf(fid,'\t\t conv%d_col_reg <= conv%d_col_next; \n', layer, layer);
fprintf(fid,'\t\t conv%d_row_reg <= conv%d_row_next; \n', layer, layer);
for i = layer + 2 : layers_cnn -1
    fprintf(fid, '\t\tp_row%d%d_reg <= p_row%d%d_next;\n',layer, i,layer, i);
    fprintf(fid, '\t\tp_col%d%d_reg <= p_col%d%d_next;\n',layer, i,layer, i);
end
fprintf(fid,'\t\t p_row_reg <= p_row_next; \n');
fprintf(fid,'\t\t p_col_reg <= p_col_next; \n');
fprintf(fid,'\t\t first_reg <= first_next; \n');
fprintf(fid,'\t\t zero_reg <= zero_next; \n');
fprintf(fid,'\t\t c_col_reg <= c_col_next; \n');
fprintf(fid,'\t\t c_row_reg <= c_row_next; \n');
fprintf(fid,'\t\t data_out_reg <= data_out_next;\n');
fprintf(fid,'\t\t data_zero_reg <= data_zero_next; \n');
fprintf(fid,'\t\t flag_reg <= flag_next; \n');
if layers_cnn > 4
    fprintf(fid,'\t\t p_flag_reg <= p_flag_next; \n');
end
fprintf(fid,'\t end if; \n');
fprintf(fid,'end if; \n');
fprintf(fid,'end process; \n');
if layers_cnn > 4 && layer < layers_cnn - 2
    fprintf(fid, 'process(p_flag_reg, p_row3, p_col3 ');
    for i = layer + 2 : layers_cnn -1
        fprintf(fid, ', p_row%d, p_col%d, p_row%d%d_reg, p_col%d%d_reg ',i,i,layer, i,layer, i);
    end
    fprintf(fid,')\n');
    fprintf(fid, 'begin\n');
    fprintf(fid, '\tif(p_flag_reg = ''1'') then\n');
    for i = layer + 2 : layers_cnn -1
        fprintf(fid, '\t\tp_row%d%d_next <= p_row%d;\n',layer, i, i);
        fprintf(fid, '\t\tp_col%d%d_next <= p_col%d;\n',layer, i, i);
    end
    fprintf(fid, '\telse\n');
    for i = layer + 2 : layers_cnn -1
        fprintf(fid, '\t\tp_row%d%d_next <= p_row%d%d_reg;\n',layer, i,layer, i);
        fprintf(fid, '\t\tp_col%d%d_next <= p_col%d%d_reg;\n',layer, i,layer, i);
    end
    fprintf(fid, '\tend if;\n');
    fprintf(fid, 'end process;\n');
end
fprintf(fid, ' process ( rst_red,condition0, condition1, data_zero_reg, data_out_reg, flag_reg, zero_next,zero_reg, state_reg, first_reg, data_in, p_col_next, p_row_next, p_row_reg, p_col_reg,p_row_aux, p_col_aux, c_col_reg, c_row_reg, col%d, padding_col%d, padding_row%d, conv%d_col_reg, conv%d_row_reg, conv%d_row_next, conv%d_col_next, pool%d_col_reg, pool%d_row_reg, pool%d_col_next, pool%d_row_next,  row_reg, col_reg, col_next, row_next ', layer+1, layer+1,layer+1, layer, layer, layer, layer, layer+1,  layer+1, layer+1,layer+1);
c = 1;
for i = layer +1 : layers_cnn - 1
    fprintf(fid,', sum_row%d', i);
    fprintf(fid,', sum_col%d', i);
    fprintf(fid,', stride%d', c);
    fprintf(fid,', p_row%d', i);
    fprintf(fid,', p_col%d', i);
    fprintf(fid,', conv%d_col', i);
    fprintf(fid,', conv%d_fila', i);
    fprintf(fid,', pool%d_col', i + 1);
    fprintf(fid,', pool%d_fila', i + 1);
    c = c + 1;
end
for i = layer + 2 : layers_cnn - 1
    fprintf(fid, ', p_row%d%d_reg',layer, i);
    fprintf(fid, ', p_col%d%d_reg',layer, i);
end
if layers_cnn > 4
    fprintf(fid,', p_flag_reg');
end
fprintf(fid,')\n');
fprintf(fid,'begin\n');
fprintf(fid,'\t state_next <= state_reg;\n');
fprintf(fid,'\t col_next <= col_reg;\n');
fprintf(fid,'\t row_next <= row_reg;\n');
fprintf(fid,'\t p_col_next <= p_col_reg;\n');
fprintf(fid,'\t p_row_next <= p_row_reg;\n');
fprintf(fid,'\t conv%d_col_next <= conv%d_col_reg;\n', layer, layer );
fprintf(fid,'\t conv%d_row_next <= conv%d_row_reg;\n', layer, layer);
fprintf(fid,'\t pool%d_col_next <= pool%d_col_reg;\n', layer + 1, layer + 1);
fprintf(fid,'\t pool%d_row_next <= pool%d_row_reg;\n', layer + 1, layer + 1);
fprintf(fid,'\t first_next <= first_reg;\n');
fprintf(fid,'\t zero_next <= zero_reg;\n');
fprintf(fid,'\t c_col_next <= c_col_reg;\n');
fprintf(fid,'\t c_row_next <= c_row_reg;\n');
fprintf(fid,'\t p_row_aux <= (others => ''0'');\n');
fprintf(fid,'\t p_col_aux <= (others => ''0'');\n');
fprintf(fid,'\t flag_next <= flag_reg;\n');
fprintf(fid,'condition0 <= ''0'';\n');
fprintf(fid,'condition1 <= ''0'';\n');
if layers_cnn > 4
    fprintf(fid,'\t p_flag_next <= p_flag_reg;\n');
end
fprintf(fid,'\t data_zero_next <= ''0'';\n');
fprintf(fid,'\t data_out_next <= ''0'';\n');
fprintf(fid,'sum_row%d <= unsigned(stride%d * p_row%d);\n', layer + 1,1,layer + 1);
fprintf(fid,'sum_col%d <=unsigned(stride%d * p_col%d);\n', layer + 1,1,layer + 1);
cont = 2;
for i = layer + 2 : layers_cnn -1
    fprintf(fid,'sum_row%d <= unsigned(stride%d * p_row%d%d_reg);\n', i,cont,layer,i);
    fprintf(fid,'sum_col%d <=unsigned(stride%d * p_col%d%d_reg);\n', i,cont,layer,i);
    cont = cont + 1;
end

fprintf(fid,' case state_reg is \n');
fprintf(fid, 'when idle =>\n');
fprintf(fid, '\tcol_next <= (others => ''0'');\n');
fprintf(fid, '\trow_next <= (others => ''0'');\n');
fprintf(fid,'\t conv%d_col_next <= (others => ''0'');\n', layer);
fprintf(fid,'\t conv%d_row_next  <= (others => ''0'');\n', layer);
fprintf(fid,'\t pool%d_col_next  <= (others => ''0'');\n', layer + 1);
fprintf(fid,'\t pool%d_row_next  <= (others => ''0'');\n', layer + 1);
fprintf(fid, '\tp_row_aux <= (others => ''0'');\n');
fprintf(fid, '\tp_col_aux <= (others => ''0'');\n');
fprintf(fid, '\tp_row_next <= (others => ''0'');\n');
fprintf(fid, '\tp_col_next <= (others => ''0'');\n');
fprintf(fid, '\tfirst_next <= ''1'';\n');
fprintf(fid, '\tstate_next <= s_wait;\n');
fprintf(fid, '\tdata_out_next <= ''0'';\n');
fprintf(fid, '\tdata_zero_next <= ''0'';\n');
fprintf(fid, '\tzero_next <= ''0'';\n');
fprintf(fid, '\tc_col_next <= ''0'';\n');
fprintf(fid, '\tc_row_next <= ''0'';\n');
fprintf(fid, '\tflag_next <= ''0'';\n');
if layers_cnn > 4
    fprintf(fid, '\tp_flag_next <= ''0'';\n');
end
fprintf(fid, 'when s_wait =>\n');
if(padding == 1)
    fprintf(fid, '\t-- Calculation of padding columns and rows in the filter window being calculated\n');
    fprintf(fid, '\t-- Columns\n');
    fprintf(fid, '\tif(flag_reg = ''1'') then\n');
    fprintf(fid, '\t\tif(conv%d_padding >= col_reg and conv%d_col_reg /= 0) then\n', layer, layer);
    fprintf(fid, '\t\t\tp_col_next <= conv%d_col_reg(log2c(conv%d_padding) downto 0 );\n', layer, layer);
    fprintf(fid, '\t\telsif(col_reg + (conv%d_column - 1) >= padding_columns%d) then\n', layer, layer);
    fprintf(fid, '\t\t\tp_col_aux <= (col_reg + conv%d_column) - padding_columns%d;\n', layer, layer);
    fprintf(fid, '\t\t\tp_col_next <= p_col_aux(log2c(conv%d_padding) downto 0);\n', layer);
    fprintf(fid, '\t\telse\n');
    fprintf(fid, '\t\t\tp_col_next <= (others => ''0'');\n');
    fprintf(fid, '\t\tend if;\n');
    fprintf(fid, '\t-- Rows\n');
    fprintf(fid, '\tif(conv%d_padding >= row_reg and conv%d_row_reg /= 0) then\n', layer, layer);
    fprintf(fid, '\t\tp_row_next <= conv%d_row_reg(log2c(conv%d_padding) downto 0 );\n', layer, layer);
    fprintf(fid, '\telsif(row_reg + (conv%d_row - 1) >= padding_rows%d) then\n', layer, layer);
    fprintf(fid, '\t\tp_row_aux <= (row_reg + conv%d_row) - padding_rows%d;\n', layer, layer);
    fprintf(fid, '\t\tp_row_next <= p_row_aux(log2c(conv%d_padding) downto 0);\n', layer);
    fprintf(fid, '\telse\n');
    fprintf(fid, '\t\tp_row_next <= (others => ''0'');\n');
    fprintf(fid, '\tend if;\n');
    fprintf(fid, 'end if;\n');
else
    fprintf(fid, '\t\tp_row_next <= (others => ''0'');\n');
    fprintf(fid, '\t\t\tp_col_next <= (others => ''0'');\n');
end
fprintf(fid, 'data_out_next <= ''0'';\n');
fprintf(fid, 'data_zero_next <= ''0'';\n');
fprintf(fid, 'c_col_next <= ''0'';\n');
fprintf(fid, 'c_row_next <= ''0'';\n');
fprintf(fid, 'if(data_in = ''1'') then\n');
if layers_cnn > 4
    fprintf(fid,'\t \t p_flag_next <= ''1'';\n');
end
fprintf(fid, '\tstate_next <= s0;\n');
fprintf(fid, '\tflag_next <= ''0'';\n');
fprintf(fid, 'end if;\n');
fprintf(fid, 'if(rst_red = ''1'') then\n');
fprintf(fid, '\tstate_next <= idle;\n');
fprintf(fid, 'end if;\n');
fprintf(fid,'when s0 => \n');
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
if layers_cnn > 4
    fprintf(fid,'\t \t p_flag_next <= ''0'';\n');
end
fprintf(fid,'if(first_reg = ''1'') then\n');
if(padding == 1)
    fprintf(fid,'   first_next <= ''0'';\n');
    fprintf(fid,'   zero_next <= ''1'';\n');
    fprintf(fid,'   data_out_next <= ''0'';\n');
    fprintf(fid,'   data_zero_next <= ''1'';\n');
else
    fprintf(fid,'   first_next <= ''0'';\n');
    fprintf(fid,'   zero_next <= ''0'';\n');
    fprintf(fid,'   data_out_next <= ''1'';\n');
    fprintf(fid,'   data_zero_next <= ''0'';\n');
end
fprintf(fid,'else\n');
fprintf(fid,'  if (conv%d_col_reg /= conv%d_column - 1) then   --If the filter sweep has not finished running through the colums, we add one to the columns.\n', layer, layer);
fprintf(fid,'     col_next <= col_reg + loop_columns%d_1;\n', layer);
fprintf(fid,'     conv%d_col_next <= conv%d_col_reg + 1;\n', layer, layer);
fprintf(fid,'  else\n');
fprintf(fid,'     conv%d_col_next <= (others => ''0'');\n', layer);
fprintf(fid,'     if (conv%d_row_reg /= (conv%d_row - 1)) then      --If the filter sweep  has not finished running trhough the rows, we add one to the row and return the original value to the columns.\n', layer, layer);
fprintf(fid,'        col_next <= col_reg - loop_columns%d_2;\n',layer);
fprintf(fid,'        row_next <= row_reg + loop_rows%d_1;\n',layer);
fprintf(fid,'        conv%d_row_next <= conv%d_row_reg + 1;\n',layer,layer);
fprintf(fid,'     else\n');
fprintf(fid,'        conv%d_row_next <= (others => ''0''); \n', layer);
fprintf(fid,'        if (pool%d_col_reg /= pool%d_column - 1) then\n', layer + 1, layer + 1);
fprintf(fid,'           row_next <= row_reg - loop_rows%d_2;\n',layer);
fprintf(fid,'           col_next <= col_reg - loop_columns%d_3;\n',layer);
fprintf(fid,'           pool%d_col_next <= pool%d_col_reg + 1;\n', layer + 1, layer + 1);
fprintf(fid,'        else\n');
fprintf(fid,'           pool%d_col_next <= (others => ''0'');\n',layer + 1);
fprintf(fid,'           if (pool%d_row_reg /= (pool%d_row - 1)) then \n', layer+1, layer+1);
fprintf(fid,'               row_next <= row_reg - loop_rows%d_3;\n', layer);
fprintf(fid,'               col_next <= col_reg - loop_columns%d_4;  \n',layer);
fprintf(fid,'               pool%d_row_next <= pool%d_row_reg + 1; \n', layer + 1, layer + 1);
fprintf(fid,'           else\n');
fprintf(fid,'               pool%d_row_next <= (others => ''0'');\n', layer + 1);
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
fprintf(fid, '                         if((pool%d_col /= 0) and (condition0 = ''1'')) or ((condition1 = ''1'') and  (pool%d_col /= 0)) then\n', layer + 2, layer + 2);
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
    fprintf(fid, '\t\tcol_next <= col_reg - loop_columns%d_%d ',layer, cont_col);
    for j = layer + 2  : i - 2
        fprintf(fid, '+ sum_col%d ', j);
    end
    fprintf(fid, ' + sum_col%d; \n', i - 1);
    fprintf(fid, '\t\trow_next <= row_reg - loop_rows%d_%d ',layer, cont_row);
    for j = layer + 2  : i - 2
        fprintf(fid, '+ sum_row%d ', j);
    end
    fprintf(fid, ' + sum_row%d; \n', i - 1);
    cont_col= cont_col +1;
    cont_row = cont_row + 1;
    fprintf(fid, '\telse\n');
    fprintf(fid, '\t\tif (((conv%d_fila /= 0 ) and (padding_row%d = ''0'')) or (padding_row%d = ''1'' and conv%d_fila > p_row%d)) then\n', i, layer + 1, layer + 1, i, i);
    fprintf(fid, '\t\t\tcol_next <= col_reg - loop_columns%d_%d ',layer, cont_col);
    for j = layer + 2  : i - 2
        fprintf(fid, '+ sum_col%d ', j);
    end
    fprintf(fid, ' + sum_col%d + sum_col%d; \n', i - 1, i);
    fprintf(fid, '\t\t\trow_next <= row_reg - loop_rows%d_%d ',layer,cont_row);
    for j = layer + 2  : i - 2
        fprintf(fid, '+ sum_row%d ', j);
    end
    fprintf(fid, ' + sum_row%d; \n', i - 1);
    cont_col= cont_col +1;
    cont_row = cont_row + 1;
    fprintf(fid, '\t\telse\n');
    fprintf(fid, '\t\t\tif ((pool%d_col /= 0 and(condition0 = ''1'')) or ((condition1 = ''1'') and (pool%d_col /= 0)))  then\n', i +1, i +1);
    fprintf(fid, '\t\t\t\tcol_next <= col_reg - loop_columns%d_%d ',layer, cont_col);
    for j = layer + 2  : i - 2
        fprintf(fid, '+ sum_col%d ', j);
    end
    fprintf(fid, ' + sum_col%d + sum_col%d + ; \n', i - 1, i);
    fprintf(fid, '\t\t\t\trow_next <= row_reg - loop_rows%d_%d ',layer, cont_row);
    for j = layer + 2  : i - 2
        fprintf(fid, '+ sum_row%d ', j);
    end
    fprintf(fid, ' + sum_row%d + sum_row%d; \n', i - 1, i);
    fprintf(fid, '\t\t\telse\n');
    cont_col= cont_col +1;
    cont_row = cont_row + 1;
    fprintf(fid, '\t\t\t\tif (((pool%d_fila/= 0) and (condition0 = ''1'')) or ((condition1 = ''1'') and ((pool%d_col = 0) and (pool%d_fila /= 0))))  then\n',i +1, i +1, i+1);
    fprintf(fid, '\t\t\t\t\tcol_next <= col_reg - loop_columns%d_%d ',layer, cont_col);
    for j = layer + 2  : i - 2
        fprintf(fid, '+ sum_col%d ', j);
    end
    fprintf(fid, ' + sum_col%d + sum_col%d + ; \n', i - 1, i);
    fprintf(fid, '\t\t\t\t\trow_next <= row_reg - loop_rows%d_%d ',layer, cont_row);
    for j = layer + 2  : i - 2
        fprintf(fid, '+ sum_row%d ', j);
    end
    fprintf(fid, ' + sum_row%d + sum_row%d; \n', i - 1, i);
    cont_col= cont_col +1;
    cont_row = cont_row + 1;
end
fprintf(fid, '\t\t\t\telse\n');
fprintf(fid, '\t\t\t\t\tif ((col_reg /= (column_limit%d - 1)) or (col%d > conv%d_padding)) then\n', layer, layer + 1, layer + 1);
fprintf(fid, '\t\t\t\t\t\tcol_next <= col_reg - loop_columns%d_%d ',layer, cont_col);
for j = layer + 1  : layers_cnn - 1
    fprintf(fid, '+ sum_col%d ', j);
end
fprintf(fid, ' ; \n');
fprintf(fid, '\t\t\t\t\t\trow_next <= row_reg - loop_rows%d_%d ',layer, cont_row);
for j = layer + 1  : layers_cnn - 1
    fprintf(fid, '+ sum_row%d ', j);
end
fprintf(fid, ' ; \n');
fprintf(fid, '\t\t\t\t\telse\n');
cont_row = cont_row + 1;
fprintf(fid, '\t\t\t\t\t\t\trow_next <= row_reg - loop_rows%d_%d ',layer, cont_row);
for j = layer + 1  : layers_cnn - 1
    fprintf(fid, '+ sum_row%d ', j);
end
fprintf(fid, ' ; \n');
fprintf(fid, '\t\t\t\t\t\tcol_next <= (others => ''0'');\n');
fprintf(fid, '\t\t\t\t\t\tif(row_reg = row_limit%d) then\n', layer);
fprintf(fid, '\t\t\t\t\t\t\trow_next <= (others => ''0'');\n');
for i = 2 : 12 + 4 * ((layers_cnn - 1) -(layer + 1))
    fprintf(fid,'end if;\n');
end
fprintf(fid, '\tif(padding_row%d /= ''0'') then\n', layer+ 1);
fprintf(fid, '\t\trow_next <= (others => ''0'');\n');
fprintf(fid, '\tend if;\n');
fprintf(fid, '\tif(padding_col%d /= ''0'') then\n', layer+ 1);
fprintf(fid, '\t\tcol_next <= (others => ''0'');\n');
fprintf(fid, '\tend if;\n');
fprintf(fid, 'end if;\n');
fprintf(fid, 'state_next <= s1;\n');
fprintf(fid, 'when s1 =>\n');
if(padding == 1)
    fprintf(fid, '\tif( (col_reg >= conv%d_padding) and (col_reg < padding_columns%d ) and (row_reg  >= conv%d_padding) and (row_reg < padding_rows%d )) then\n', layer, layer, layer, layer);
    fprintf(fid, '\t\tif(row_reg = conv%d_padding) then --To indicate when the new padding values should be calculated (when a window starts or the filter leave the padding zone).\n', layer);
    fprintf(fid, '\t\t\tif(zero_reg = ''1'') then\n');
    fprintf(fid, '\t\t\t\tflag_next <= ''1'';\n');
    fprintf(fid, '\t\t\tend if;\n');
    fprintf(fid, '\t\t\tc_row_next <= ''1''; --Control signals indicating whether columns or rows in this filter window are affected by padding, so that the previous step corrects the address calculation.\n');
    fprintf(fid, '\t\tend if;\n');
    fprintf(fid, '\t\tif(col_reg = conv%d_padding) then\n', layer);
    fprintf(fid, '\t\t\tif(zero_reg = ''1'' and conv%d_row_reg = 0) then\n', layer);
    fprintf(fid, '\t\t\t\tflag_next <= ''1'';\n');
    fprintf(fid, '\t\t\tend if;\n');
    fprintf(fid, '\t\t\tc_col_next <= ''1'';\n');
    fprintf(fid, '\t\tend if;\n');
    fprintf(fid, '\t\tif(conv%d_row_reg = 0 and conv%d_col_reg = 0) then\n', layer, layer);
    fprintf(fid, '\t\t\tflag_next <= ''1'';\n');
    fprintf(fid, '\t\tend if;\n');
    fprintf(fid, '\t\tdata_out_next <= ''1'';\n');
    fprintf(fid, '\t\tdata_zero_next <= ''0'';\n');
    fprintf(fid, '\t\tzero_next <= ''0'';\n');
    fprintf(fid, '\telse\n');
    fprintf(fid, '\t\tdata_out_next <= ''0'';\n');
    fprintf(fid, '\t\tdata_zero_next <= ''1'';\n');
    fprintf(fid, '\t\tzero_next <= ''1'';\n');
    fprintf(fid, '\tend if;\n');
else
    fprintf(fid, '\t\tdata_out_next <= ''1'';\n');
    fprintf(fid, '\t\tdata_zero_next <= ''0'';\n');
    fprintf(fid, '\t\tzero_next <= ''0'';\n');
end
fprintf(fid, '\tstate_next <= s2;\n');
fprintf(fid, 'when s2 =>\n');
fprintf(fid, '\tstate_next <= s_wait;\n');
fprintf(fid, 'end case;\n');
fprintf(fid, 'end process;\n');
fprintf(fid,'\n');
cont = 1;
for i = layer + 1 : layers_cnn -1
    fprintf(fid,'stride%d <= to_unsigned(stride%d_et%d, stride%d_et%d);\n', cont,cont * 2,layer,cont * 2,layer);
    cont = cont + 1;
end
fprintf(fid,'\n');
fprintf(fid, '-- Output signals\n');
fprintf(fid, 'col%d <= col_reg(log2c(column_size%d + 2*(conv%d_padding)) - 1 downto 0);\n', layer,layer,layer);
fprintf(fid, 'conv%d_col <= conv%d_col_reg;\n', layer, layer);
fprintf(fid, 'conv%d_fila <= conv%d_row_reg;\n', layer, layer);
fprintf(fid, 'pool%d_col <= pool%d_col_reg;\n', layer + 1, layer + 1);
fprintf(fid, 'pool%d_fila <= pool%d_row_reg;\n', layer + 1, layer + 1);
fprintf(fid, 'zero <= zero_reg;\n');
fprintf(fid, 'p_col%d <= p_col_reg;\n', layer);
fprintf(fid, 'p_row%d <= p_row_reg;\n', layer);
fprintf(fid, 'padding_col%d <= c_col_reg;\n', layer);
fprintf(fid, 'padding_row%d <= c_row_reg;\n', layer);
fprintf(fid, 'data_out <= data_out_reg;\n');
fprintf(fid, 'data_zero <= data_zero_reg;\n');
fprintf(fid, 'end Behavioral;\n');
fclose(fid);
end

