function [] =  Library_System(input_row_size, input_column_size, input_size, n_extra_bits, conv_z, layers_cnn,parallelism_layer1, parallel_data,number_of_neurons, weight_size,fractional_act, fractional_w, conv_row, conv_column, pool_row, pool_column, pool_stride, stride, padding,input_size_FC, layers_fc, biggest_ROM_size, number_of_neurons_FC, fractional_w_fc, integer_w_fc, fractional_act_fc,integer_act_fc, weight_size_Softmax, fractional_act_Softmax, fractional_w_Softmax, integer_sum_sm, fractional_sum_sm, outputsFC)
name = sprintf('CNN_Network/Global/tfg_irene_package.vhd');
fid = fopen(name, 'wt');
fprintf(fid, 'library IEEE;\n');
fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
fprintf(fid, 'package tfg_irene_package is\n');
fprintf(fid, 'function log2c (n: integer) return integer;\n');
fprintf(fid, '--================ NEURAL NETWORK PARAMETERS ================-\n');
fprintf(fid, '--INPUT DATA\n');
fprintf(fid, '\n');
fprintf(fid, 'constant address_limit : integer := %d;                           --Size of the input image\n', input_row_size * input_column_size);
fprintf(fid, 'constant input_row_size : integer := %d;                           --Size of the input image\n', input_row_size);
fprintf(fid, 'constant input_column_size : integer := %d;                           --Size of the input image\n', input_column_size);
fprintf(fid, 'constant n_extra_bits : integer := %d;                               --Number of extra bits used for precision in the MAAC operations\n', n_extra_bits);
fprintf(fid, '--================ CNN PARAMETERS ================-\n');
fprintf(fid, 'constant layers_cnn : integer := %d;                               --Number of layers of the convolutional part of the network\n', layers_cnn);
fprintf(fid, '--LAYER 1\n');
fprintf(fid, '\n');
fprintf(fid, 'constant input_sizeL1: integer := %d;                                 --Number of bits of the input data\n', input_size(1));
fprintf(fid, 'constant number_of_layers1 : integer := %d;                           --Number of layers of the input matrix\n', conv_z(1));
fprintf(fid, 'constant number_of_inputs: integer := input_column_size * input_row_size * number_of_layers1;   --Number of inputs of the layer\n');
fprintf(fid, 'type vector_data_in is array (natural range <>) of std_logic_vector(input_sizeL1 - 1 downto 0);\n');
fprintf(fid, 'type vector_address is array (natural range <>) of std_logic_vector(log2c(number_of_inputs) - 1 downto 0);\n');
fprintf(fid, '--Conv1\n');
fprintf(fid, 'constant parallel_data : integer := %d;                          --Number of data that are calcullated in paralel in the first layer\n', parallel_data);
fprintf(fid, 'constant number_of_neurons1 : integer := %d;                     --Number of neurons in layer 1\n', number_of_neurons(1));
fprintf(fid, 'constant weight_sizeL1: integer := %d;                           --Number of bits of the weight\n', weight_size(1));
fprintf(fid, 'constant fractional_size_L1: integer := %d;                       --Number of bits of the fractional size of the input data\n', fractional_act(1));
fprintf(fid, 'constant w_fractional_sizeL1: integer := %d;                     --Number of bits of the fractional part of the weight\n', fractional_w(1));
fprintf(fid, 'constant conv1_row: integer := %d;                               --Size of the row of the filter\n', conv_row(1));
fprintf(fid, 'constant conv1_column: integer := %d;                            --Size of the column of the filter\n', conv_column(1));
fprintf(fid, 'constant conv1_stride: integer := %d;                            --Stride of the filter\n', stride(1));
fprintf(fid, 'constant conv1_padding: integer := %d;                           --Padding of the filter\n', padding(1));
fprintf(fid, 'constant conv1_size: integer := conv1_row* conv1_column;         --Size of the filter\n');
fprintf(fid, 'constant mult1 : integer := conv1_size * number_of_layers1;      --Number of multiplications in each filter sweep\n');
fprintf(fid, 'constant row_size1 : integer := input_row_size;                   --Size of the row of the input matrix to the layer\n');
fprintf(fid, 'constant column_size1 : integer :=  input_column_size;            --Size of the column of the input matrix to the layer\n');
fprintf(fid, 'constant column_limit1 : integer := column_size1 + ( 2 * conv1_padding);  --Maximum size of the column with padding\n');
fprintf(fid, 'constant row_limit1 : integer := row_size1  +( 2 * conv1_padding);        --Maximum size of the row with padding\n');
fprintf(fid, 'constant n_cycles : integer := 5;                                        --Number of cycles that it taked to acces the memory (two input data)\n');
fprintf(fid, 'constant count1_max : integer := input_sizeL1 - n_cycles;     \n');
fprintf(fid, 'constant output_col_layer1: integer := (column_size1  + ( 2 * conv1_padding) - conv1_column)/conv1_stride + 1; --Size of the column of the input matrix of the layer 1; \n');
fprintf(fid, 'constant output_row_layer1: integer := (row_size1  + ( 2 * conv1_padding) - conv1_row)/conv1_stride + 1; --Size of the row of the input matrix of the layer 1; \n');
fprintf(fid, 'type vector_reluL1 is array (natural range<>) of STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);\n');
for i = 2 : layers_cnn - 1
    fprintf(fid, '\n');
    fprintf(fid, '--LAYER %d\n', i);
    fprintf(fid, '\n');
    fprintf(fid, 'constant input_sizeL%d : integer := %d;                           --Number of bits of the input size in the layer\n', i, input_size(i));
    fprintf(fid, 'constant fractional_size_L%d: integer := %d;                       --Number of bits in the integer part of the input data\n', i, fractional_act(i));
    fprintf(fid, 'constant weight_sizeL%d : integer := %d;                          --Number of bits of the weight in the layer\n', i, weight_size(i));
    fprintf(fid, 'constant w_fractional_sizeL%d: integer := %d;                     --Number of bits in the fractional size of the weights\n',i,fractional_w(i));
    fprintf(fid, 'constant number_of_layers%d : integer := %d;                      --Number of layers of the input matrix\n', i, conv_z(i));
    fprintf(fid, '--Pool%d\n', i);
    if i == 2 && parallelism_layer1 ==1
        fprintf(fid, '--I AM APPLYING PARALLELISM, SO THE SIZE IS DIVIDED BY TWO, IF IT IS ODD I HAVE TO CHANGE IT.\n');
    end
    fprintf(fid, 'constant pool%d_column: integer := %d;                             --Column size of the pool filter\n',i,  pool_column(i));
    fprintf(fid, 'constant pool%d_row: integer := %d;                               --Row size of the pool filter\n',i,  pool_row(i));
    fprintf(fid, 'constant pool%d_stride: integer := %d;                            --Stride of the pool filter\n',i, pool_stride(i));
    if i == 2 && parallelism_layer1 ==1
        fprintf(fid, 'constant pool%d_size : integer := (pool%d_column * pool%d_row)/2;    --Size of the pool filter(It is divided by two because the process is parallelised\n', i, i, i);
    else
        fprintf(fid, 'constant pool%d_size : integer := pool%d_column * pool%d_row;        --Size of the pool filter(It is divided by two because the process is parallelised\n', i, i, i);
    end
    fprintf(fid, 'constant row_size%d: integer := (output_row_layer%d - pool%d_row )/pool%d_stride + 1;        --Row size of the input matrix\n', i, i-1, i, i);
    fprintf(fid, 'constant column_size%d: integer :=(output_col_layer%d- pool%d_row )/pool%d_stride + 1;   --Column size of the input matrix\n', i, i-1, i, i);
    fprintf(fid, 'constant number_of_inputs%d: integer := column_size%d * row_size%d * number_of_layers%d; --Number of inputs in the third layer\n', i, i, i, i);
    fprintf(fid, '--Conv%d\n', i);
    fprintf(fid, 'constant conv%d_row: integer := %d;                               --Size of the row of the filter\n',i, conv_row(i));
    fprintf(fid, 'constant conv%d_column: integer := %d;                            --Size of the column of the filter\n',i, conv_column(i));
    fprintf(fid, 'constant conv%d_stride: integer := %d;                            --Stride of the filter\n',i, stride(i));
    fprintf(fid, 'constant conv%d_padding: integer := %d;                           --Padding of the filter\n',i, padding(i));
    fprintf(fid, 'constant conv%d_size: integer := conv%d_row* conv%d_column;       --Size of the filter\n',i,i,i);
    fprintf(fid, 'constant mult%d : integer := conv%d_size;                                   --Number of multiplications in each filter sweep (withouth taking ito account the layers of the matrix)\n', i, i);
    fprintf(fid, 'constant padding_rows%d : integer := row_size%d + conv%d_padding;           --Size of the rows of the input matriz + padding\n', i, i, i);
    fprintf(fid, 'constant padding_columns%d : integer := column_size%d + conv%d_padding;     --Size of the columns of the input matriz + padding\n', i, i, i);
    fprintf(fid, 'constant column_limit%d : integer := column_size%d + ( 2 * conv%d_padding); --Maximum column size\n', i, i, i);
    fprintf(fid, 'constant row_limit%d : integer := row_size%d  +( 2 * conv%d_padding);       --Maximum row size\n', i, i, i);
    fprintf(fid, 'constant output_col_layer%d: integer := (column_size%d  + ( 2 * conv%d_padding) - conv%d_column)/conv%d_stride + 1; --Size of the column of the input matrix of the layer %d; \n',i, i, i , i , i ,i);
    fprintf(fid, 'constant output_row_layer%d: integer := (row_size%d  + ( 2 * conv%d_padding) - conv%d_row)/conv%d_stride + 1; --Size of the row of the input matrix of the layer %d; \n',i, i , i , i , i ,i);    
    fprintf(fid, 'type vector_reluL%d is array (natural range<>) of STD_LOGIC_VECTOR(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0);\n', i, i, i);
