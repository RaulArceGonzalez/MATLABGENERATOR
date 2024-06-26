% This function generates the module for the CNN part of the network
% INPUTS
% Z dimensions of the convolutional kernels of the network
% Number of layers of the network
% Number of neurons per layer
% Indicates if there is parallelism in layer 1
function [] = CNN(conv_z, number_of_neurons, parallelism_layer1, layers_cnn,riscv, activations)
name = sprintf('CNN_Network/CNN/CNN_network.vhd');
fid = fopen(name, 'wt');
fprintf(fid, '-----------------------------------CNN NETWORK-------------------------------------\n');
fprintf(fid, '--THIS SYSTEM CORRESPONDS TO A CONVOLUTIONAL NEURAL NETWORK WITH DIMENSIONS TO BE SPECIFIED IN THE LIBRARY\n');
fprintf(fid, '--INPUTS\n');
fprintf(fid, '--start_red : start the processing of data\n');
fprintf(fid, '--data_in : data to be processed from the memory\n');
fprintf(fid, '--data_fc : signals that a new data has been processed by the FC network\n');
fprintf(fid, '\n');
fprintf(fid, '--OUTPUTS\n');
fprintf(fid, '--data_ready: signal indicating that a data is available on the network\n');
fprintf(fid, '--data_out: data processed by the last layer of the neuron\n');
fprintf(fid, '--address : address to be sent to the memory\n');
fprintf(fid, '\n');
fprintf(fid, 'library IEEE;\n');
fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use IEEE.MATH_REAL.ALL; \n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
fprintf(fid, 'entity CNN_red is\n');
fprintf(fid, '        Port (\n');
fprintf(fid, '            clk : in STD_LOGIC;\n');
fprintf(fid, '            rst : in STD_LOGIC;\n');
fprintf(fid, '            rst_red : in std_logic;\n');
fprintf(fid, '            start_red : in std_logic;\n');
if(riscv == 0)
    fprintf(fid, '            data_in : in std_logic_vector(input_sizeL1 - 1 downto 0);\n');
else
    fprintf(fid, '            data_in : in std_logic_vector(31 downto 0);\n');
end
fprintf(fid, '            data_fc : in std_logic;\n');
fprintf(fid, '            data_ready : out std_logic;\n');
fprintf(fid, '            address : out STD_LOGIC_VECTOR(log2c(number_of_inputs) - 1 downto 0 );\n');
fprintf(fid, '            data_out : out STD_LOGIC_VECTOR(input_size_L1fc - 1 downto 0)\n');
fprintf(fid, '        );\n');
fprintf(fid, 'end CNN_red;\n');
fprintf(fid, 'architecture Behavioral of CNN_red is\n');
fprintf(fid, 'component Reg_data\n');
fprintf(fid, 'Port (\n');
fprintf(fid, '      clk : in std_logic;\n');
fprintf(fid, '      rst : in std_logic;\n');
fprintf(fid, '      data_addr : in std_logic;\n');
fprintf(fid, '      data_red : in std_logic;\n');
fprintf(fid, '      address_in : in vector_address(0 to parallel_data - 1);\n');
fprintf(fid, '      address_out : out std_logic_vector(log2c(number_of_inputs) - 1 downto 0 );\n');
if(riscv == 0)
    fprintf(fid, '        data_in : in std_logic_vector(input_sizeL1 - 1 downto 0);\n');
else
    fprintf(fid, '        data_in : in STD_LOGIC_VECTOR(31 downto 0);\n');
end
fprintf(fid, '      data_out : out vector_data_in(0 to parallel_data - 1));\n');
fprintf(fid, 'end component;\n\n');

fprintf(fid, 'component PAR2SER\n');
fprintf(fid, ' generic (input_size : integer := 8);\n');
fprintf(fid, '    Port ( clk : in std_logic;\n');
fprintf(fid, '           rst : in std_logic;\n');
fprintf(fid, '           data_in : in std_logic_vector (input_size-1 downto 0);\n');
fprintf(fid, '           en_neuron : in std_logic;\n');
fprintf(fid, '           bit_select : in unsigned( log2c(input_size) - 1   downto 0);\n');
fprintf(fid, '           bit_out : out std_logic);\n');
fprintf(fid, 'end component;\n\n');

fprintf(fid, 'component VOT_PAR2SER\n');
        fprintf(fid, '\t Port (\n');
        for a = 1 : 3
        fprintf(fid, '\t\t serial_out_%d : in STD_LOGIC;\n',a);
        end
        fprintf(fid, '\t\t serial_out_v : out STD_LOGIC);\n');
        fprintf(fid, 'end component;\n');

if(activations(2) == 1)
    fprintf(fid, 'component MAXPOOL_LAYER2\n');
    fprintf(fid, 'Port (clk : in std_logic;\n');
    fprintf(fid, '      rst : in std_logic;\n');
    fprintf(fid, '      index : in std_logic;\n');
    fprintf(fid, '      data_in : in std_logic_vector(input_sizeL1 - 1 downto 0);\n');
    fprintf(fid, '      data_in2 : in std_logic_vector(input_sizeL1  - 1 downto 0);\n');
    fprintf(fid, '      data_out : out std_logic_vector(input_sizeL1  - 1 downto 0));\n');
    fprintf(fid, 'end component;\n\n');

    fprintf(fid, 'component VOT_MAXPOOL_LAYER2\n');
    fprintf(fid, 'Port (\n');
    for x = 1 : 3
        fprintf(fid, '      data_out_%d : in std_logic_vector(input_sizeL1  - 1 downto 0);\n',x);
    end
    fprintf(fid, '      data_out_v : out std_logic_vector(input_sizeL1  - 1 downto 0));\n');
    fprintf(fid, 'end component;\n\n');

else
    fprintf(fid, 'component MAXPOOL_LAYER2\n');
    fprintf(fid, 'Port (clk : in std_logic;\n');
    fprintf(fid, '      rst : in std_logic;\n');
    fprintf(fid, '      index : in std_logic;\n');
    fprintf(fid, '      data_in : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);\n');
    fprintf(fid, '      data_in2 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);\n');
    fprintf(fid, '      data_out : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));\n');
    fprintf(fid, 'end component;\n\n');

    fprintf(fid, 'component VOT_MAXPOOL_LAYER2\n');
    fprintf(fid, 'Port (\n');
    for x = 1 : 3
        fprintf(fid, '      data_out_%d : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);\n',x);
    end
    fprintf(fid, '      data_out_v : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));\n');
    fprintf(fid, 'end component;\n\n');

end
for i = 3 : layers_cnn 
    if(activations(i) == 1)
        fprintf(fid, 'component MAXPOOL_L%d\n',i);
        fprintf(fid, ' generic (\n input_size : integer := 8; \n weight_size : integer := 8);\n');
        fprintf(fid, 'Port (clk : in STD_LOGIC;\n');
        fprintf(fid, '      rst : in STD_LOGIC;\n');
        fprintf(fid, '      next_data_pool : in STD_LOGIC;\n');
        fprintf(fid, '      index : STD_LOGIC;\n');
        fprintf(fid, '      data_in : in STD_LOGIC_VECTOR(input_size  - 1 downto 0);\n');
        fprintf(fid, '      data_out : out STD_LOGIC_VECTOR(input_size - 1 downto 0));\n');
        fprintf(fid, 'end component;\n');
        fprintf(fid, 'component VOT_MAXPOOL_L%d\n',i);
        fprintf(fid, ' generic (\n input_size : integer := 8; \n weight_size : integer := 8);\n');
        fprintf(fid, 'Port ( \n');
        for x = 1: 3
            fprintf(fid, '      data_out_%d : in STD_LOGIC_VECTOR(input_size - 1 downto 0);\n',x);
        end
        fprintf(fid, '      data_out_v : out STD_LOGIC_VECTOR(input_size - 1 downto 0));\n');
        fprintf(fid, 'end component;\n');

    else
        fprintf(fid, 'component MAXPOOL_L%d\n',i);
        fprintf(fid, ' generic (\n input_size : integer := 8; \n weight_size : integer := 8);\n');
        fprintf(fid, 'Port (clk : in STD_LOGIC;\n');
        fprintf(fid, '      rst : in STD_LOGIC;\n');
        fprintf(fid, '      next_data_pool : in STD_LOGIC;\n');
        fprintf(fid, '      index : STD_LOGIC;\n');
        fprintf(fid, '      data_in : in STD_LOGIC_VECTOR(input_size + weight_size + n_extra_bits - 1 downto 0);\n');
        fprintf(fid, '      data_out : out STD_LOGIC_VECTOR(input_size + weight_size + n_extra_bits - 1 downto 0));\n');
        fprintf(fid, 'end component;\n');

        fprintf(fid, 'component VOT_MAXPOOL_L%d\n',i );
        fprintf(fid, ' generic (\n input_size : integer := 8; \n weight_size : integer := 8);\n');
        fprintf(fid, 'Port ( \n');
        for x = 1: 3
            fprintf(fid, 'data_out_%d : in STD_LOGIC_VECTOR(input_size + weight_size + n_extra_bits - 1 downto 0);\n',x);
        end
        fprintf(fid, 'data_out_v : out STD_LOGIC_VECTOR(input_size + weight_size + n_extra_bits - 1 downto 0));\n');
        fprintf(fid, 'end component;\n');

    end
end
fprintf(fid, '--Layer 1\n');
fprintf(fid, 'component GEN1\n');
fprintf(fid, 'Port (clk : in std_logic;\n');
fprintf(fid, '      rst : in std_logic;\n');
fprintf(fid, '      rst_red : in std_logic;\n');
fprintf(fid, '      data_in : in std_logic;\n');
fprintf(fid, '      data_zero1 : in std_logic;\n');
fprintf(fid, '      data_zero2 : in std_logic;\n');
fprintf(fid, '      count : out unsigned( log2c(input_sizeL1)-1   downto 0);\n');
fprintf(fid, '      mul: out std_logic_vector(log2c(mult1) - 1 downto 0);\n');
fprintf(fid, '      en_neuron : out std_logic;\n');
fprintf(fid, '      data_out1: out std_logic;\n');
fprintf(fid, '      data_out2 : out std_logic;\n');
fprintf(fid, '      next_pipeline_step : out std_logic);\n');
fprintf(fid, 'end component;\n');

fprintf(fid, 'component VOT_GEN1\n');
        fprintf(fid, '\t Port (\n');
        for b = 1 : 3
        fprintf(fid, '\t\t en_neuron_%d : in std_logic;\n',b);
        fprintf(fid, '\t\t count_%d : in unsigned( log2c(input_sizeL1)-1   downto 0);\n',b);
        fprintf(fid, '\t\t mul_%d: in std_logic_vector(log2c(mult1) - 1 downto 0);\n',b);
        fprintf(fid, '\t\t dato_out1_%d: in std_logic; \n',b);
        fprintf(fid, '\t\t dato_out2_%d : in std_logic;\n',b);
        fprintf(fid, '\t\t next_pipeline_step_%d : in std_logic;\n',b);
        end
        fprintf(fid, '\t\t en_neuron_v : out std_logic;\n');
        fprintf(fid, '\t\t count_v : out unsigned( log2c(input_sizeL1)-1   downto 0);\n');
        fprintf(fid, '\t\t mul_v: out std_logic_vector(log2c(mult1) - 1 downto 0);\n');
        fprintf(fid, '\t\t dato_out1_v: out std_logic; \n');
        fprintf(fid, '\t\t dato_out2_v : out std_logic;\n');
        fprintf(fid, '\t\t next_pipeline_step_v : out std_logic);\n');
        fprintf(fid, 'end component;\n');

layer = 1;
fprintf(fid,'COMPONENT INTERFAZ_ET%d \n', layer);
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
fprintf(fid, '       data_out : out std_logic;\n');
fprintf(fid, '       zero : out std_logic;\n');
fprintf(fid, '       zero2 : out std_logic;\n');
fprintf(fid, '       data_zero1 : out std_logic;\n');
fprintf(fid, '       data_zero2 : out std_logic;\n');
fprintf(fid, '       data_addr : out std_logic;\n');
fprintf(fid, '       address : out std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);\n');
fprintf(fid, '       address2 : out std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0));\n');
fprintf(fid,'end COMPONENT;\n');