end
fprintf(fid, '\n');
fprintf(fid, '--LAYER %d %d\n', layers_cnn);
fprintf(fid, '\n');
fprintf(fid, 'constant input_sizeL%d : integer := %d;                           --Number of bits of the input size in the layer\n', layers_cnn, input_size(layers_cnn));
fprintf(fid, 'constant fractional_sizeL%d: integer := %d;                       --Number of bits in the integer part of the input data\n', layers_cnn, fractional_act(layers_cnn));
fprintf(fid, 'constant number_of_layers%d : integer := %d;                      --Number of layers of the input matrix\n', layers_cnn, conv_z(layers_cnn));
fprintf(fid, '--Pool%d\n', layers_cnn);
fprintf(fid, 'constant pool%d_column: integer := %d;                            --Column size of the pool filter\n',layers_cnn,  pool_column(layers_cnn - 1));
fprintf(fid, 'constant pool%d_row: integer := %d;                               --Row size of the pool filter\n',layers_cnn,  pool_row(layers_cnn - 1));
fprintf(fid, 'constant pool%d_stride: integer := %d;                            --Stride of the pool filter\n',layers_cnn, pool_stride(layers_cnn - 1));
fprintf(fid, 'constant pool%d_size : integer := pool%d_column * pool%d_row;     --Size of the pool filter(It is divided by two because the process is parallelised\n', layers_cnn, layers_cnn, layers_cnn);
fprintf(fid, 'constant row_size%d: integer := (output_row_layer%d - pool%d_row )/pool%d_stride + 1;            --Row size of the input matrix\n', layers_cnn, layers_cnn-1, layers_cnn, layers_cnn);
fprintf(fid, 'constant column_size%d: integer :=(output_col_layer%d - pool%d_row )/pool%d_stride + 1;       --Column size of the input matrix\n', layers_cnn, layers_cnn-1, layers_cnn,layers_cnn);
fprintf(fid, 'constant number_of_inputs%d: integer := column_size%d * row_size%d * number_of_layers%d; --Number of inputs in the third layer\n', layers_cnn, layers_cnn, layers_cnn, layers_cnn);
fprintf(fid, 'constant result_size : integer := row_size%d * column_size%d;\n', layers_cnn, layers_cnn);
fprintf(fid, '\n');
fprintf(fid, '--Interfaces Parameters\n');
fprintf(fid, '\n');
for j = 1 : layers_cnn - 1
    cont = 1;
    for i = 1 : (layers_cnn - j)
        if i == 1
            fprintf(fid,'constant stride%d_et%d : integer := conv%d_stride;\n', cont, j, (i + (j - 1)));
            cont = cont + 1;
            fprintf(fid,'constant stride%d_et%d : integer := stride%d_et%d * pool%d_stride; \n', cont, j, 1, j,  (i + 1+ (j - 1)));
            cont = cont + 1;
        else
            fprintf(fid,'constant stride%d_et%d : integer := stride%d_et%d * conv%d_stride; \n', cont, j, cont - 1, j, (i + (j - 1)));
            cont = cont + 1;
            fprintf(fid,'constant stride%d_et%d : integer := stride%d_et%d * pool%d_stride; \n', cont, j, cont - 1, j,  (i + 1+ (j - 1)));
            cont = cont + 1;
        end
    end