fprintf(fid, 'component VOT_INTERFAZ_ET%d\n',layer);
        fprintf(fid,'\t Port (\n');
        for e=1 :3
        fprintf(fid,'\t\t dato_out_%d : in std_logic;\n',e);
        fprintf(fid,'\t\t cero_%d : in std_logic;\n',e);
        fprintf(fid,'\t\t cero2_%d : in std_logic;\n',e);
        fprintf(fid,'\t\t dato_cero_%d : in std_logic;\n',e);
        fprintf(fid,'\t\t dato_cero2_%d : in std_logic;\n',e);
        fprintf(fid,'\t\t dato_addr_%d : in std_logic;\n',e);
        fprintf(fid,'\t\t address_%d : in std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);\n',e);
        fprintf(fid,'\t\t address2_%d : in std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);\n',e);
        end
        fprintf(fid,'\t\t dato_out_v : out std_logic;\n');
        fprintf(fid,'\t\t cero_v : out std_logic;\n');
        fprintf(fid,'\t\t cero2_v : out std_logic;\n');
        fprintf(fid,'\t\t dato_cero_v : out std_logic;\n');
        fprintf(fid,'\t\t dato_cero2_v : out std_logic;\n');
        fprintf(fid,'\t\t dato_addr_v : out std_logic;\n');
        fprintf(fid,'\t\t address_v : out std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);\n');
        fprintf(fid,'\t\t address2_v : out std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0));\n');
fprintf(fid,'end component;\n');

for num = 2 : (layers_cnn - 1)


    fprintf(fid, 'component GEN%d\n', num);
    fprintf(fid,' Port ( clk : in STD_LOGIC;\n');
    fprintf(fid,'        rst : in STD_LOGIC;\n');
    fprintf(fid,'        rst_red : in std_logic;\n');
    fprintf(fid,'        data_in : in std_logic;\n');
    fprintf(fid,'        data_zero : in std_logic;\n');
    fprintf(fid,'        count : out unsigned( log2c(input_sizeL%d)-1 downto 0);\n', num);
    fprintf(fid,'        layer : out std_logic_vector(log2c(number_of_layers%d) - 1 downto 0);\n', num);
    fprintf(fid,'        mul: out std_logic_vector(log2c(mult%d) - 1 downto 0);\n', num);
    fprintf(fid,'        data_out1 : out std_logic;\n');
    fprintf(fid,'        data_out2 : out std_logic;\n');
    fprintf(fid,'        index : out std_logic;\n');
    fprintf(fid,'        en_neuron : out std_logic;\n');
    fprintf(fid,'        next_data_pool : out std_logic;\n');
    fprintf(fid,'        next_pipeline_step : out std_logic);\n');
    fprintf(fid, 'end component;\n');

    fprintf(fid, 'component VOT_GEN%d\n', num);
        fprintf(fid, '\t Port (\n');
        for h=1 : 3
        fprintf(fid, '\t\t layer_%d : in std_logic_vector(log2c(number_of_layers%d) - 1 downto 0);\n',h , num);
        fprintf(fid, '\t\t count_%d : in unsigned( log2c(input_sizeL%d)-1 downto 0);\n',h, num);
        fprintf(fid, '\t\t mul_%d: in std_logic_vector(log2c(mult%d) - 1 downto 0);\n',h, num);
        fprintf(fid, '\t\t dato_out1_%d: in std_logic; \n',h);
        fprintf(fid, '\t\t dato_out2_%d : in std_logic;\n',h);
        fprintf(fid, '\t\t index_%d : in std_logic;\n',h);
        fprintf(fid, '\t\t en_neurona_%d : in std_logic;\n',h);
        fprintf(fid, '\t\t next_dato_pool_%d : in std_logic;\n',h);
        fprintf(fid, '\t\t next_pipeline_step_%d : in std_logic;\n',h);
        end
        fprintf(fid, '\t\t layer_v : out std_logic_vector(log2c(number_of_layers%d) - 1 downto 0);\n', num);
        fprintf(fid, '\t\t count_v : out unsigned( log2c(input_sizeL%d)-1 downto 0);\n', num);
        fprintf(fid, '\t\t mul_v: out std_logic_vector(log2c(mult%d) - 1 downto 0);\n', num);
        fprintf(fid, '\t\t dato_out1_v: out std_logic; \n');
        fprintf(fid, '\t\t dato_out2_v : out std_logic;\n');
        fprintf(fid, '\t\t index_v : out std_logic;\n');
        fprintf(fid, '\t\t en_neurona_v : out std_logic;\n');
        fprintf(fid, '\t\t next_dato_pool_v : out std_logic;\n');
        fprintf(fid, '\t\t next_pipeline_step_v : out std_logic);\n');
        fprintf(fid, 'end component;\n');

    fprintf(fid,'component INTERFAZ_ET%d is\n', num);
    fprintf(fid, 'Port (clk : in STD_LOGIC;\n');
    fprintf(fid, '      rst : in STD_LOGIC;\n');
    fprintf(fid, '      rst_red : in std_logic;\n');
    fprintf(fid, '      data_in : in std_logic;\n');
    fprintf(fid, '      zero : out std_logic;\n');
    fprintf(fid, '      data_zero : out std_logic;\n');
    fprintf(fid, '      data_out : out std_logic;\n');
    if(num  ~= layers_cnn - 1)
        fprintf(fid, '      padding_col%d : in std_logic;\n',num + 1);
        fprintf(fid, '      padding_row%d : in std_logic;\n',num + 1);
        fprintf(fid, '      col%d : in unsigned(log2c(column_size%d + 2*(conv%d_padding)) - 1 downto 0);\n',num + 1,num + 1,num + 1);
    end
    for i = num + 1 : layers_cnn -1
        fprintf(fid, '      p_row%d: in unsigned( log2c(conv%d_padding) downto 0); \n',i,i);
        fprintf(fid, '      p_col%d : in unsigned( log2c(conv%d_padding) downto 0);  \n',i,i);
        fprintf(fid, '      conv%d_col : in unsigned(log2c(conv%d_column) - 1 downto 0);\n', i, i);
        fprintf(fid, '      conv%d_fila : in  unsigned(log2c(conv%d_row) - 1 downto 0);\n', i, i);
        fprintf(fid, '      pool%d_col : in unsigned(log2c(pool%d_column) - 1 downto 0);\n', i + 1, i + 1);
        fprintf(fid, '      pool%d_fila : in  unsigned(log2c(pool%d_row) - 1 downto 0);\n', i + 1, i + 1);
    end
    fprintf(fid, '      padding_col%d : out std_logic;\n',num);
    fprintf(fid, '      padding_row%d : out std_logic;\n', num);
    fprintf(fid, '      col%d : out unsigned(log2c(column_size%d + 2*(conv%d_padding)) - 1 downto 0);\n', num, num, num);
    fprintf(fid, '      p_row%d: out unsigned( log2c(conv%d_padding) downto 0); \n', num, num);
    fprintf(fid, '      p_col%d : out unsigned( log2c(conv%d_padding) downto 0);  \n', num, num);
    fprintf(fid,'       conv%d_col : out unsigned(log2c(conv%d_column) - 1 downto 0);\n', num, num);
    fprintf(fid,'       conv%d_fila : out  unsigned(log2c(conv%d_row) - 1 downto 0);\n', num, num);
    fprintf(fid,'       pool%d_col : out unsigned(log2c(pool%d_column) - 1 downto 0);\n', num+1, num+1);
    fprintf(fid,'       pool%d_fila : out  unsigned(log2c(pool%d_row) - 1 downto 0));\n', num+1, num+1);
    fprintf(fid,'end component;\n');

    fprintf(fid, 'component VOT_INTERFAZ_ET%d\n', num);
        fprintf(fid,'\t Port ( \n');
        for m =1 :3
        fprintf(fid,'\t\t dato_out_%d : in std_logic;\n',m);
        fprintf(fid,'\t\t cero_%d : in std_logic;\n',m);
        fprintf(fid,'\t\t dato_cero_%d : in std_logic;\n',m);
        fprintf(fid, '\t\t padding_col%d_%d : in std_logic;\n',num ,m);
        fprintf(fid, '\t\t padding_row%d_%d : in std_logic;\n', num ,m);
        fprintf(fid, '\t\t col%d_%d : in unsigned(log2c(column_size%d + 2*(conv%d_padding)) - 1 downto 0);\n', num,m, num, num);
        fprintf(fid, '\t\t p_row%d_%d: in unsigned( log2c(conv%d_padding) downto 0); \n', num,m, num);
        fprintf(fid, '\t\t p_col%d_%d : in unsigned( log2c(conv%d_padding) downto 0);  \n', num,m, num);
        fprintf(fid,'\t\t conv%d_col_%d : in unsigned(log2c(conv%d_column) - 1 downto 0);\n', num, m, num);
        fprintf(fid,'\t\t conv%d_fila_%d : in  unsigned(log2c(conv%d_row) - 1 downto 0);\n', num, m, num);
        fprintf(fid,'\t\t pool%d_col_%d : in unsigned(log2c(pool%d_column) - 1 downto 0);\n',num+1, m, num+1);
        fprintf(fid,'\t\t pool%d_fila_%d : in  unsigned(log2c(pool%d_row) - 1 downto 0);\n', num+1, m, num+1);
        end
        fprintf(fid,'\t\t dato_out_v : out std_logic;\n');
        fprintf(fid,'\t\t cero_v : out std_logic;\n');
        fprintf(fid,'\t\t dato_cero_v : out std_logic;\n');
        fprintf(fid, '\t\t padding_col%d_v : out std_logic;\n',num);
        fprintf(fid, '\t\t padding_row%d_v : out std_logic;\n', num);
        fprintf(fid, '\t\t col%d_v : out unsigned(log2c(column_size%d + 2*(conv%d_padding)) - 1 downto 0);\n', num, num, num);
        fprintf(fid, '\t\t p_row%d_v: out unsigned( log2c(conv%d_padding) downto 0); \n', num, num);
        fprintf(fid, '\t\t p_col%d_v : out unsigned( log2c(conv%d_padding) downto 0);  \n', num, num);
        fprintf(fid,'\t\t conv%d_col_v : out unsigned(log2c(conv%d_column) - 1 downto 0);\n', num, num);
        fprintf(fid,'\t\t conv%d_fila_v : out  unsigned(log2c(conv%d_row) - 1 downto 0);\n', num, num);
        fprintf(fid,'\t\t pool%d_col_v : out unsigned(log2c(pool%d_column) - 1 downto 0);\n',num+1, num+1);
        fprintf(fid,'\t\t pool%d_fila_v : out  unsigned(log2c(pool%d_row) - 1 downto 0));\n', num+1, num+1);
        fprintf(fid, 'end component;\n');      
        

    fprintf(fid, 'component MUX_%d\n',num);
    fprintf(fid, '\tPort( ');
    for i = 0: conv_z(num) - 1
        fprintf(fid, ' data_in%d : in std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits -1  downto 0); \n', i, num - 1, num - 1);
    end
    fprintf(fid, '  index : in  std_logic_vector(log2c(number_of_layers%d) - 1 downto 0); \n', num);
    fprintf(fid, '  data_out : out std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits -1  downto 0));\n', num -1, num - 1);
    fprintf(fid, 'end component;\n');

    % fprintf(fid, 'component VOT_MUX_%d\n',num);
    %     fprintf(fid, '\t Port( \n');
    %     for d = 1 : 3 
    %     fprintf(fid, '\t\t data_out_%d : in std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits -1  downto 0); \n', d ,num - 1, num - 1);
    %     end
    %     fprintf(fid, '\t\t data_out_v : out std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits -1  downto 0));\n', num - 1, num - 1);
    %     fprintf(fid, 'end component;\n');

end

fprintf(fid, '--Layer %d\n', layers_cnn);
fprintf(fid, 'component GEN%d\n', layers_cnn);
fprintf(fid, 'Port ( clk : in std_logic;\n');
fprintf(fid,'        rst : in std_logic;\n');
fprintf(fid,'        rst_red : in std_logic;\n');
fprintf(fid,'        data_in_fc : in std_logic;\n');
fprintf(fid,'        data_in_cnn : in std_logic;\n');
fprintf(fid,'        data_new : out std_logic;\n');
fprintf(fid,'        layer : out std_logic_vector(log2c(number_of_layers%d) - 1 downto 0);\n', layers_cnn);
fprintf(fid,'        index : out std_logic;\n');
fprintf(fid,'        next_data_pool : out std_logic);\n');
fprintf(fid, 'end component;\n');

fprintf(fid, 'component VOT_GEN%d\n', layers_cnn);
        fprintf(fid, '\t Port (\n');
        for l = 1 : 3
        fprintf(fid, '\t\t dato_new_%d : in std_logic;\n',l);
        fprintf(fid,' \t\t layer_%d : in std_logic_vector(log2c(number_of_layers%d) - 1 downto 0);\n',l, layers_cnn);
        fprintf(fid, '\t\t index_%d : in std_logic;\n',l);
        fprintf(fid, '\t\t next_dato_pool_%d : in std_logic;\n',l);
        end
        fprintf(fid, '\t\t dato_new_v : out std_logic;\n');
        fprintf(fid,' \t\t layer_v : out std_logic_vector(log2c(number_of_layers%d) - 1 downto 0);\n', layers_cnn);
        fprintf(fid, '\t\t index_v : out std_logic;\n');
        fprintf(fid, '\t\t next_dato_pool_v : out std_logic);\n');
        fprintf(fid, 'end component;\n');