end
for j = 1 : layers_cnn - 1
    fprintf(fid,'--LOOPS FOR INTERFACE%d\n', j);
    fprintf(fid,'--Columns\n');
    fprintf(fid,'constant loop_columns%d_1 : integer :=  1;\n', j);
    fprintf(fid,'constant loop_columns%d_2 : integer :=  (conv%d_column - 1);\n', j, j);
    cont_stride = 1;
    cont = 3;
    fprintf(fid, 'constant loop_columns%d_%d : integer :=  loop_columns%d_%d - stride%d_et%d ;\n',j, cont, j, cont - 1, cont_stride, j);
    cont = cont + 1;
    if(j == 1 && parallelism_layer1 == 1)
        fprintf(fid, 'constant loop_columns%d_%d : integer :=  loop_columns%d_%d + (stride%d_et%d *(pool%d_column -1 -stride1_et1)) ;\n',j, cont, j, cont - 2,  cont_stride,j, j + 1);
    else
        fprintf(fid, 'constant loop_columns%d_%d : integer :=  loop_columns%d_%d + (stride%d_et%d *(pool%d_column -1)) ;\n',j, cont, j, cont - 2,  cont_stride,j, j + 1);
    end
    cont_stride = cont_stride + 1;
    cont = cont + 1;
    for i = j + 1 : (layers_cnn - 1)
        fprintf(fid, 'constant loop_columns%d_%d : integer :=  loop_columns%d_%d - stride%d_et%d ;\n',j, cont, j, cont - 1, cont_stride, j);
        cont = cont + 1;
        fprintf(fid, 'constant loop_columns%d_%d : integer :=  loop_columns%d_%d + (stride%d_et%d *(conv%d_column-1)) ;\n',j, cont, j, cont - 2,  cont_stride,j, i);
        cont_stride = cont_stride + 1;
        cont = cont + 1;
        fprintf(fid, 'constant loop_columns%d_%d : integer :=  loop_columns%d_%d - stride%d_et%d ;\n',j, cont, j, cont - 1, cont_stride, j);
        cont = cont + 1;
        fprintf(fid, 'constant loop_columns%d_%d : integer :=  loop_columns%d_%d + (stride%d_et%d *(pool%d_column-1)) ;\n',j, cont, j, cont - 2,  cont_stride,j, i + 1);
        cont_stride = cont_stride + 1;
        cont = cont + 1;
    end
    fprintf(fid, 'constant loop_columns%d_%d : integer :=  loop_columns%d_%d - stride%d_et%d ;\n',j, cont, j, cont - 1, cont_stride, j);
    fprintf(fid,'--Rows\n');
    fprintf(fid,'constant loop_rows%d_1 : integer :=  1;\n', j);
    fprintf(fid,'constant loop_rows%d_2 : integer :=  (conv%d_row - 1);\n', j, j);
    cont_stride = 1;
    cont = 3;
    fprintf(fid, 'constant loop_rows%d_%d : integer :=  loop_rows%d_%d - stride%d_et%d ;\n',j, cont, j, cont - 1, cont_stride, j);
    cont = cont + 1;
    fprintf(fid, 'constant loop_rows%d_%d : integer :=  loop_rows%d_%d + (stride%d_et%d *(pool%d_row-1)) ;\n',j, cont, j, cont - 2,  cont_stride,j, j + 1);
    cont_stride = cont_stride + 1;
    cont = cont + 1;
    for i = j + 1 : (layers_cnn - 1)
        fprintf(fid, 'constant loop_rows%d_%d : integer :=  loop_rows%d_%d - stride%d_et%d ;\n',j, cont, j, cont - 1, cont_stride, j);
        cont = cont + 1;
        fprintf(fid, 'constant loop_rows%d_%d : integer :=  loop_rows%d_%d + (stride%d_et%d *(conv%d_row-1)) ;\n',j, cont, j, cont - 2,  cont_stride,j, i);
        cont_stride = cont_stride + 1;
        cont = cont + 1;
        fprintf(fid, 'constant loop_rows%d_%d : integer :=  loop_rows%d_%d - stride%d_et%d ;\n',j, cont, j, cont - 1, cont_stride, j);
        cont = cont + 1;
        fprintf(fid, 'constant loop_rows%d_%d : integer :=  loop_rows%d_%d + (stride%d_et%d *(pool%d_row-1)) ;\n',j, cont, j, cont - 2,  cont_stride,j, i + 1);
        cont_stride = cont_stride + 1;
        cont = cont + 1;
    end
    fprintf(fid, 'constant loop_rows%d_%d : integer :=  loop_rows%d_%d - stride%d_et%d ;\n',j, cont, j, cont - 1, cont_stride, j);
end
for j = 1 : layers_cnn - 2
    for i = 1 : ((layers_cnn - 1) - j)
        fprintf(fid, 'constant bits_sum%d_et%d : integer :=log2c(conv%d_padding) + stride%d_et%d;\n', i, j, j + 1, i * 2,j);
    end
end
fprintf(fid, '\n');
fprintf(fid, '--================ FC PARAMETERS ================-\n');
fprintf(fid, 'constant layers_fc : integer := %d;                                                    -- Numbers of FC layers \n', layers_fc);
fprintf(fid, 'constant biggest_ROM_size : integer := %d;                                             -- Maximum input data (coming from the FC)\n', biggest_ROM_size);
fprintf(fid, 'constant log2_biggest_ROM_size : integer := log2c(biggest_ROM_size); \n');
fprintf(fid, '\n');
for i = 1 : layers_fc - 1
    fprintf(fid, 'constant number_of_neurons_L%dfc : integer := %d;                                        -- Number of neurons in the layer\n', i, number_of_neurons_FC(i));
    fprintf(fid, 'constant input_size_L%dfc : integer := %d;                                               -- Number of bits of the input data of the FC\n', i, input_size_FC(i));
    fprintf(fid, 'constant weight_size_L%dfc : integer := %d;                                                -- Number of bits of the weight of the layer.\n', i, integer_w_fc + fractional_w_fc + 1);
    fprintf(fid, 'constant fractional_size_L%dfc : integer := %d;                                             -- Number of bits of the fractional part of the input data\n',i, fractional_act_fc);
    fprintf(fid, 'constant w_fractional_size_L%dfc : integer := %d;                                           -- Number of bits of the fractional part of the weight\n', i, fractional_w_fc);
    fprintf(fid, 'constant integer_size_L%dfc : integer := input_size_L%dfc - fractional_size_L%dfc;           -- Number of bits of the integer part of the input data\n', i, i,i);
    fprintf(fid, 'constant w_integer_size_L%dfc : integer := weight_size_L%dfc - w_fractional_size_L%dfc;      -- Number of bits of the integerpart of the weight\n', i, i,i);
    if i == 1
        fprintf(fid, 'constant number_of_inputs_L%dfc : integer := %d;                                           -- Number of inputs of the layer\n',i,biggest_ROM_size);
    else
        fprintf(fid, 'constant number_of_inputs_L%dfc : integer := %d;                                           -- Number of inputs of the layer\n',i,number_of_neurons_FC(i-1));
    end
    fprintf(fid, 'constant number_of_outputs_L%dfc : integer := %d;                                             --Number of outputs of the layer\n', i, number_of_neurons_FC(i));
    fprintf(fid, 'type vector_L%dfc is array (natural range <>) of std_logic_vector(input_size_L%dfc-1 downto 0);\n', i, i);
    fprintf(fid, 'type vector_L%dfc_signed is array (natural range <>) of signed(input_size_L%dfc-1 downto 0);\n', i, i);
    fprintf(fid, 'type vector_L%dfc_activations is array (natural range <>) of std_logic_vector(input_size_L%dfc +weight_size_L%dfc +n_extra_bits-1 downto 0);\n', i, i, i);