fprintf(fid, 'component MUX_%d\n', layers_cnn);
fprintf(fid, '\tPort( \n');
for i = 0: conv_z(layers_cnn) - 1
    fprintf(fid, '\tdata_in%d : in std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits -1  downto 0); \n', i, layers_cnn - 1, layers_cnn - 1 );
end
fprintf(fid, '\t index : in  std_logic_vector(log2c(number_of_layers%d) - 1 downto 0); \n', layers_cnn);
fprintf(fid, '\tdata_out : out std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits -1  downto 0));\n', layers_cnn - 1, layers_cnn - 1);
fprintf(fid, 'end component;\n');

% fprintf(fid, 'component VOT_MUX_%d\n',layers_cnn);
%         fprintf(fid, '\t Port( \n');
%         for d = 1 : 3 
%         fprintf(fid, '\t\t data_out_%d : in std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits -1  downto 0); \n', d ,layers_cnn - 1, layers_cnn - 1);
%         end
%         fprintf(fid, '\t\t data_out_v : out std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits -1  downto 0));\n', layers_cnn - 1, layers_cnn - 1);
%         fprintf(fid, 'end component;\n');

fprintf(fid, '----------NEURONS----------------\n');
if(parallelism_layer1)
    fprintf(fid, '----------PARALLEL NEURONS LAYER 1----------------\n');
    for i = 1 : conv_z(2)
        fprintf(fid, 'component CONVP1%d\n', i);
        fprintf(fid, 'Port ( data_in : in std_logic;\n');
        fprintf(fid, '	     clk : in std_logic;\n');
        fprintf(fid, '	     rst : in std_logic;\n');
        fprintf(fid, '	     next_pipeline_step : in std_logic;\n');
        fprintf(fid,' 	     weight : in signed(weight_sizeL1 - 1 downto 0); \n');
        fprintf(fid, '	     bit_select : in unsigned (log2c(input_sizeL1)-1 downto 0);\n');
        fprintf(fid, '	     data_out : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));\n');
        fprintf(fid, 'end component;\n');

        fprintf(fid, 'component VOT_CONVP1%d\n',i);
        fprintf(fid, 'Port ( \n');
        for x = 1 : 3
            fprintf(fid, '	     data_out_%d : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);\n',x);
        end
        fprintf(fid, '	     data_out_v : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));\n');
        fprintf(fid, 'end component;\n');

    end
end
for num = 1 : (layers_cnn - 1)
    fprintf(fid, '----------NEURONS LAYER %d----------------\n', num);
    for j = 1 : conv_z(num + 1)
        fprintf(fid, 'component CONV%d%d\n', num, j);
        fprintf(fid, '\t Port (data_in : in std_logic;\n');
        fprintf(fid, '\t\t    clk : in std_logic;\n');
        fprintf(fid, '\t\t    rst : in std_logic;\n');
        fprintf(fid, '\t\t    next_pipeline_step : in std_logic;\n');
        if(num == 1)
            fprintf(fid, '\t\t    address : in std_logic_vector(integer(ceil(log2(real(mult1))))  - 1 downto 0);\n');
            fprintf(fid,' \t\t    weight_out : out signed(weight_sizeL%d - 1 downto 0); \n', num);
        else
            fprintf(fid, '\t\t    address : in std_logic_vector(integer(ceil(log2(real(mult%d))))  + integer(ceil(log2(real(number_of_layers%d))))  - 1 downto 0);\n', num, num);
        end
        fprintf(fid, '\t\t    bit_select : in unsigned (log2c(input_sizeL%d)-1 downto 0);\n', num);
        fprintf(fid, '\t\t    data_out : out std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0));\n', num, num);
        fprintf(fid, 'end component;\n');

        fprintf(fid, 'component VOT_CONV%d%d is\n', num, j);
        fprintf(fid, '\t Port (\n');
        if(num == 1)
            for x = 1 : 3
                fprintf(fid,' \t\t    weight_out_%d : in signed(weight_sizeL%d - 1 downto 0); \n',x, num);
            end 
            fprintf(fid,' \t\t    weight_out_v : out signed(weight_sizeL%d - 1 downto 0); \n', num);
        end
        for o = 1 : 3
            fprintf(fid, '\t\t    data_out_%d : in std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0);\n',o, num, num);
        end
        fprintf(fid, '\t\t    data_out_v : out std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0));\n', num, num);
        fprintf(fid, 'end component;\n');

    end
    fprintf(fid, '----------ReLUs----------------\n');
    fprintf(fid, '\n');
    fprintf(fid, 'component RELUL%d\n', num);
    fprintf(fid, '\t Port (clk : in std_logic;\n');
    fprintf(fid, '\t\t    rst : in std_logic;\n');
    fprintf(fid, '\t\t    next_pipeline_step : in std_logic;\n');
    fprintf(fid, '\t\t    index : in std_logic;\n');
    fprintf(fid, '\t\t    data_in : in std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0);\n', num, num);
    fprintf(fid, '\t\t    data_out : out std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0));\n', num, num);
    fprintf(fid, 'end component;\n');

    fprintf(fid, 'component VOT_RELUL%d is\n', num );
    fprintf(fid, '\t Port (\n');
    for x = 1 : 3
        fprintf(fid, '\t\t    data_out_%d : in std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0);\n',x, num, num);
    end
    fprintf(fid, '\t\t    data_out_v : out std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0));\n', num, num);
    fprintf(fid, 'end component;\n');

end
for num = 2 : layers_cnn
    if(activations(num) == 1)

        fprintf(fid, 'component sigmoid_L%d is\n', num);
        fprintf(fid, '\tPort ( \n');
        fprintf(fid, '\t\tdata_in : in std_logic_vector(input_sizeL%d-1 downto 0); \n', num);
        fprintf(fid, '\t\tdata_out : out std_logic_vector(input_sizeL%d-1 downto 0));\n', num);
        fprintf(fid, 'end component;\n');

        fprintf(fid, 'component VOT_sigmoid_L%d is\n', num);
        fprintf(fid, '\tPort ( \n');
        for x = 1 : 3
        fprintf(fid, '\t\tdata_out_%d : in std_logic_vector(input_sizeL%d-1 downto 0);\n',x, num);
        end
        fprintf(fid, '\t\tdata_out_v : out std_logic_vector(input_sizeL%d-1 downto 0));\n', num);
        fprintf(fid, 'end component;\n');

    end
end

fprintf(fid, '--------------AUXILIARY SIGNALS-------------------\n');
fprintf(fid, '--INPUT MEMORY\n');
for b = 1 : 3 
    fprintf(fid, 'signal address_in_%d :  vector_address(0 to parallel_data - 1);\n',b);
end
fprintf(fid, 'signal address_in :  vector_address(0 to parallel_data - 1);\n');
fprintf(fid, '--LAYER 1\n');
fprintf(fid, 'signal data_in_1, data_processed1, data_in_gen1, next_pipeline_step1, next_pipeline_step_aux1, zero1,zero1_2, data_new2, data_new_et2, data_zero1, data_zero21, data_addr, en_neuronL1, data_par2serL1_1, data_par2serL1_2: std_logic;\n');
fprintf(fid, 'signal count1 : unsigned(log2c(input_sizeL1) - 1 downto 0 );\n');
fprintf(fid, 'signal mul1 : std_logic_vector(log2c(mult1) - 1 downto 0);\n');
for b = 1: 3
    fprintf(fid, 'signal  data_processed1_%d, data_in_gen1_%d, next_pipeline_step_aux1_%d, zero111_%d,zero1_2_%d, data_new2_%d, data_new_et2_%d, data_zero1_%d, data_zero21_%d, data_addr_%d, en_neuronL1_%d, data_par2serL1_1_%d, data_par2serL1_2_%d: std_logic;\n',b,b,b,b,b,b,b,b,b,b,b,b,b);
    fprintf(fid, 'signal count1_%d : unsigned(log2c(input_sizeL1) - 1 downto 0 );\n',b);
    fprintf(fid, 'signal mul1_%d : std_logic_vector(log2c(mult1) - 1 downto 0);\n',b);
end
for i = 2 : layers_cnn - 1
    for b = 1 : 3
        fprintf(fid,'signal conv%d_col_%d : unsigned(log2c(conv%d_column) - 1 downto 0);\n', i,b, i);
        fprintf(fid,'signal conv%d_fila_%d : unsigned(log2c(conv%d_row) - 1 downto 0);\n', i,b, i);
        fprintf(fid,'signal pool%d_col_%d : unsigned(log2c(pool%d_column) - 1 downto 0);\n', i+1,b, i+1);
        fprintf(fid,'signal pool%d_fila_%d : unsigned(log2c(pool%d_row) - 1 downto 0);\n', i+1,b, i+1);
        fprintf(fid,'signal p_col%d_%d : unsigned( log2c(conv%d_padding) downto 0); \n', i,b, i);
        fprintf(fid,'signal p_row%d_%d : unsigned( log2c(conv%d_padding) downto 0); \n', i,b, i);
        fprintf(fid,'signal padding_col%d_%d, padding_row%d_%d, index%d_%d : std_logic; \n', i,b, i,b, i,b);
        fprintf(fid,'signal col%d_%d :  unsigned(log2c(column_size%d + 2*(conv%d_padding)) - 1 downto 0); \n', i,b, i, i);
    end
        fprintf(fid,'signal conv%d_col : unsigned(log2c(conv%d_column) - 1 downto 0);\n', i, i);
        fprintf(fid,'signal conv%d_fila : unsigned(log2c(conv%d_row) - 1 downto 0);\n', i, i);
        fprintf(fid,'signal pool%d_col : unsigned(log2c(pool%d_column) - 1 downto 0);\n', i+1, i+1);
        fprintf(fid,'signal pool%d_fila : unsigned(log2c(pool%d_row) - 1 downto 0);\n', i+1, i+1);
        fprintf(fid,'signal p_col%d : unsigned( log2c(conv%d_padding) downto 0); \n', i, i);
        fprintf(fid,'signal p_row%d : unsigned( log2c(conv%d_padding) downto 0); \n', i, i);
        fprintf(fid,'signal padding_col%d, padding_row%d, index%d : std_logic; \n', i, i, i);
        fprintf(fid,'signal col%d :  unsigned(log2c(column_size%d + 2*(conv%d_padding)) - 1 downto 0); \n', i, i, i);
end
fprintf(fid, 'signal data_in_layer1 : vector_data_in(0 to parallel_data - 1);\n');
fprintf(fid, 'signal data_in1, data_in21 : std_logic_vector(input_sizeL1 - 1 downto 0);\n');
fprintf(fid, 'signal data_in_filter1, data_in_filter21 : std_logic;\n');

fprintf(fid, 'signal data_in_relu11 ');
for i = 2 : number_of_neurons(1)
    fprintf(fid, ', data_in_relu1%d', i);
end
fprintf(fid, ': std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);\n');
fprintf(fid, 'signal data_out_relu11 ');
for i = 2 : number_of_neurons(1)
    fprintf(fid, ', data_out_relu1%d', i);
end
fprintf(fid, ': STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);\n');
fprintf(fid, 'signal data_in_relu2_1 ');
for i = 2 : number_of_neurons(1)
    fprintf(fid, ', data_in_relu2_%d', i);
end
fprintf(fid, ': STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);\n');
fprintf(fid, 'signal data_out_relu2_1 ');
for i = 2 : number_of_neurons(1)
    fprintf(fid, ', data_out_relu2_%d', i);
end
fprintf(fid, ': STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);\n');
fprintf(fid, 'signal weight_aux1 ');
for i = 2 : number_of_neurons(1)
    fprintf(fid, ', weight_aux%d', i);
end
fprintf(fid, ': signed(weight_sizeL1 - 1 downto 0);\n');
for b = 1 : 3
        fprintf(fid, 'signal data_in_relu11_%d ',b);
        for i = 2 : number_of_neurons(1)
            fprintf(fid, ', data_in_relu1%d_%d', i,b);
        end
        fprintf(fid, ': std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);\n');
        fprintf(fid, 'signal data_out_relu11_%d ',b);
        for i = 2 : number_of_neurons(1)
            fprintf(fid, ', data_out_relu1%d_%d', i,b);
        end
        fprintf(fid, ': STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);\n');
        fprintf(fid, 'signal data_in_relu2_1_%d ',b);
        for i = 2 : number_of_neurons(1)
            fprintf(fid, ', data_in_relu2_%d_%d', i,b);
        end
        fprintf(fid, ': STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);\n');
        fprintf(fid, 'signal data_out_relu2_1_%d ',b);
        for i = 2 : number_of_neurons(1)
            fprintf(fid, ', data_out_relu2_%d_%d', i,b);
        end
        fprintf(fid, ': STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);\n');
        fprintf(fid, 'signal weight_aux1_%d ',b);
        for i = 2 : number_of_neurons(1)
            fprintf(fid, ', weight_aux%d_%d', i,b);
        end
        fprintf(fid, ': signed(weight_sizeL1 - 1 downto 0);\n');
end
fprintf(fid, 'signal data_max_L1, data_min_L1 : signed(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);\n');

for j = 2 : layers_cnn - 1
    fprintf(fid, '--LAYER %d\n', j);
    for b = 1 : 3
        fprintf(fid,' signal next_pipeline_step_aux%d_%d, data_processed%d_%d, zero%d_%d, en_neuronL%d_%d, next_data_pool%d_%d, data_zero%d_%d, data_new%d_%d, data_new_et%d_%d, data_par2serL%d_%d : std_logic;\n', j,b, j,b, j,b, j,b, j,b, j,b, j+1,b, j+1,b, j,b);
        fprintf(fid, 'signal count%d_%d : unsigned(log2c(input_sizeL%d) - 1 downto 0 );\n', j,b, j);
        fprintf(fid, 'signal mul%d_%d : std_logic_vector(log2c(mult%d) - 1 downto 0);\n', j,b, j);
        fprintf(fid, 'signal layer%d_%d : std_logic_vector(log2c(number_of_layers%d) - 1 downto 0);\n', j,b, j);
        fprintf(fid, 'signal data_in_pool%d_%d%d , data_out_pool%d_%d: std_logic_vector (input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0);\n', j,b,b, j,b, j - 1, j - 1);
        fprintf(fid, 'signal data_pool%d_%d: std_logic_vector(input_sizeL%d - 1 downto 0);\n', j,b, j);
    end
    fprintf(fid,' signal next_pipeline_step_aux%d,data_in_%d, data_processed%d, dato_in_gen%d, next_pipeline_step%d, zero%d, en_neuronL%d, next_data_pool%d, data_zero%d, data_new%d, data_new_et%d, data_par2serL%d : std_logic;\n', j, j, j, j, j, j, j, j, j, j+1, j+1, j);
    fprintf(fid, 'signal count%d : unsigned(log2c(input_sizeL%d) - 1 downto 0 );\n', j, j);
    fprintf(fid, 'signal mul%d : std_logic_vector(log2c(mult%d) - 1 downto 0);\n', j, j);
    fprintf(fid, 'signal layer%d : std_logic_vector(log2c(number_of_layers%d) - 1 downto 0);\n', j, j);
    fprintf(fid, 'signal data_in_pool%d , data_out_pool%d: std_logic_vector (input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0);\n', j, j, j - 1, j - 1);
    fprintf(fid, 'signal data_pool%d, data_in_layer%d: std_logic_vector(input_sizeL%d - 1 downto 0);\n', j, j, j);
    fprintf(fid, 'signal address_%d : std_logic_vector ( log2c(mult%d) + log2c(number_of_layers%d) - 1 downto 0);\n', j, j, j);
    fprintf(fid, 'signal data_in_filter%d, data_out_par2ser%d: std_logic;\n', j, j);
    if(parallelism_layer1 == 1 && j==2)
        fprintf(fid, 'signal data_in_pool2_2:  std_logic_vector (input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0);\n', j - 1, j - 1);
        for b = 1 : 3
            fprintf(fid, 'signal data_in_pool2_2_%d:  std_logic_vector (input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0);\n',b, j - 1, j - 1);
        end
    end

    fprintf(fid, 'signal data_in_relu%d1 ', j);
    for b = 1 : 3 
        fprintf(fid, ', data_in_relu%d1_%d ', j,b);
    end
    for i = 2 : number_of_neurons(j)
        fprintf(fid, ', data_in_relu%d%d',j, i);
        for b = 1 : 3
            fprintf(fid, ', data_in_relu%d%d_%d',j, i, b);
        end
    end
    fprintf(fid, ': std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0);\n', j, j);

    fprintf(fid, 'signal data_out_relu%d1 ', j);
    for b = 1 : 3
        fprintf(fid, ', data_out_relu%d1_%d ', j, b);
    end
    for i = 2 : number_of_neurons(j)
        fprintf(fid, ', data_out_relu%d%d',j,  i);
        for b = 1 : 3
            fprintf(fid, ', data_out_relu%d%d_%d',j,  i, b);
        end
    end
    fprintf(fid, ': std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0);\n', j, j);

    fprintf(fid, 'signal data_max_L%d, data_min_L%d : signed(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0);\n',j, j,  j - 1, j - 1);
    if(parallelism_layer1 == 1 && j==2)
        fprintf(fid, 'signal data_in_act2_1, data_in_act2_2, data_act_L2_1, data_act_L2_2  : std_logic_vector(input_sizeL2 - 1 downto 0); \n');
        for b = 1 : 3
            fprintf(fid, 'signal  data_act_L2_1_%d, data_act_L2_2_%d  : std_logic_vector(input_sizeL2 - 1 downto 0); \n',b,b);
        end
    else
        fprintf(fid, 'signal data_in_act%d, data_act_L%d  : std_logic_vector(input_sizeL%d - 1 downto 0); \n', j, j, j);
        for b = 1 : 3
            fprintf(fid, 'signal data_act_L%d_%d  : std_logic_vector(input_sizeL%d - 1 downto 0); \n', j, b, j);
        end
    end
end

fprintf(fid, '--LAYER%d\n', layers_cnn);

fprintf(fid, 'signal index%d, next_data_pool%d, data_processed%d : std_logic;\n', layers_cnn, layers_cnn, layers_cnn);
fprintf(fid, 'signal layer%d : std_logic_vector(log2c(number_of_layers%d) - 1 downto 0);\n', layers_cnn, layers_cnn);
fprintf(fid, 'signal data_in_pool%d, data_out_pool%d : std_logic_vector (input_sizeL%d + weight_sizeL%d + n_extra_bits- 1 downto 0);\n',layers_cnn, layers_cnn, layers_cnn - 1, layers_cnn - 1);
fprintf(fid, 'signal data_in_act%d,data_act_L%d, data_pool%d, data_out_buff : std_logic_vector (input_size_L1fc - 1 downto 0);\n',layers_cnn, layers_cnn, layers_cnn);
for b = 1 : 3
    fprintf(fid, 'signal index%d_%d, next_data_pool%d_%d, data_processed%d_%d : std_logic;\n', layers_cnn,b, layers_cnn,b, layers_cnn,b);
    fprintf(fid, 'signal layer%d_%d : std_logic_vector(log2c(number_of_layers%d) - 1 downto 0);\n', layers_cnn,b, layers_cnn);
    fprintf(fid, 'signal data_in_pool%d_%d, data_out_pool%d_%d : std_logic_vector (input_sizeL%d + weight_sizeL%d + n_extra_bits- 1 downto 0);\n',layers_cnn,b, layers_cnn,b, layers_cnn - 1, layers_cnn - 1);
    fprintf(fid, 'signal data_act_L%d_%d, data_pool%d_%d : std_logic_vector (input_size_L1fc - 1 downto 0);\n',layers_cnn,b, layers_cnn,b);
end
for b = 1 : 3
    fprintf(fid, 'signal data_out_%d : STD_LOGIC_VECTOR(input_size_L1fc - 1 downto 0);\n',b);
end
fprintf(fid, 'begin\n');fprintf(fid,'--INPUT MEMORY\n');


fprintf(fid,'--Manage the retrieval of data form the memory, receives addresses from the interface of the first layer and sends data to the first set of neurons\n');
fprintf(fid,'REG_DATOS : Reg_data\n');
fprintf(fid,'Port map(\n');
fprintf(fid,'     clk =>clk,\n');
fprintf(fid,'     rst => rst,\n');
fprintf(fid,'     data_addr => data_addr,\n');
fprintf(fid,'     data_red => data_in_gen1,\n');
fprintf(fid,'     address_in => address_in,\n');
fprintf(fid,'     address_out => address,\n');
fprintf(fid,'     data_in => data_in,\n');
fprintf(fid,'     data_out => data_in_layer1\n');
fprintf(fid,');\n');
fprintf(fid,'----LAYER 1\n');
fprintf(fid,'--We generate control signals when a new data needs to be processed in the first layer\n');
fprintf(fid,'data_in_1 <= data_new2 or data_processed1 or next_pipeline_step_aux1 ;\n');
for i = 1 : 3
fprintf(fid,'GEN_ENABLE_%d: GEN1 \n',i);
fprintf(fid,'port map(\n');
fprintf(fid,'  clk => clk,\n');
fprintf(fid,'  rst => rst,\n');
fprintf(fid,'  rst_red => rst_red,\n');
fprintf(fid,'  data_in => data_in_gen1,\n');
fprintf(fid,'  count => count1_%d,\n',i);
fprintf(fid,'  mul => mul1_%d,\n',i);
fprintf(fid,'  en_neuron => en_neuronL1_%d,\n',i);
fprintf(fid,'  data_zero1 => data_zero1_%d,\n',i);
fprintf(fid,'  data_zero2 => data_zero21_%d,\n',i);
fprintf(fid,'  data_out1 => data_processed1_%d,\n',i);
fprintf(fid,'  data_out2 => data_new_et2_%d,\n',i);
fprintf(fid,'  next_pipeline_step => next_pipeline_step_aux1_%d\n',i);
fprintf(fid,');\n');
end
fprintf(fid, 'VOTADOR_GEN1 : VOT_GEN1\n');
            fprintf(fid, '   port map(\n');
        for b = 1 : 3
        fprintf(fid, '\t\t en_neuron_%d => en_neuronL1_%d,\n',b,b);
        fprintf(fid, '\t\t count_%d => count1_%d,\n',b,b);
        fprintf(fid, '\t\t mul_%d => mul1_%d,\n',b,b);
        fprintf(fid, '\t\t dato_out1_%d => data_processed1_%d,\n',b,b);
        fprintf(fid, '\t\t dato_out2_%d => data_new_et2_%d,\n',b,b);
        fprintf(fid, '\t\t next_pipeline_step_%d => next_pipeline_step_aux1_%d,\n',b,b);
        end
        fprintf(fid, '\t\t en_neuron_v => en_neuronL1,\n');
        fprintf(fid, '\t\t count_v => count1,\n');
        fprintf(fid, '\t\t mul_v => mul1,\n');
        fprintf(fid, '\t\t dato_out1_v => data_processed1, \n');
        fprintf(fid, '\t\t dato_out2_v => data_new_et2,\n');
        fprintf(fid, '\t\t next_pipeline_step_v => next_pipeline_step_aux1);\n');

fprintf(fid,'--Signal to notify the neurons that a filter sweep is completed\n');
fprintf(fid,'next_pipeline_step1 <= next_pipeline_step_aux1 or data_new_et2;\n');

for b = 1 : 3
    fprintf(fid, 'INTERFAZ_1_%d: INTERFAZ_ET1\n',b);
    fprintf(fid,'port map(\n');
    fprintf(fid, '  clk => clk,\n');
    fprintf(fid, '  rst => rst,\n');
    fprintf(fid, '  rst_red => rst_red,\n');
    fprintf(fid, '  data_in => data_in_1,\n');
    fprintf(fid, '  data_addr => data_addr_%d,\n',b);
    fprintf(fid, '  address => address_in_%d(0),\n',b);
    fprintf(fid, '  zero => zero111_%d,\n',b);
    fprintf(fid, '  address2 => address_in_%d(1),\n',b);
    fprintf(fid, '  zero2 => zero1_2_%d,\n',b);
    fprintf(fid, '  data_out => data_in_gen1_%d,\n',b);
    fprintf(fid, '  col2 => col2,\n');
    fprintf(fid, '  data_zero1 => data_zero1_%d,\n',b);
    fprintf(fid, '  data_zero2 => data_zero21_%d,\n',b);
    for i = 2 : layers_cnn-1
        fprintf(fid, '  p_row%d => p_row%d, \n', i, i);
        fprintf(fid, '  p_col%d => p_col%d , \n', i,i);
        fprintf(fid, '  conv%d_col => conv%d_col, \n', i, i);
        fprintf(fid, '  conv%d_fila => conv%d_fila, \n',i,  i);
        fprintf(fid, '  pool%d_col => pool%d_col,\n', i+1, i+1);
        fprintf(fid, '  pool%d_fila => pool%d_fila, \n', i+1, i+1);
    end
    fprintf(fid, '  padding_col2 => padding_col2,\n ');
    fprintf(fid, '  padding_row2 => padding_row2 \n');
    fprintf(fid, ');\n');