end
fprintf(fid, '\n');
fprintf(fid, '--Softmax layer\n');
fprintf(fid, '\n');
fprintf(fid, 'constant number_of_inputs_L%dfc : integer := %d;                                           -- Number of inputs of the softmax layer\n', layers_fc,outputsFC);
fprintf(fid, 'constant input_size_L%dfc : integer := %d;                                                 -- Number of bits of the input data to the softmax layer\n',layers_fc, input_size_FC(end));
fprintf(fid, 'constant weight_size_L%dfc : integer := %d;                                                -- Number of bits of the weights of the softmax layer\n', layers_fc, weight_size_Softmax);
fprintf(fid, 'constant fractional_size_L%dfc : integer := %d;                                            -- Number of bits of the fractional part of the input data\n',layers_fc, fractional_act_Softmax);
fprintf(fid, 'constant integer_size_L%dfc : integer := input_size_L%dfc - fractional_size_L%dfc;         -- Number of bits of the integer part of the input data\n', layers_fc, layers_fc,layers_fc);
fprintf(fid, 'constant w_fractional_size_L%dfc : integer := %d;                                          -- Number of bits for the fractional part of the weight\n', layers_fc, fractional_w_Softmax);
fprintf(fid, 'constant integer_size_sum : integer := %d;                                                 -- Number of bits of the sum \n', integer_sum_sm);
fprintf(fid, 'constant fractional_size_sum : integer := %d;                                              -- Number of bits of the fractional part of the sum\n',fractional_sum_sm);
fprintf(fid, 'constant number_of_outputs_L%dfc : integer := %d;                                          -- Number of outputs of the softmax layer\n',  layers_fc, outputsFC);
fprintf(fid, 'type vector_sm is array (natural range <>) of std_logic_vector(input_size_L%dfc - 1 downto 0);\n',layers_fc);
fprintf(fid, 'type vector_sm_signed is array (natural range <>) of signed(input_size_L%dfc-1 downto 0);\n', layers_fc);
fprintf(fid, '   type output_t is array (0 to 9) of std_logic_vector (31 downto 0);\n');
fprintf(fid, '\n');
fprintf(fid, 'end package tfg_irene_package;\n');
fprintf(fid, 'package body tfg_irene_package is\n');
fprintf(fid, 'function log2c(n:integer) return integer is\n');
fprintf(fid, '	   variable m, p: integer;\n');
fprintf(fid, '	begin\n');
fprintf(fid, '	   m:=0;\n');
fprintf(fid, '	   p:= 1;\n');
fprintf(fid, '	   while p<n loop\n');
fprintf(fid, '	       m := m+1;\n');
fprintf(fid, '	       p := p*2;\n');
fprintf(fid, '	   end loop;\n');
fprintf(fid, '	   return m;\n');
fprintf(fid, '	end log2c;\n');
fprintf(fid, 'end package body;\n');
fclose(fid);
end