end 
fprintf(fid, 'VOTADOR_INTERFAZ1 : VOT_INTERFAZ_ET1\n');
            fprintf(fid, '   port map(\n');
        for e=1 :3
        fprintf(fid,'\t\t dato_out_%d => data_in_gen1_%d,\n',e,e);
        fprintf(fid,'\t\t cero_%d => zero111_%d,\n',e,e);
        fprintf(fid,'\t\t cero2_%d => zero1_2_%d,\n',e,e);
        fprintf(fid,'\t\t dato_cero_%d => data_zero1_%d,\n',e,e);
        fprintf(fid,'\t\t dato_cero2_%d => data_zero21_%d,\n',e,e);
        fprintf(fid,'\t\t dato_addr_%d => data_addr_%d,\n',e,e);
        fprintf(fid,'\t\t address_%d => address_in_%d(0),\n',e,e);
        fprintf(fid,'\t\t address2_%d => address_in_%d(1),\n',e,e);
        end
        fprintf(fid,'\t\t dato_out_v => data_in_gen1,\n');
        fprintf(fid,'\t\t cero_v => zero1,\n');
        fprintf(fid,'\t\t cero2_v => zero1_2,\n');
        fprintf(fid,'\t\t dato_cero_v => data_zero1,\n');
        fprintf(fid,'\t\t dato_cero2_v => data_zero21,\n');
        fprintf(fid,'\t\t dato_addr_v => data_addr,\n');
        fprintf(fid,'\t\t address_v => address_in(0),\n');
        fprintf(fid,'\t\t address2_v => address_in(1));\n');

fprintf(fid, '--Data to be processed by the first layer of the network coming from the memory, if we are in the padding zone of the inpit matrix we send directly a zero\n');
fprintf(fid, 'data_in1 <= data_in_layer1(0) when (zero1 = ''0'') else (others=>''0'');\n');
fprintf(fid, 'data_in21 <= data_in_layer1(1) when (zero1_2 = ''0'') else (others=>''0'');\n\n');
fprintf(fid, '--Converts the input from parallel to serial\n');

for i = 1 : 3
fprintf(fid, 'CONVERTERL1_%d : PAR2SER\n',i);
fprintf(fid, 'generic map (input_size => input_sizeL1)\n');
fprintf(fid, 'port map(\n');
fprintf(fid, '  clk => clk,\n');
fprintf(fid, '  rst => rst,\n');
fprintf(fid, '  en_neuron => en_neuronL1,\n');
fprintf(fid, '  data_in => data_in1,\n');
fprintf(fid, '  bit_select => count1,\n');
fprintf(fid, '  bit_out => data_par2serL1_1_%d',i);
fprintf(fid, ');\n');
end
fprintf(fid, 'VOTADOR_PAR2SERL1 : VOT_PAR2SER\n');
            fprintf(fid, '   port map(\n');
        for a = 1 : 3
        fprintf(fid, '\t\t serial_out_%d => data_par2serL1_1_%d,\n',a,a);
        end
        fprintf(fid, '\t\t serial_out_v => data_par2serL1_1);\n');

for i = 1 : 3
fprintf(fid, 'CONVERTERL1_2_%d : PAR2SER\n',i);
fprintf(fid, 'generic map (input_size => input_sizeL1)\n');
fprintf(fid, 'port map(\n');
fprintf(fid, '  clk => clk,\n');
fprintf(fid, '  rst => rst,\n');
fprintf(fid, '  en_neuron => en_neuronL1,\n');
fprintf(fid, '  data_in => data_in21,\n');
fprintf(fid, '  bit_select => count1,\n');
fprintf(fid, '  bit_out => data_par2serL1_2_%d\n',i);
fprintf(fid, ');\n');
end
fprintf(fid, 'VOTADOR_PAR2SERL1_2 : VOT_PAR2SER\n');
            fprintf(fid, '   port map(\n');
        for a = 1 : 3
        fprintf(fid, '\t\t serial_out_%d => data_par2serL1_2_%d,\n',a,a);
        end
        fprintf(fid, '\t\t serial_out_v => data_par2serL1_2);\n');

fprintf(fid, '--Data sent to the neurons, we only send it when the neurons can process it (enable neuron = 1)\n');
fprintf(fid, 'data_in_filter1 <= data_par2serL1_1 when (en_neuronL1 = ''1'') else ''0'';\n');
fprintf(fid, 'data_in_filter21 <= data_par2serL1_2 when (en_neuronL1 = ''1'') else ''0'';\n');

for i = 1 : conv_z(2)
    for x = 1 : 3
        fprintf(fid, 'CONV1_%d_%d : CONV1%d\n', i,x ,i);
        fprintf(fid, 'port map(\n');
        fprintf(fid, '    clk => clk,\n');
        fprintf(fid, '    rst => rst,\n');
        fprintf(fid, '    data_in => data_in_filter1,\n');
        fprintf(fid, '    weight_out => weight_aux%d_%d,\n', i,x);
        fprintf(fid, '    address => mul1,\n');
        fprintf(fid, '    bit_select => count1,\n');
        fprintf(fid, '    next_pipeline_step => next_pipeline_step1,\n');
        fprintf(fid, '    data_out => data_in_relu1%d_%d);\n', i,x);
    end
    fprintf(fid, 'VOTADOR_CONV1_%d : VOT_CONV1%d\n', i, i);
        fprintf(fid, '   port map(\n');
        for x = 1 : 3
             fprintf(fid,' \t\t    weight_out_%d => weight_aux%d_%d, \n',x, i,x);
        end 
        fprintf(fid,' \t\t    weight_out_v => weight_aux%d, \n', i);
        for o = 1 : 3
            fprintf(fid, '\t\t    data_out_%d => data_in_relu1%d_%d,\n',o, i, o);
        end
        fprintf(fid, '\t\t    data_out_v => data_in_relu1%d);\n', i);

    for x = 1 : 3
        fprintf(fid, 'RELU1_%d_%d : RELUL1\n', i,x);
        fprintf(fid, 'port map(\n');
        fprintf(fid, '    clk => clk,\n');
        fprintf(fid, '    rst => rst,\n');
        fprintf(fid, '    next_pipeline_step => next_pipeline_step1,\n');
        fprintf(fid, '    data_in => data_in_relu1%d,\n', i);
        fprintf(fid, '    index => index2,\n' );
        fprintf(fid, '    data_out => data_out_relu1%d_%d);  \n', i,x);
    end

   fprintf(fid, 'VOTADOR_RELU1_%d : VOT_RELUL1\n', i );
            fprintf(fid, '   port map(\n');
    for x = 1 : 3
        fprintf(fid, '\t\t    data_out_%d => data_out_relu1%d_%d,\n',x, i, x);
    end
    fprintf(fid, '\t\t    data_out_v => data_out_relu1%d);\n', i);

end
if(parallelism_layer1)
    for i = 1 : conv_z(2)
        for x = 1 : 3
            fprintf(fid, 'CONVP1_%d_%d : CONVP1%d\n', i,x, i);
            fprintf(fid, 'port map(\n');
            fprintf(fid, '    clk => clk,\n');
            fprintf(fid, '    rst => rst,\n');
            fprintf(fid, '    data_in => data_in_filter21,\n');
            fprintf(fid, '    weight => weight_aux%d,\n', i);
            fprintf(fid, '    bit_select => count1,\n');
            fprintf(fid, '    next_pipeline_step => next_pipeline_step1,\n');
            fprintf(fid, '    data_out => data_in_relu2_%d_%d);\n', i,x);
        end
        fprintf(fid, 'VOTADOR_CONVP1_%d : VOT_CONVP1%d\n',i, i);
                fprintf(fid, '   port map(\n');
            for x = 1 : 3
                fprintf(fid, '	     data_out_%d => data_in_relu2_%d_%d,\n',x,i,x);
            end
            fprintf(fid, '	     data_out_v => data_in_relu2_%d);\n',i);
    
        for x = 1 : 3
            fprintf(fid, 'RELUP1%d_%d : RELUL1\n', i,x);
            fprintf(fid, ' port map(\n');
            fprintf(fid, '    clk => clk,\n');
            fprintf(fid, '    rst => rst,\n');
            fprintf(fid, '    next_pipeline_step => next_pipeline_step1,\n');
            fprintf(fid, '    data_in => data_in_relu2_%d,\n', i);
            fprintf(fid, '    index => index2,\n');
            fprintf(fid, '    data_out => data_out_relu2_%d_%d);  \n', i,x);
        end
        fprintf(fid, 'VOTADOR_RELUP1_%d : VOT_RELUL1\n', i );
                fprintf(fid, '   port map(\n');
        for x = 1 : 3
            fprintf(fid, '\t\t    data_out_%d => data_out_relu2_%d_%d,\n',x, i, x);
        end
        fprintf(fid, '\t\t    data_out_v => data_out_relu2_%d);\n', i);
    
    end
end


for i = 2 : layers_cnn - 1
    fprintf(fid, '----LAYER %d\n', i);
    fprintf(fid,'--We generate control signals when a new data needs to be processed in the second layer\n');
    if ( i == layers_cnn - 1)
        fprintf(fid, 'data_in_%d <= start_red or next_pipeline_step_aux%d or data_processed%d or data_processed%d;\n', i , i, i , layers_cnn);
    else
        fprintf(fid, 'data_in_%d <= data_new%d or data_processed%d or next_pipeline_step_aux%d ;\n', i , i+1, i,i);
    end
    for b = 1 : 3
        fprintf(fid, 'GEN_ENABLE%d_%d: GEN%d \n', i, b, i);
        fprintf(fid, 'port map(\n');
        fprintf(fid, '  clk => clk,\n');
        fprintf(fid, '  rst => rst,\n');
        fprintf(fid, '  rst_red => rst_red,\n');
        fprintf(fid, '  layer => layer%d_%d,\n', i, b);
        fprintf(fid, '  data_in => data_new_et%d,\n', i);
        fprintf(fid, '  count => count%d_%d,\n', i, b);
        fprintf(fid, '  mul => mul%d_%d,\n', i, b);
        fprintf(fid, '  data_zero => data_zero%d,\n', i);
        fprintf(fid, '  en_neuron => en_neuronL%d_%d,\n', i, b);
        fprintf(fid, '  index => index%d_%d,\n', i, b);
        fprintf(fid, '  next_data_pool => next_data_pool%d_%d,\n', i, b);
        fprintf(fid, '  data_out1 => data_processed%d_%d,\n', i, b);
        fprintf(fid, '  data_out2 => data_new_et%d_%d,\n', i+1, b);
        fprintf(fid, '  next_pipeline_step => next_pipeline_step_aux%d_%d\n', i, b);
        fprintf(fid, ');\n');
    end
    fprintf(fid, 'VOTADOR_GEN%d : VOT_GEN%d\n',i , i);
            fprintf(fid, '   port map(\n');
    for h=1 : 3
        fprintf(fid, '\t\t layer_%d => layer%d_%d,\n',h, i, h);
        fprintf(fid, '\t\t count_%d => count%d_%d,\n',h, i, h);
        fprintf(fid, '\t\t mul_%d => mul%d_%d,\n',h, i, h);
        fprintf(fid, '\t\t dato_out1_%d => data_processed%d_%d, \n',h,i,h);
        fprintf(fid, '\t\t dato_out2_%d => data_new_et%d_%d,\n',h,i+1,h);
        fprintf(fid, '\t\t index_%d => index%d_%d,\n',h, i ,h);
        fprintf(fid, '\t\t en_neurona_%d => en_neuronL%d_%d,\n',h,i,h);
        fprintf(fid, '\t\t next_dato_pool_%d => next_data_pool%d_%d,\n',h,i,h);
        fprintf(fid, '\t\t next_pipeline_step_%d => next_pipeline_step_aux%d_%d,\n',h,i,h);
     end
        fprintf(fid, '\t\t layer_v => layer%d,\n', i);
        fprintf(fid, '\t\t count_v => count%d,\n', i);
        fprintf(fid, '\t\t mul_v => mul%d,\n', i);
        fprintf(fid, '\t\t dato_out1_v => data_processed%d, \n',i);
        fprintf(fid, '\t\t dato_out2_v => data_new_et%d,\n',i+1);
        fprintf(fid, '\t\t index_v => index%d,\n',i);
        fprintf(fid, '\t\t en_neurona_v => en_neuronL%d,\n',i);
        fprintf(fid, '\t\t next_dato_pool_v => next_data_pool%d,\n',i);
        fprintf(fid, '\t\t next_pipeline_step_v => next_pipeline_step_aux%d);\n',i);

    fprintf(fid, '\n');
    fprintf(fid, '--Signal to notify the neurons that a filter sweep is completed\n');
    fprintf(fid, 'next_pipeline_step%d <= next_pipeline_step_aux%d or data_new_et%d;\n', i, i, i + 1);
    fprintf(fid, '\n');
    fprintf(fid, '--For each new data processed we calculate the position of the filters;\n');
    
for h = 1 : 3
    fprintf(fid, 'INTERFAZ_%d_%d: INTERFAZ_ET%d\n', i, h ,i);
    fprintf(fid, 'Port map(\n');
    fprintf(fid, '  clk => clk,\n');
    fprintf(fid, '  rst => rst,\n');
    fprintf(fid, '  rst_red => rst_red,\n');
    fprintf(fid, '  zero => zero%d_%d,\n', i, h);
    fprintf(fid, '  data_in => data_in_%d,\n', i);
    fprintf(fid, '  data_out => data_new%d_%d,\n', i, h);
    fprintf(fid, '  data_zero => data_zero%d_%d,\n', i, h);
    fprintf(fid, '  col%d => col%d_%d,\n', i , i , h);
    fprintf(fid, '  padding_col%d => padding_col%d_%d, \n', i,i,h);
    fprintf(fid, '  padding_row%d => padding_row%d_%d', i,i,h);
    if i ~= layers_cnn - 1
        fprintf(fid, ', \n  col%d => col%d,\n', i + 1, i+1);
        fprintf(fid, '  padding_col%d => padding_col%d, \n', i + 1,i + 1);
        fprintf(fid, '  padding_row%d => padding_row%d', i +1 ,i +1);
    end
    for o = i + 1 : layers_cnn-1
        fprintf(fid, ', \n  p_row%d => p_row%d', o, o);
        fprintf(fid, ', \n  p_col%d => p_col%d', o, o);
        fprintf(fid, ', \n  conv%d_col => conv%d_col', o, o);
        fprintf(fid, ', \n  conv%d_fila => conv%d_fila', o, o);
        fprintf(fid, ', \n  pool%d_col => pool%d_col', o+1, o+1);
        fprintf(fid, ', \n  pool%d_fila => pool%d_fila', o+1, o+1);
    end    
        fprintf(fid, ', \n  p_row%d => p_row%d_%d', i, i,h);
        fprintf(fid, ', \n  p_col%d => p_col%d_%d', i, i,h);
        fprintf(fid, ', \n  conv%d_col => conv%d_col_%d', i, i,h);
        fprintf(fid, ', \n  conv%d_fila => conv%d_fila_%d', i, i,h);
        fprintf(fid, ', \n  pool%d_col => pool%d_col_%d', i+1, i+1,h);
        fprintf(fid, ', \n  pool%d_fila => pool%d_fila_%d', i+1, i+1,h);
    fprintf(fid, ');\n');
end
fprintf(fid, 'VOTADOR_INTERFAZ%d : VOT_INTERFAZ_ET%d\n', i,i);
        fprintf(fid, '   port map(\n');
        for m =1 :3
            fprintf(fid,'\t\t dato_out_%d => data_new%d_%d,\n',m,i,m);
            fprintf(fid,'\t\t cero_%d => zero%d_%d,\n',m, i,m);
            fprintf(fid,'\t\t dato_cero_%d => data_zero%d_%d,\n',m,i,m);
            fprintf(fid, '\t\t padding_col%d_%d => padding_col%d_%d,\n',i ,m,i,m);
            fprintf(fid, '\t\t padding_row%d_%d => padding_row%d_%d,\n',i ,m,i,m);
            fprintf(fid, '\t\t col%d_%d => col%d_%d,\n', i ,m , i, m);
            fprintf(fid, '\t\t p_row%d_%d => p_row%d_%d,\n', i,m, i,m);
            fprintf(fid, '\t\t p_col%d_%d => p_col%d_%d,\n', i,m, i,m);
            fprintf(fid,'\t\t conv%d_col_%d => conv%d_col_%d,\n', i,m, i,m);
            fprintf(fid,'\t\t conv%d_fila_%d => conv%d_fila_%d,\n', i,m, i,m);
            fprintf(fid,'\t\t pool%d_col_%d => pool%d_col_%d,\n', i+1,m, i+1,m);
            fprintf(fid,'\t\t pool%d_fila_%d => pool%d_fila_%d,\n', i+1,m, i+1,m);
        end
            fprintf(fid,'\t\t dato_out_v => data_new%d,\n',i);
            fprintf(fid,'\t\t cero_v => zero%d,\n',i);
            fprintf(fid,'\t\t dato_cero_v => data_zero%d,\n',i);
            fprintf(fid, '\t\t padding_col%d_v => padding_col%d,\n',i,i);
            fprintf(fid, '\t\t padding_row%d_v => padding_row%d,\n',i,i);
            fprintf(fid, '\t\t col%d_v => col%d,\n', i, i);
            fprintf(fid, '\t\t p_row%d_v => p_row%d,\n', i, i);
            fprintf(fid, '\t\t p_col%d_v => p_col%d,\n', i, i);
            fprintf(fid,'\t\t conv%d_col_v => conv%d_col,\n', i, i);
            fprintf(fid,'\t\t conv%d_fila_v => conv%d_fila,\n', i, i);
            fprintf(fid,'\t\t pool%d_col_v => pool%d_col,\n', i+1, i+1);
            fprintf(fid,'\t\t pool%d_fila_v => pool%d_fila);\n', i+1, i+1);
    
% for p = 1 : 3
    fprintf(fid, 'MUX%d : MUX_%d\n', i, i);
    fprintf(fid, '   port map(\n');
    for j = 1 : conv_z(i)
        fprintf(fid, 'data_in%d=> data_out_relu%d%d,\n', j-1, i - 1, j);
    end
    fprintf(fid, '    index => layer%d,\n', i);
    fprintf(fid, '    data_out => data_in_pool%d);\n', i);
% end
% fprintf(fid, 'VOTADOR_MUX%d : VOT_MUX_%d\n',i,i);
%             fprintf(fid, '   port map(\n');
%         for d = 1 : 3 
%         fprintf(fid, '\t\t data_out_%d => data_in_pool%d_%d%d,\n',d ,i,d,d);
%         end
%         fprintf(fid, '\t\t data_out_v => data_in_pool%d);\n', i);
        
    if( i == 2)
        % for m = 1 : 3
            fprintf(fid, 'MUX2%d : MUX_%d\n', i, i);
            fprintf(fid, '   port map(\n');
            for j = 1 : conv_z(i)
                fprintf(fid, 'data_in%d=> data_out_relu2_%d,\n', j-1, j);
            end
            fprintf(fid, '    index => layer%d,\n', i);
            fprintf(fid, '    data_out => data_in_pool2_%d);\n', i );
        % end
        % fprintf(fid, 'VOTADOR_MUX2%d : VOT_MUX_%d\n',i,i);
        %     fprintf(fid, '   port map(\n');
        % for d = 1 : 3 
        % fprintf(fid, '\t\t data_out_%d => data_in_pool2_%d_%d,\n',d ,i,d);
        % end
        % fprintf(fid, '\t\t data_out_v => data_in_pool2_%d);\n', i);
        fprintf(fid,'\n');

        if(activations(2) == 1)
            fprintf(fid, "data_max_L1(weight_sizeL1 + fractional_size_L1 + n_extra_bits + 1 downto w_fractional_sizeL1 + fractional_size_L1 + 1) <= (others => '0');\n");
            fprintf(fid, "data_max_L1(w_fractional_sizeL1 + fractional_size_L1 downto w_fractional_sizeL1 ) <= (others => '1');\n");
            fprintf(fid, "data_max_L1(w_fractional_sizeL1 - 1 downto 0) <= (others => '0');\n");
            fprintf(fid, "\n");
            fprintf(fid, "data_min_L1(weight_sizeL1 + fractional_size_L1 + n_extra_bits + 1 downto w_fractional_sizeL1 + fractional_size_L1 + 1) <= (others => '1');\n");
            fprintf(fid, "data_min_L1( w_fractional_sizeL1 + fractional_size_L1 downto 0 ) <= (others => '0');\n");
            fprintf(fid, "\n");
            fprintf(fid, "process (data_in_act2_1, data_min_L1, data_max_L1, data_in_pool2)\n");
            fprintf(fid, "begin\n");
            fprintf(fid, "\tif (signed(data_in_pool2) >= data_max_L1) then\n");
            fprintf(fid, "\t\tdata_in_act2_1(input_size_L1fc-1) <= '0';\n");
            fprintf(fid, "\t\tdata_in_act2_1(input_size_L1fc-2 downto 0) <= (others => '1');\n");
            fprintf(fid, "\telsif (signed(data_in_pool2) <= data_min_L1) then\n");
            fprintf(fid, "\t\tdata_in_act2_1(input_size_L1fc-1) <= '1';\n");
            fprintf(fid, "\t\tdata_in_act2_1(input_size_L1fc-2 downto 0) <= (others => '0');\n");
            fprintf(fid, "\telse\n");
            fprintf(fid, "\t\tdata_in_act2_1<= data_in_pool2(w_fractional_sizeL1 + input_sizeL2 - 1 downto w_fractional_sizeL1);\n");
            fprintf(fid, "\tend if;\n");
            fprintf(fid, "end process;\n");
            fprintf(fid, "\n");
            fprintf(fid, "process (data_in_act2_2, data_min_L1, data_max_L1, data_in_pool2_2)\n");
            fprintf(fid, "begin\n");
            fprintf(fid, "\tif (signed(data_in_pool2_2) >= data_max_L1) then\n");
            fprintf(fid, "\t\tdata_in_act2_2(input_size_L1fc-1) <= '0';\n");
            fprintf(fid, "\t\tdata_in_act2_2(input_size_L1fc-2 downto 0) <= (others => '1');\n");
            fprintf(fid, "\telsif (signed(data_in_pool2_2) <= data_min_L1) then\n");
            fprintf(fid, "\t\tdata_in_act2_2(input_size_L1fc-1) <= '1';\n");
            fprintf(fid, "\t\tdata_in_act2_2(input_size_L1fc-2 downto 0) <= (others => '0');\n");
            fprintf(fid, "\telse\n");
            fprintf(fid, "\t\tdata_in_act2_2<= data_in_pool2_2(w_fractional_sizeL1 + input_sizeL2 - 1 downto w_fractional_sizeL1);\n");
            fprintf(fid, "\tend if;\n");
            fprintf(fid, "end process;\n");
            fprintf(fid, "\n");
            fprintf(fid, "--Layer 2 MaxPool filter\n");
            fprintf(fid, "--It receives two input data because the process is parallelized\n");

            for v = 1 : 3
                fprintf(fid, "Sigmoid_functionL2_%d : sigmoid_L2\n",v);
                fprintf(fid, "  port map(\n");
                fprintf(fid, "  data_in => data_in_act2_1,\n");
                fprintf(fid, "  data_out => data_act_L2_1_%d);\n",v);
            end
            fprintf(fid, 'VOTADOR_sigmoid_L2 : VOT_sigmoid_L2\n');
            fprintf(fid, "  port map(\n");
            for x = 1 : 3
            fprintf(fid, '\t\tdata_out_%d => data_act_L2_1_%d,\n',x,x);
            end
            fprintf(fid, '\t\tdata_out_v => data_act_L2_1);\n');

            for v = 1 : 3
                fprintf(fid, "Sigmoid_functionL2_2_%d : sigmoid_L2\n",v);
                fprintf(fid, "  port map(\n");
                fprintf(fid, "  data_in => data_in_act2_2,\n");
                fprintf(fid, "  data_out => data_act_L2_2_%d);\n",v);
            end
            fprintf(fid, 'VOTADOR_sigmoid_L2_2 : VOT_sigmoid_L2\n');
            fprintf(fid, "  port map(\n");
            for x = 1 : 3
            fprintf(fid, '\t\tdata_out_%d => data_act_L2_2_%d,\n',x,x);
            end
            fprintf(fid, '\t\tdata_out_v => data_act_L2_2);\n');


            fprintf(fid, "--Send the data to the neurons when we are not in padding zone, else send address_in\n");
            for v = 1 : 3
                fprintf(fid, "POOL2_%d : MAXPOOL_LAYER2\n",v);
                fprintf(fid, "port map(\n");
                fprintf(fid, "  clk => clk,\n");
                fprintf(fid, "  rst => rst,\n");
                fprintf(fid, "  index => index2,\n");
                fprintf(fid, "  data_in => data_act_L2_1,\n");
                fprintf(fid, "  data_in2 => data_act_L2_2,\n");
                fprintf(fid, "  data_out => data_pool2_%d);\n",v);
            end
            fprintf(fid, 'VOTADOR_POOL2 : VOT_MAXPOOL_LAYER2\n');
            fprintf(fid, '   port map(\n');
            for x = 1 : 3
                fprintf(fid, '      data_out_%d => data_pool2_%d,\n',x,x);
            end
            fprintf(fid, '      data_out_v => data_pool2);\n');
            fprintf(fid, "\n");
            
        else
            fprintf(fid,' --Layer 2 MaxPool filter\n');
            fprintf(fid,' --It receives two input data because the process is parallelized\n');
            for v = 1 : 3
                fprintf(fid, 'POOL%d_%d : MAXPOOL_LAYER2\n', i , v);
                fprintf(fid, 'port map(\n');
                fprintf(fid, '   clk => clk,\n');
                fprintf(fid, '   rst => rst,\n');
                fprintf(fid, '   index => index2,\n');
                fprintf(fid, '   data_in => data_in_pool%d,\n', i);
                fprintf(fid, '   data_in2 => data_in_pool2_%d,\n', i);
                fprintf(fid, '   data_out => data_out_pool%d_%d);\n', i,v);
            end
            
            fprintf(fid, 'VOTADOR_MAXPOOL_LAYER2 : VOT_MAXPOOL_LAYER2\n');
            fprintf(fid, '   port map(\n');
            for x = 1 : 3
                fprintf(fid, '      data_out_%d => data_out_pool%d_%d,\n',x,i,x);
            end
            fprintf(fid, '      data_out_v => data_out_pool%d);\n',i);

        end
    else
        if(activations(i) == 1)
            fprintf(fid, "data_max_L%d(weight_sizeL%d + fractional_size_L%d + n_extra_bits + 1 downto w_fractional_sizeL%d + fractional_size_L%d + 1) <= (others => '0');\n", i - 1, i - 1, i -1, i - 1, i - 1);
            fprintf(fid, "data_max_L%d(w_fractional_sizeL%d + fractional_size_L%d downto w_fractional_sizeL%d ) <= (others => '1');\n", i - 1, i -1, i - 1, i - 1);
            fprintf(fid, "data_max_L%d(w_fractional_sizeL%d - 1 downto 0) <= (others => '0');\n", i - 1, i - 1);
            fprintf(fid, "\n");
            fprintf(fid, "data_min_L%d(weight_sizeL%d + fractional_size_L%d + n_extra_bits + 1 downto w_fractional_sizeL%d + fractional_size_L%d + 1) <= (others => '1');\n", i - 1, i - 1, i -1, i - 1, i - 1);
            fprintf(fid, "data_min_L%d( w_fractional_sizeL%d + fractional_size_L%d downto 0 ) <= (others => '0');\n", i - 1, i - 1);
            fprintf(fid, "\n");
            fprintf(fid, "process (data_in_pool%d, data_min_L%d, data_max_L%d, data_in_act%d)\n", i, i- 1, i -1, i);
            fprintf(fid, "begin\n");
            fprintf(fid, "\tif (signed(data_in_pool%d) >= data_max_L%d) then\n", i, i -1);
            fprintf(fid, "\t\tdata_in_act%d(input_size_L%d-1) <= '0';\n", i, i);
            fprintf(fid, "\t\tdata_in_act%d(input_size_L%d-2 downto 0) <= (others => '1');\n", i, i);
            fprintf(fid, "\telsif (signed(data_in_pool%d) <= data_min_L%d) then\n", i, i-1);
            fprintf(fid, "\t\tdata_in_act%d(input_size_L%d-1) <= '1';\n", i, i);
            fprintf(fid, "\t\tdata_in_act%d(input_size_L%d-2 downto 0) <= (others => '0');\n", i, i);
            fprintf(fid, "\telse\n");
            fprintf(fid, "\t\tdata_in_act%d<=  data_in_pool%d(w_fractional_sizeL%d + input_size_L%d - 1 downto w_fractional_sizeL%d);\n", i, i, i-1, i, i-1);
            fprintf(fid, "\tend if;\n");
            fprintf(fid, "end process;\n");
            fprintf(fid, "\n");

            for v = 1 : 3
                fprintf(fid, "Sigmoid_functionL%d_%d : sigmoid_L%d\n", i,v, i);
                fprintf(fid, "  port map(\n");
                fprintf(fid, "  data_in =>data_in_act%d,\n", i);
                fprintf(fid, "  data_out => data_act_L%d_%d);\n", i,v);
            end
            fprintf(fid, 'VOTADOR_sigmoid_L%d : VOT_sigmoid_L%d\n', i,i);
            fprintf(fid, "  port map(\n");
            for x = 1 : 3
            fprintf(fid, '\t\tdata_out_%d => data_act_L%d_%d,\n',x, i,x);
            end
            fprintf(fid, '\t\tdata_out_v => data_act_L%d);\n', i);

            for v = 1 : 3
                fprintf(fid, 'POOL%d_%d : MAXPOOL_L%d\n', i, v, i);
                fprintf(fid,' generic map (input_size => input_sizeL%d, weight_size => weight_sizeL%d)     --nï¿½mero de palabras de entrada de la capa\n', i - 1, i - 1);
                fprintf(fid, '   port map(\n');
                fprintf(fid, '   clk => clk,\n');
                fprintf(fid, '   rst => rst,\n');
                fprintf(fid, '   index => index%d,\n',i);
                fprintf(fid, '   data_in => data_act_L%d,\n', i);
                fprintf(fid, '   next_data_pool => next_data_pool%d,\n', i);
                fprintf(fid, '   data_out => data_pool%d_%d);\n', i , v);
            end
            fprintf(fid, 'VOTADOR_MAXPOOL_L%d : VOT_MAXPOOL_L%d\n',i ,i);
                fprintf(fid,' generic map (input_size => input_sizeL%d, weight_size => weight_sizeL%d)     --nï¿½mero de palabras de entrada de la capa\n', i - 1, i - 1);
            fprintf(fid, '   port map(\n');
            for x = 1: 3
                fprintf(fid, '      data_out_%d => data_pool%d_%d,\n',x,i,x);
            end
            fprintf(fid, '      data_out_v => data_pool%d);\n',i);

            fprintf(fid,'\n');
        else
            for v = 1 : 3
                fprintf(fid, 'POOL%d_%d : MAXPOOL_L%d\n', i,v, i);
                fprintf(fid,' generic map (input_size => input_sizeL%d, weight_size => weight_sizeL%d)     --nï¿½mero de palabras de entrada de la capa\n', i - 1, i - 1);
                fprintf(fid, '   port map(\n');
                fprintf(fid, '   clk => clk,\n');
                fprintf(fid, '   rst => rst,\n');
                fprintf(fid, '   index => index%d,\n',i);
                fprintf(fid, '   data_in => data_in_pool%d,\n', i);
                fprintf(fid, '   next_data_pool => next_data_pool%d,\n', i);
                fprintf(fid, '   data_out => data_out_pool%d_%d);\n', i, v);
            end 
            
            fprintf(fid, 'VOTADOR_MAXPOOL_L%d : VOT_MAXPOOL_L%d\n',i,i);
            fprintf(fid, ' generic map (\n input_size => input_sizeL%d; \n weight_size => weight_sizeL%d)\n', i - 1, i - 1);
            fprintf(fid, '   port map(\n');
            for x = 1: 3
                fprintf(fid, 'data_out_%d => data_out_pool%d_%d,\n',x,i,x);
            end
            fprintf(fid, 'data_out_v => data_out_pool%d);\n',i);

            fprintf(fid,'\n');
            fprintf(fid,'--Resize the data before going into the next layer\n');
            fprintf(fid, 'data_pool%d<= data_out_pool%d(w_fractional_sizeL%d + input_sizeL%d - 1 downto w_fractional_sizeL%d);\n',i,i, i - 1, i, i - 1);
            
        end
    end
    
    fprintf(fid,'--Send the data to the neurons when we are not in padding zone, else send zero\n');
    fprintf(fid, 'data_in_layer%d<= data_pool%d when (zero%d = ''0'') else (others=>''0'');\n',i, i, i);
    fprintf(fid,'\n');

    fprintf(fid,'--Convert the data from parallel to serial\n');
    for k = 1 : 3
    fprintf(fid, 'CONVERSORL%d_%d : par2ser  \n', i,k);
    fprintf(fid,' generic map (input_size => input_sizeL%d) \n', i);
    fprintf(fid, 'port map(\n');
    fprintf(fid, '  clk => clk,\n');
    fprintf(fid, '  rst => rst,\n');
    fprintf(fid, '  en_neuron => en_neuronL%d,\n', i);
    fprintf(fid, '  data_in => data_in_layer%d,\n', i);
    fprintf(fid, '  bit_select => count%d,\n', i);
    fprintf(fid, '  bit_out => data_par2serL%d_%d\n', i,k);
    fprintf(fid, ');\n');
    end
    fprintf(fid, 'VOTADOR_PAR2SER_%d : VOT_PAR2SER\n',i);
            fprintf(fid, '   port map(\n');
        for a = 1 : 3
        fprintf(fid, '\t\t serial_out_%d => data_par2serL%d_%d,\n',a, i,a);
        end
        fprintf(fid, '\t\t serial_out_v => data_par2serL%d);\n', i);

    fprintf(fid,'\n');
    fprintf(fid,'--Data sent to the neurons, we only send it when the neurons can process it (enable neuron = 1)\n');
    fprintf(fid, 'data_in_filter%d <= data_par2serL%d when en_neuronL%d= ''1'' else ''0'';\n', i, i, i);
    fprintf(fid,'\n');
    fprintf(fid,'--Control signal to select the corresponding weight at each multiplication\n');
    fprintf(fid, 'address_%d <= mul%d & layer%d;\n', i, i, i);
    fprintf(fid,'\n');
    fprintf(fid,'--Neurons layer %d + ReLu\n', i);
   
    for j = 1 : conv_z(i+1)
        for p = 1 : 3
            fprintf(fid, 'CONV_%d%d_%d : CONV%d%d\n',i, j,p, i, j);
            fprintf(fid, 'port map(\n');
            fprintf(fid, '    clk => clk,\n');
            fprintf(fid, '    rst => rst,\n');
            fprintf(fid, '    data_in => data_in_filter%d,\n', i);
            fprintf(fid, '    address => address_%d,\n', i);
            fprintf(fid, '    bit_select => count%d,\n', i);
            fprintf(fid, '    next_pipeline_step => next_pipeline_step%d,\n', i);
            fprintf(fid, '    data_out => data_in_relu%d%d_%d);\n', i, j,p);
        end
        fprintf(fid, 'VOTADOR_CONV%d%d : VOT_CONV%d%d\n', i,j,i, j);
            fprintf(fid, '   port map(\n');
        for o = 1 : 3
            fprintf(fid, '\t\t    data_out_%d => data_in_relu%d%d_%d,\n',o, i, j,o);
        end
        fprintf(fid, '\t\t    data_out_v => data_in_relu%d%d);\n', i, j);
        for x = 1 : 3
            fprintf(fid, 'RELU_%d%d_%d : RELUL%d\n',i, j,x , i);
            fprintf(fid, ' port map(\n');
            fprintf(fid, '    clk => clk,\n');
            fprintf(fid, '    rst => rst,\n');
            fprintf(fid, '    next_pipeline_step => next_pipeline_step%d,\n', i);
            fprintf(fid, '    data_in => data_in_relu%d%d,\n', i, j);
            fprintf(fid, '    index => index%d,\n', i + 1);
            fprintf(fid, '    data_out => data_out_relu%d%d_%d);  \n',i, j ,x);
        end
        fprintf(fid, 'VOTADOR_RELU%d_%d : VOT_RELUL%d\n', i , j ,i);
            fprintf(fid, '   port map(\n');
        for x = 1 : 3
            fprintf(fid, '\t\t    data_out_%d => data_out_relu%d%d_%d,\n',x, i,j, x);
        end
        fprintf(fid, '\t\t    data_out_v => data_out_relu%d%d);\n', i , j);
    end
end
fprintf(fid,'\n');

fprintf(fid,'--Layer4\n');
fprintf(fid,'--In the last layer we only have a MaxPool filter, therefore we only generate the control signals for said filters and the control signals for communicating with the FC network\n');
for g = 1 : 3
    fprintf(fid, 'GENERADOR%d_%d : GEN%d\n', layers_cnn,g, layers_cnn);
    fprintf(fid, 'port map(\n');
    fprintf(fid, '     clk => clk,\n');
    fprintf(fid, '     rst => rst,\n');
    fprintf(fid, '     rst_red => rst_red,\n');
    fprintf(fid, '     data_in_fc => data_fc,\n');
    fprintf(fid, '     data_in_cnn => data_new_et%d,\n', layers_cnn);
    fprintf(fid, '     data_new => data_processed%d_%d,\n', layers_cnn,g);
    fprintf(fid, '     layer => layer%d_%d,\n', layers_cnn,g);
    fprintf(fid, '     index => index%d_%d,\n', layers_cnn,g);
    fprintf(fid, '     next_data_pool => next_data_pool%d_%d);\n', layers_cnn,g);
    fprintf(fid,'\n');
end
fprintf(fid, 'VOTADOR_GEN%d : VOT_GEN%d\n', layers_cnn,layers_cnn);
            fprintf(fid, '   port map(\n');
        for l = 1 : 3
        fprintf(fid, '\t\t dato_new_%d => data_processed%d_%d,\n',l,layers_cnn,l);
        fprintf(fid,' \t\t layer_%d => layer%d_%d,\n',l, layers_cnn,l);
        fprintf(fid, '\t\t index_%d => index%d_%d,\n',l,layers_cnn,l);
        fprintf(fid, '\t\t next_dato_pool_%d => next_data_pool%d_%d,\n',l,layers_cnn,l);
        end
        fprintf(fid, '\t\t dato_new_v => data_processed%d,\n', layers_cnn);
        fprintf(fid,' \t\t layer_v => layer%d,\n', layers_cnn);
        fprintf(fid, '\t\t index_v => index%d,\n', layers_cnn);
        fprintf(fid, '\t\t next_dato_pool_v => next_data_pool%d);\n', layers_cnn);

fprintf(fid,'--This signal is sent to the FC network to notify when a valid output data is sent by the last MaxPool filter of the network\n');
fprintf(fid, 'data_ready <= next_data_pool%d;\n', layers_cnn);
fprintf(fid,'\n');

% for o = 1 : 3
    fprintf(fid, 'MUX%d : MUX_%d\n', layers_cnn, layers_cnn);
    fprintf(fid, 'port map(\n');
    for j = 1 : conv_z(layers_cnn)
        fprintf(fid, 'data_in%d=> data_out_relu%d%d,\n', j-1,layers_cnn - 1, j);
    end
    fprintf(fid, '    index => layer%d,\n', layers_cnn);
    fprintf(fid, '    data_out => data_in_pool%d); \n', layers_cnn);
    fprintf(fid,'\n');
% end
% fprintf(fid, 'VOTADOR_MUX_%d : VOT_MUX_%d\n',layers_cnn,layers_cnn);
%         fprintf(fid, '   port map(\n');
%         for d = 1 : 3 
%         fprintf(fid, '\t\t data_out_%d => data_in_pool%d_%d, \n',d, layers_cnn,d);
%         end
%         fprintf(fid, '\t\t data_out_v => data_in_pool%d); \n', layers_cnn);

if(activations(layers_cnn) == 1)
    fprintf(fid, "data_max_L%d(weight_sizeL%d + fractional_size_L1fc + n_extra_bits + 1 downto w_fractional_sizeL%d + fractional_size_L1fc + 1) <= (others => '0');\n", layers_cnn - 1, layers_cnn - 1, layers_cnn - 1);
    fprintf(fid, "data_max_L%d(w_fractional_sizeL%d + fractional_size_L1fc downto w_fractional_sizeL%d ) <= (others => '1');\n", layers_cnn - 1,layers_cnn - 1, layers_cnn - 1);
    fprintf(fid, "data_max_L%d(w_fractional_sizeL%d - 1 downto 0) <= (others => '0');\n", layers_cnn - 1,layers_cnn - 1);
    fprintf(fid, "\n");
    fprintf(fid, "data_min_L%d(weight_sizeL%d + fractional_size_L1fc + n_extra_bits + 1 downto w_fractional_sizeL%d + fractional_size_L1fc + 1) <= (others => '1');\n",layers_cnn - 1, layers_cnn - 1, layers_cnn - 1);
    fprintf(fid, "data_min_L%d( w_fractional_sizeL%d + fractional_size_L1fc downto 0 ) <= (others => '0');\n", layers_cnn - 1, layers_cnn - 1);
    fprintf(fid, "\n");
    fprintf(fid, "process (data_in_act%d, data_min_L%d, data_max_L%d, data_in_pool%d)\n", layers_cnn, layers_cnn- 1, layers_cnn -1, layers_cnn);
    fprintf(fid, "begin\n");
    fprintf(fid, "\tif (signed(data_in_pool%d) >= data_max_L%d) then\n", layers_cnn, layers_cnn -1);
    fprintf(fid, "\t\tdata_in_act%d(input_size_L1fc-1) <= '0';\n", layers_cnn);
    fprintf(fid, "\t\tdata_in_act%d(input_size_L1fc-2 downto 0) <= (others => '1');\n", layers_cnn);
    fprintf(fid, "\telsif (signed(data_in_pool%d) <= data_min_L%d) then\n", layers_cnn, layers_cnn-1);
    fprintf(fid, "\t\tdata_in_act%d(input_size_L1fc-1) <= '1';\n", layers_cnn);
    fprintf(fid, "\t\tdata_in_act%d(input_size_L1fc-2 downto 0) <= (others => '0');\n", layers_cnn);
    fprintf(fid, "\telse\n");
    fprintf(fid, "\t\tdata_in_act%d<=  data_in_pool%d(w_fractional_sizeL%d + input_size_L1fc - 1 downto w_fractional_sizeL%d);\n", layers_cnn, layers_cnn, layers_cnn-1, layers_cnn-1);
    fprintf(fid, "\tend if;\n");
    fprintf(fid, "end process;\n");
    fprintf(fid, "\n");
    for v = 1 : 3
        fprintf(fid, "Sigmoid_functionL%d_%d : sigmoid_L%d\n", layers_cnn,v, layers_cnn);
        fprintf(fid, "  port map(\n");
        fprintf(fid, "  data_in => data_in_act%d,\n", layers_cnn);
        fprintf(fid, "  data_out => data_act_L%d_%d);\n", layers_cnn,v);
    end
    fprintf(fid, 'VOTADOR_sigmoid_L%d : VOT_sigmoid_L%d\n', layers_cnn, layers_cnn);
        fprintf(fid, "  port map(\n");
        for x = 1 : 3
        fprintf(fid, '\t\tdata_out_%d => data_act_L%d_%d,\n',x, layers_cnn,x);
        end
        fprintf(fid, '\t\tdata_out_v => data_act_L%d);\n', layers_cnn);

    fprintf(fid,'--Layer %d MaxPool filter \n', layers_cnn);
    for v = 1 : 3
        fprintf(fid, 'POOL%d_%d : MAXPOOL_L%d\n', layers_cnn, v, layers_cnn);
        fprintf(fid,' generic map (input_size => input_sizeL%d, weight_size => weight_sizeL%d)\n', layers_cnn - 1, layers_cnn - 1);
        fprintf(fid, '   port map(\n');
        fprintf(fid, '   clk => clk,\n');
        fprintf(fid, '   rst => rst,\n');
        fprintf(fid, '   index => index%d,\n', layers_cnn);
        fprintf(fid, '   data_in => data_act_L%d,\n', layers_cnn);
        fprintf(fid, '   next_data_pool  => next_data_pool%d,\n', layers_cnn);
        fprintf(fid, '   data_out =>  data_out_%d); \n',v);
    end
    fprintf(fid, 'VOTADOR_MAXPOOL_L%d : VOT_MAXPOOL_L%d\n',layers_cnn,layers_cnn);
    fprintf(fid,' generic map (input_size => input_sizeL%d, weight_size => weight_sizeL%d)\n', layers_cnn - 1, layers_cnn - 1);
    fprintf(fid, '   port map(\n');
        for x = 1: 3
            fprintf(fid, '      data_out_%d =>  data_out_%d,\n',x,x);
        end
        fprintf(fid, '      data_out_v =>  data_out);\n');


else
    fprintf(fid,'--Layer %d MaxPool filter \n', layers_cnn);
    for v = 1 : 3
        fprintf(fid, 'POOL%d_%d : MAXPOOL_L%d\n', layers_cnn,v, layers_cnn);
        fprintf(fid,' generic map (input_size => input_sizeL%d, weight_size => weight_sizeL%d)\n', layers_cnn - 1, layers_cnn - 1);
        fprintf(fid, '   port map(\n');
        fprintf(fid, '   clk => clk,\n');
        fprintf(fid, '   rst => rst,\n');
        fprintf(fid, '   index => index%d,\n', layers_cnn);
        fprintf(fid, '   data_in => data_in_pool%d,\n', layers_cnn);
        fprintf(fid, '   next_data_pool  => next_data_pool%d,\n', layers_cnn);
        fprintf(fid, '   data_out =>  data_out_pool%d_%d ); --This is the data that the FC network receives as input \n', layers_cnn,v);
    end
    fprintf(fid, 'VOTADOR_MAXPOOL_L%d : VOT_MAXPOOL_L%d\n',layers_cnn,layers_cnn );
        fprintf(fid,' generic map (input_size => input_sizeL%d, weight_size => weight_sizeL%d)\n', layers_cnn - 1, layers_cnn - 1);
        fprintf(fid, '   port map(\n');
        for x = 1: 3
            fprintf(fid, 'data_out_%d =>  data_out_pool%d_%d,\n',x, layers_cnn,x);
        end
        fprintf(fid, 'data_out_v =>  data_out_pool%d );\n',layers_cnn);

    fprintf(fid, "data_max_L%d(weight_sizeL%d + fractional_size_L1fc + n_extra_bits + 1 downto w_fractional_sizeL%d + fractional_size_L1fc + 1) <= (others => '0');\n", layers_cnn - 1, layers_cnn - 1, layers_cnn - 1);
    fprintf(fid, "data_max_L%d(w_fractional_sizeL%d + fractional_size_L1fc downto w_fractional_sizeL%d ) <= (others => '1');\n", layers_cnn - 1,layers_cnn - 1, layers_cnn - 1);
    fprintf(fid, "data_max_L%d(w_fractional_sizeL%d - 1 downto 0) <= (others => '0');\n", layers_cnn - 1,layers_cnn - 1);
    fprintf(fid, "\n");
    fprintf(fid, "data_min_L%d(weight_sizeL%d + fractional_size_L1fc + n_extra_bits + 1 downto w_fractional_sizeL%d + fractional_size_L1fc + 1) <= (others => '1');\n",layers_cnn - 1, layers_cnn - 1, layers_cnn - 1);
    fprintf(fid, "data_min_L%d( w_fractional_sizeL%d + fractional_size_L1fc downto 0 ) <= (others => '0');\n", layers_cnn - 1, layers_cnn - 1);
    fprintf(fid, "\n");
    fprintf(fid, 'process (data_out_buff, data_min_L%d, data_max_L%d, data_out_pool%d)\n', layers_cnn - 1, layers_cnn - 1, layers_cnn);
    fprintf(fid, "begin\n");
    fprintf(fid, "\tif (signed(data_out_pool%d) >= data_max_L%d) then\n", layers_cnn, layers_cnn - 1);
    fprintf(fid, "\t\data_out_buff(input_size_L1fc-1) <= '0';\n");
    fprintf(fid, "\t\data_out_buff(input_size_L1fc-2 downto 0) <= (others => '1');\n");
    fprintf(fid, "\telsif (signed(data_out_pool%d) <= data_min_L%d) then\n", layers_cnn, layers_cnn - 1);
    fprintf(fid, "\t\data_out_buff(input_size_L1fc-1) <= '1';\n");
    fprintf(fid, "\t\data_out_buff(input_size_L1fc-2 downto 0) <= (others => '0');\n");
    fprintf(fid, "\telse\n");
    fprintf(fid, '    data_out_buff <= data_out_pool%d(w_fractional_sizeL%d + input_size_L1fc - 1 downto w_fractional_sizeL%d);\n',layers_cnn, layers_cnn - 1, layers_cnn - 1);
    fprintf(fid, "\tend if;\n");
    fprintf(fid, "end process;\n");
    fprintf(fid, "\t data_out <= data_out_buff;\n");
end
fprintf(fid, 'end Behavioral;\n');
fclose(fid);
end