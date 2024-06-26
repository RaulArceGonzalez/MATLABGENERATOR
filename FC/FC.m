% This function generates the module for the FC part of the network
% INPUTS
% Number of neurons in each FC layer
% Number of layers of the network
% Number of layers of FC
function [] = FC(number_of_neurons_FC, layers_fc, outputsFC, riscv, activations_fc,integer_exp_sm,fractional_exp_sm,integer_w_fc,integer_act_fc,n_extra_bits,fractional_w_fc,fractional_act_fc)
name = sprintf('CNN_Network/FC/FC.vhd');
fid = fopen(name, 'wt');
fprintf(fid, '-----------------------------------FC NETWORK-------------------------------------\n');
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
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n\n');
fprintf(fid, 'entity FC is\n');
fprintf(fid, '        Port (\n');
fprintf(fid, '            clk : in STD_LOGIC;\n');
fprintf(fid, '            rst : in STD_LOGIC;\n');
fprintf(fid, '            rst_red : in std_logic;\n');
fprintf(fid, '            start_enable : in STD_LOGIC;\n');
fprintf(fid, '            data_fc : out std_logic;\n');
fprintf(fid, '            finish : out std_logic;\n');
fprintf(fid, '            x : in STD_LOGIC_VECTOR(input_size_L1fc - 1 downto 0);\n');
if(riscv == 1)
    fprintf(fid, '            output_sm : out vector_sm_signed(0 to number_of_outputs_L%dfc - 1);\n', layers_fc);
end
fprintf(fid, '            y : out unsigned(log2c(number_of_outputs_L%dfc) - 1 downto 0)\n', layers_fc);
fprintf(fid, '        );\n');
fprintf(fid, 'end FC;\n\n');
fprintf(fid, 'architecture Behavioral of FC is  \n');
fprintf(fid, '\n--Component declaration \n');
fprintf(fid, '\n--COMMOM MODULES\n');
fprintf(fid, 'component enable_generator is\n');
fprintf(fid, '    Port ( clk : in std_logic;\n');
fprintf(fid, '           rst : in std_logic;\n');
fprintf(fid, '           rst_red : in std_logic;\n');
fprintf(fid, '           start_enable : in std_logic;\n');
fprintf(fid, '           data_fc : out std_logic;\n');
fprintf(fid, '           en_neuron : out std_logic;\n');
fprintf(fid, '           addr_FC : out std_logic_vector(log2c(biggest_ROM_size)-1 downto 0);\n');
fprintf(fid, '           bit_select : out unsigned(log2c(input_size_L1fc)-1 downto 0);\n');
fprintf(fid, '           next_pipeline_step: out std_logic;\n');
fprintf(fid, '           addr_Sm : out std_logic_vector(log2c(number_of_outputs_L%dfc) - 1 downto 0 );\n', layers_fc);
fprintf(fid, '           exp_Sm: out std_logic;\n');
fprintf(fid, '           inv_Sm: out std_logic;\n');
fprintf(fid, '           sum_finish: out std_logic;\n');
fprintf(fid, '           enable_lastlayer : out STD_LOGIC);\n');
fprintf(fid, 'end component;\n');
fprintf(fid, 'component VOT_enable_generator is\n');
fprintf(fid, '    Port ( \n');
for b = 1 : 3
    fprintf(fid, '           data_fc_%d : in std_logic;\n',b);
    fprintf(fid, '           en_neuron_%d : in std_logic;\n',b);
    fprintf(fid, '           addr_FC_%d : in std_logic_vector(log2c(biggest_ROM_size)-1 downto 0);\n',b);
    fprintf(fid, '           bit_select_%d : in unsigned(log2c(input_size_L1fc)-1 downto 0);\n',b);
    fprintf(fid, '           next_pipeline_step_%d: in std_logic;\n',b);
    fprintf(fid, '           addr_Sm_%d : in std_logic_vector(log2c(number_of_outputs_L%dfc) - 1 downto 0 );\n', b,layers_fc);
    fprintf(fid, '           exp_Sm_%d: in std_logic;\n',b);
    fprintf(fid, '           inv_Sm_%d: in std_logic;\n',b);
    fprintf(fid, '           sum_finish_%d: in std_logic;\n',b);
    fprintf(fid, '           enable_lastlayer_%d : in STD_LOGIC;\n',b);
end
fprintf(fid, '           data_fc : out std_logic;\n');
fprintf(fid, '           en_neuron : out std_logic;\n');
fprintf(fid, '           addr_FC : out std_logic_vector(log2c(biggest_ROM_size)-1 downto 0);\n');
fprintf(fid, '           bit_select : out unsigned(log2c(input_size_L1fc)-1 downto 0);\n');
fprintf(fid, '           next_pipeline_step: out std_logic;\n');
fprintf(fid, '           addr_Sm : out std_logic_vector(log2c(number_of_outputs_L%dfc) - 1 downto 0 );\n', layers_fc);
fprintf(fid, '           exp_Sm: out std_logic;\n');
fprintf(fid, '           inv_Sm: out std_logic;\n');
fprintf(fid, '           sum_finish: out std_logic;\n');
fprintf(fid, '           enable_lastlayer : out STD_LOGIC);\n');
fprintf(fid, 'end component;\n');

fprintf(fid, '\n-- Activation function\n');
fprintf(fid, '--component activation_function is\n');
fprintf(fid, '    --Port ( x : in STD_LOGIC_VECTOR (input_size_fc-1 downto 0);\n');
fprintf(fid, '           --y : out STD_LOGIC_VECTOR (input_size_fc-1 downto 0));\n');
fprintf(fid, '--end component;\n');
fprintf(fid, '---Par2ser converters\n');
fprintf(fid, 'component PAR2SER\n');
fprintf(fid, 'generic (input_size : integer := 8);    --number of bits of the input data\n');
fprintf(fid, '  Port ( clk : in std_logic;\n');
fprintf(fid, '         rst : in std_logic;\n');
fprintf(fid, '         data_in : in std_logic_vector (input_size-1 downto 0);\n');
fprintf(fid, '         en_neuron : in std_logic;\n');
fprintf(fid, '         bit_select : in unsigned( log2c(input_size) - 1 downto 0);\n');
fprintf(fid, '         bit_out : out std_logic);\n');
fprintf(fid, 'end component;\n');
fprintf(fid, 'component VOT_PAR2SER is\n');
fprintf(fid, '\t Port (\n');
for a = 1 : 3
        fprintf(fid, '\t\t serial_out_%d : in STD_LOGIC;\n',a);
end
        fprintf(fid, '\t\t serial_out_v : out STD_LOGIC);\n');
fprintf(fid, 'end component;\n');

fprintf(fid, '\n');
fprintf(fid, 'component bit_mux is\n');
fprintf(fid, 'generic (input_size : integer := 8);    --number of bits of the input data\n');
fprintf(fid, '  Port ( data_in : in std_logic_vector (input_size-1 downto 0);\n');
fprintf(fid, '         bit_select : in unsigned (log2c(input_size)-1 downto 0);\n');
fprintf(fid, '         bit_out : out std_logic);\n');
fprintf(fid, 'end component;\n');
fprintf(fid, '\n');
for j = 1 : layers_fc - 1
    fprintf(fid, '---Layer %d Modules\n', j);
    fprintf(fid, 'component Register_FCL%d is\n', j);
    fprintf(fid, 'Port ( data_in : in vector_L%dfc_activations(0 to number_of_inputs_L%dfc-1);\n', j, j + 1);
    fprintf(fid, '       clk : in std_logic;\n');
    fprintf(fid, '       rst : in std_logic;\n');
    fprintf(fid, '       next_pipeline_step : in std_logic;\n');
    fprintf(fid, '       data_out : out vector_L%dfc_activations(0 to number_of_inputs_L%dfc-1));\n', j, j+1);
    fprintf(fid, 'end component;\n');
    fprintf(fid, 'component VOT_Register_FCL%d is\n', j);
    fprintf(fid, 'Port ( \n');
    for b = 1 : 3
        fprintf(fid, '       data_out_%d : in vector_L%dfc_activations(0 to number_of_inputs_L%dfc-1);\n',b, j, j+1);
    end
    fprintf(fid, '       data_out_v : out vector_L%dfc_activations(0 to number_of_inputs_L%dfc-1));\n', j, j+1);
    fprintf(fid, 'end component;\n');
    

    fprintf(fid, 'component Mux_FCL%d is\n', j);
    fprintf(fid, 'Port ( data_in : in vector_L%dfc_activations(0 to number_of_inputs_L%dfc-1);\n', j, j+1);
    fprintf(fid, '       ctrl : in std_logic_vector(log2c(number_of_outputs_L%dfc) - 1 downto 0 );\n', j);
    fprintf(fid, '       mac_max : in signed (input_size_L%dfc+weight_size_L%dfc+n_extra_bits-1 downto 0);\n', j +1, j+1);
    fprintf(fid, '       mac_min : in signed (input_size_L%dfc+weight_size_L%dfc+n_extra_bits-1 downto 0);\n',  j +1, j+1);
    fprintf(fid, '       data_out : out std_logic_vector(input_size_L%dfc-1 downto 0));\n',  j +1);
    fprintf(fid, 'end component;\n');
    % fprintf(fid, 'component VOT_Mux_FCL%d is\n', j);
    % fprintf(fid, 'Port ( \n');
    % for b = 1 : 3
    %     fprintf(fid, '       data_out_%d : in std_logic_vector(input_size_L%dfc-1 downto 0);\n',b,  j +1);
    % end
    % fprintf(fid, '       data_out_v : out std_logic_vector(input_size_L%dfc-1 downto 0));\n',  j +1);
    % fprintf(fid, 'end component;\n');

    fprintf(fid, '-- Layer %d neurons declaration --\n', j);
    for i = 1 : number_of_neurons_FC(j)
        fprintf(fid, 'component layer%d_FCneuron_%d is\n', j, i);
        fprintf(fid, '\tPort ( clk : in std_logic;\n');
        fprintf(fid, '\t\trst : in std_logic;\n');
        fprintf(fid, '\t\tdata_in_bit : in std_logic;\n');
        fprintf(fid, '\t\tnext_pipeline_step : in std_logic;\n');
        fprintf(fid, '\t\tbit_select : in unsigned (log2c(input_size_L%dfc)-1 downto 0);\n', j);
        fprintf(fid, '\t\trom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);\n');
        fprintf(fid, '\t\tneuron_mac : out std_logic_vector(input_size_L%dfc+weight_size_L%dfc + n_extra_bits-1 downto 0));\n', j, j);
        fprintf(fid, 'end component ;\n');
        fprintf(fid, 'component VOT_layer%d_FCneuron_%d is\n', j, i);
        fprintf(fid, '\tPort ( \n');
        for b = 1 : 3
            fprintf(fid, '\t\t neuron_mac_%d : in std_logic_vector(input_size_L%dfc+weight_size_L%dfc + n_extra_bits-1 downto 0);\n',b, j, j);
        end
        fprintf(fid, '\t\t neuron_mac_v : out std_logic_vector(input_size_L%dfc+weight_size_L%dfc + n_extra_bits-1 downto 0));\n', j, j);
        fprintf(fid, 'end component ;');
    end
    if(activations_fc(j) == 1)
        fprintf(fid, '--Activation function for each layer\n');
        fprintf(fid, 'component sigmoidFCL%d is\n', j);
        fprintf(fid, '\tPort ( \n');
        fprintf(fid, '\t\tdata_in : in std_logic_vector(input_size_L%dfc-1 downto 0); \n', j);
        fprintf(fid, '\t\tdata_out : out std_logic_vector(input_size_L%dfc-1 downto 0));\n', j);
        fprintf(fid, 'end component;\n');
        fprintf(fid, 'component VOT_sigmoidFCL%d is\n', j);
        fprintf(fid, '\tPort ( \n');
        for b = 1 : 3
            fprintf(fid, '\t\tdata_out_%d : in std_logic_vector(input_size_L%dfc-1 downto 0);\n',b, j);
        end
        fprintf(fid, '\t\tdata_out_v : out std_logic_vector(input_size_L%dfc-1 downto 0));\n', j);
        fprintf(fid, 'end component;\n');
    end
end
fprintf(fid, '\n');

fprintf(fid, '--Softmax Layer\n');
fprintf(fid, 'component exponential is\n');
fprintf(fid, 'Port (  data_in : in std_logic_vector (input_size_L%dfc-1 downto 0);\n', layers_fc);
fprintf(fid, '        data_out : out std_logic_vector (input_size_L%dfc-1 downto 0));\n', layers_fc);
fprintf(fid, 'end component;\n\n');
fprintf(fid, 'component VOT_exponential is\n');
fprintf(fid, 'Port (  \n' );
for b = 1 : 3
    fprintf(fid, '        data_out_%d : in std_logic_vector (input_size_L%dfc-1 downto 0);\n', b, layers_fc);
end
fprintf(fid, '        data_out_v : out std_logic_vector (input_size_L%dfc-1 downto 0));\n', layers_fc);
fprintf(fid, 'end component;\n\n');

fprintf(fid, 'component Reg_softmax_1 is\n');
fprintf(fid, 'Port ( clk : in STD_LOGIC;\n');
fprintf(fid, '       rst : in STD_LOGIC;\n');
fprintf(fid, '       data_in : in std_logic_vector(input_size_L%dfc - 1 downto 0);\n', layers_fc);
fprintf(fid, '       index : in unsigned(log2c(number_of_outputs_L%dfc) - 1 downto 0 );\n', layers_fc);
fprintf(fid, '       data_out : out vector_sm(number_of_outputs_L%dfc - 1 downto 0));\n', layers_fc);
fprintf(fid, 'end component;\n\n');
fprintf(fid, 'component VOT_Reg_softmax_1 is\n');
fprintf(fid, 'Port ( \n');
for b = 1 : 3
    fprintf(fid, '       data_out_%d : in vector_sm(number_of_outputs_L%dfc - 1 downto 0);\n',b, layers_fc);
end
fprintf(fid, '       data_out_v : out vector_sm(number_of_outputs_L%dfc - 1 downto 0));\n', layers_fc);
fprintf(fid, 'end component;\n\n');

fprintf(fid, 'component inverse is\n');
fprintf(fid, 'Port ( data_in : in std_logic_vector (input_size_L%dfc-1 downto 0);\n', layers_fc);
fprintf(fid, '       data_out : out std_logic_vector (input_size_L%dfc-1 downto 0)\n', layers_fc);
fprintf(fid, '    );\n');
fprintf(fid, 'end component;\n\n');
fprintf(fid, 'component VOT_inverse is\n');
fprintf(fid, 'Port ( \n' );
for b = 1 : 3
    fprintf(fid, '       data_out_%d : in std_logic_vector (input_size_L%dfc-1 downto 0);\n',b, layers_fc);
end
fprintf(fid, '       data_out_v : out std_logic_vector (input_size_L%dfc-1 downto 0)\n', layers_fc);
fprintf(fid, '    );\n');
fprintf(fid, 'end component;\n\n');

fprintf(fid, 'component Reg_softmax_2 is\n');
fprintf(fid, 'Port ( clk : in STD_LOGIC;\n');
fprintf(fid, '       rst : in STD_LOGIC;\n');
fprintf(fid, '       data_in : in std_logic_vector(input_size_L%dfc - 1 downto 0);\n', layers_fc);
fprintf(fid, '       reg_Sm : in std_logic;\n');
fprintf(fid, '       data_out : out std_logic_vector(input_size_L%dfc - 1 downto 0) \n', layers_fc);
fprintf(fid, ');\n');
fprintf(fid, 'end component;\n\n');
fprintf(fid, 'component VOT_Reg_softmax_2 is\n');
fprintf(fid, 'Port (  \n');
for b = 1 : 3
    fprintf(fid, '       data_out_%d : in std_logic_vector(input_size_L%dfc - 1 downto 0); \n',b, layers_fc);
end
fprintf(fid, '       data_out_v : out std_logic_vector(input_size_L%dfc - 1 downto 0) \n', layers_fc);
fprintf(fid, ');\n');
fprintf(fid, 'end component;\n\n');

fprintf(fid, 'component sum is\n');
fprintf(fid, 'Port (  clk : in std_logic;\n');
fprintf(fid, '        rst : in std_logic;\n');
fprintf(fid, '        data_in_bit : in std_logic;\n');
fprintf(fid, '        next_pipeline_step : in std_logic;\n');
fprintf(fid, '        bit_select : in unsigned (log2c(input_size_L%dfc)-1 downto 0);\n', layers_fc);
fprintf(fid, '        neuron_mac : out std_logic_vector (input_size_L%dfc-1 downto 0)\n', layers_fc);
fprintf(fid, '    );\n');
fprintf(fid, 'end component;\n');
fprintf(fid, 'component VOT_sum is\n');
fprintf(fid, 'Port (  \n');
for b = 1 : 3
    fprintf(fid, '        neuron_mac_%d : in std_logic_vector (input_size_L%dfc-1 downto 0);\n',b, layers_fc);
end
fprintf(fid, '        neuron_mac_v : out std_logic_vector (input_size_L%dfc-1 downto 0)\n', layers_fc);
fprintf(fid, '    );\n');
fprintf(fid, 'end component;\n');

fprintf(fid, '\n');
fprintf(fid, '-- Softmax layer Neurons declaration --\n');
for i = 1 : number_of_neurons_FC(end)
    fprintf(fid,'component layer_out_neuron_%d is\n', i);
    fprintf(fid,'\tPort ( clk : in STD_LOGIC;\n');
    fprintf(fid,'\t\trst : in STD_LOGIC;\n');
    fprintf(fid,'\t\tdata_in_bit : in STD_LOGIC;\n');
    fprintf(fid,'\t\tbit_select : in unsigned (log2c(input_size_L%dfc)-1 downto 0);\n', layers_fc);
    fprintf(fid,'\t\tweight : in signed(input_size_L%dfc-1 downto 0);\n', layers_fc);
    fprintf(fid,'\t\tnext_pipeline_step : in std_logic;\n');
    fprintf(fid,'\t\tneuron_mac : out STD_LOGIC_VECTOR (input_size_L%dfc-1 downto 0));\n', layers_fc);
    fprintf(fid,'end component;\n');
    fprintf(fid,'component VOT_layer_out_neuron_%d is\n', i);
    fprintf(fid,'\tPort ( \n');
    for b = 1 : 3
        fprintf(fid,'\t\t neuron_mac_%d : in STD_LOGIC_VECTOR (input_size_L%dfc-1 downto 0);\n',b, layers_fc);
    end
    fprintf(fid,'\t\t neuron_mac_v : out STD_LOGIC_VECTOR (input_size_L%dfc-1 downto 0));\n', layers_fc);
    fprintf(fid,'end component;');

end
fprintf(fid, '\n');
fprintf(fid, '-- Last register and threshold function\n');
fprintf(fid,'component Register_FCLast is\n');
fprintf(fid,'\tPort ( \n');
fprintf(fid,'\t\tclk : in STD_LOGIC;\n');
fprintf(fid,'\t\trst : in STD_LOGIC;\n');
fprintf(fid,'\t\tnext_pipeline_step : in STD_LOGIC;\n');
fprintf(fid,'\t\tdata_in : in vector_sm(0 to number_of_outputs_L%dfc-1);\n', layers_fc);
fprintf(fid,'\t\tstart_threshold : out std_logic;\n');
fprintf(fid,'\t\tdata_out : out vector_sm_signed(0 to number_of_outputs_L%dfc-1));\n', layers_fc);
fprintf(fid,'end component;\n\n');
fprintf(fid,'component VOT_Register_FCLast is\n');
fprintf(fid,'\tPort ( \n');
for b = 1 : 3
    fprintf(fid,'\t\t start_threshold_%d : in std_logic;\n',b);
    fprintf(fid,'\t\t data_out_%d : in vector_sm_signed(0 to number_of_outputs_L%dfc-1);\n',b, layers_fc);
end
fprintf(fid,'\t\t start_threshold : out std_logic;\n');
fprintf(fid,'\t\t data_out : out vector_sm_signed(0 to number_of_outputs_L%dfc-1));\n', layers_fc);
fprintf(fid,'end component;\n\n');

fprintf(fid,'component threshold is\n');
fprintf(fid,'\tPort ( clk : std_logic;\n');
fprintf(fid,'\t      rst : std_logic;\n');
fprintf(fid,'\t      y_in : in vector_sm_signed(0 to number_of_outputs_L%dfc-1);\n', layers_fc);
fprintf(fid,'\t      start : in std_logic;\n');
fprintf(fid,'\t      y_out : out unsigned(log2c(number_of_outputs_L%dfc) -1 downto 0);\n', layers_fc);
fprintf(fid,'\t      finish : out std_logic);\n');
fprintf(fid,'end component;\n');
fprintf(fid,'component VOT_threshold is\n' );
fprintf(fid,'\tPort ( \n');
for b = 1 : 3 
    fprintf(fid,'\t      y_out_%d : in unsigned(log2c(number_of_outputs_L%dfc) -1 downto 0);\n',b, layers_fc);
    fprintf(fid,'\t      finish_%d : in std_logic;\n',b);
end
fprintf(fid,'\t      y_out : out unsigned(log2c(number_of_outputs_L%dfc) -1 downto 0);\n', layers_fc);
fprintf(fid,'\t      finish : out std_logic);\n');
fprintf(fid,'end component;\n');

fprintf(fid, '\n');
fprintf(fid, '--------------AUXILIARY SIGNALS-------------------\n');
fprintf(fid, '-- GLOBAL SIGNALS --\n');
for b = 1 : 3
    fprintf(fid, 'signal bit_select_%d :  unsigned (log2c(input_size_L1fc)-1 downto 0);\n',b);
    fprintf(fid, 'signal rom_addr_FC_%d: STD_LOGIC_VECTOR (log2c(biggest_ROM_size)-1 downto 0);\n',b);
    fprintf(fid, 'signal rom_addr_Sm_%d : std_logic_vector(log2c(number_of_outputs_L%dfc) - 1 downto 0 );\n',b, layers_fc);
    fprintf(fid, 'signal next_pipeline_step_%d, enable_lastlayer_%d, en_neuron_%d :  STD_LOGIC;\n',b,b,b);
end
fprintf(fid, 'signal bit_select :  unsigned (log2c(input_size_L1fc)-1 downto 0);\n');
fprintf(fid, 'signal rom_addr_FC: STD_LOGIC_VECTOR (log2c(biggest_ROM_size)-1 downto 0);\n');
fprintf(fid, 'signal rom_addr_Sm : std_logic_vector(log2c(number_of_outputs_L%dfc) - 1 downto 0 );\n', layers_fc);
fprintf(fid, 'signal next_pipeline_step, enable_lastlayer, en_neuron :  STD_LOGIC;\n');
fprintf(fid, '\n');
for i = 1 : layers_fc - 1
    fprintf(fid, '-- LAYER %d SIGNALS --\n', i);
    for b = 1 : 3
        fprintf(fid, 'signal bit_selected_L%d_%d : STD_LOGIC := ''0'';\n' ,i,b);
        fprintf(fid, 'signal layer_%d_neurons_mac_%d : vector_L%dFC_activations(0 to number_of_inputs_L%dfc - 1);\n', i,b, i, i+1);
        fprintf(fid, 'signal data_out_register_L%d_%d : vector_L%dFC_activations(0 to number_of_inputs_L%dfc - 1);\n', i,b, i, i+1);
        fprintf(fid, 'signal data_out_multiplexer_L%d_%d, data_in_L%d_%d: STD_LOGIC_VECTOR(input_size_L%dfc-1 downto 0);\n', i ,b, i+1,b, i+1);
    end
    fprintf(fid, 'signal data_in_register_L%d : vector_L%dFC(0 to number_of_inputs-1);\n', i, i);
    fprintf(fid, 'signal bit_selected_L%d, data_inL%d : STD_LOGIC := ''0'';\n' ,i, i);
    fprintf(fid, 'signal ctrl_muxL%d : std_logic_vector(log2c(number_of_outputs_L%dfc) - 1 downto 0 );\n',i, i);
    fprintf(fid, 'signal layer_%d_neurons_mac : vector_L%dFC_activations(0 to number_of_inputs_L%dfc - 1);\n', i, i, i+1);
    fprintf(fid, 'signal data_out_register_L%d : vector_L%dFC_activations(0 to number_of_inputs_L%dfc - 1);\n', i, i, i+1);
    fprintf(fid, 'signal data_out_multiplexer_L%d, data_in_L%d: STD_LOGIC_VECTOR(input_size_L%dfc-1 downto 0);\n', i , i+1, i+1);
    fprintf(fid, '-- Signs with the maximum and maximum values that neuron_mac can take --\n');
    fprintf(fid, 'signal mac_max_L%d, mac_min_L%d : signed (input_size_L%dfc+weight_size_L%dfc+n_extra_bits-1 downto 0) := (others => ''0'');\n', i, i, i + 1, i + 1);
end
fprintf(fid, '\n');
fprintf(fid, '--SOFTMAX SIGNALS\n');
for b = 1 : 3
    fprintf(fid, 'signal data_out_exponential_%d, inverse_result_%d,data_inverse_reg_%d, sum_expo_%d, data_in_sum_%d : std_logic_vector(input_size_L%dfc - 1 downto 0);\n',b,b,b,b,b, layers_fc);
    fprintf(fid, 'signal bit_selected_sum_%d,sum_finish_%d, bit_selected_softmax_%d, start_th_%d, exp_Sm_%d, inv_Sm_%d : std_logic;\n',b,b,b,b,b,b);
    fprintf(fid, 'signal data_in_softmax_%d : vector_sm(number_of_inputs_L%dfc - 1 downto 0);\n',b, layers_fc);
    fprintf(fid, 'signal layer_out_neurons_mac_%d : vector_sm(0 to number_of_outputs_L%dfc - 1);\n', b,layers_fc);
    fprintf(fid, 'signal data_out_register_L_out_%d : vector_sm_signed(0 to number_of_outputs_L%dfc - 1);\n',b, layers_fc);
end
fprintf(fid, 'signal data_out_exponential, data_in_inverse, inverse_result,data_inverse_reg, sum_expo, data_in_sum : std_logic_vector(input_size_L%dfc - 1 downto 0);\n', layers_fc);
fprintf(fid, 'signal bit_selected_sum,sum_finish, bit_selected_softmax, start_th, exp_Sm, inv_Sm : std_logic;\n');
fprintf(fid, 'signal data_in_softmax : vector_sm(number_of_inputs_L%dfc - 1 downto 0);\n', layers_fc);
fprintf(fid, '-- OUTER LAYER SIGNALS --\n');
fprintf(fid, 'signal layer_out_neurons_mac : vector_sm(0 to number_of_outputs_L%dfc - 1);\n', layers_fc);
fprintf(fid, 'signal data_out_register_L_out : vector_sm_signed(0 to number_of_outputs_L%dfc - 1);\n', layers_fc);

for b = 1 : 3
    fprintf(fid, 'signal y_%d : unsigned(log2c(number_of_outputs_L%dfc) - 1 downto 0);\n',b, layers_fc);
    fprintf(fid, 'signal finish_%d,data_fc_%d : std_logic;\n',b,b);
end

fprintf(fid, 'begin\n\n');

fprintf(fid, '--Generates the control signal to manage the complete FC network\n');
for b = 1 : 3
    fprintf(fid, 'ENABLE_%d : enable_generator\n',b);
    fprintf(fid, 'port map ( clk => clk,\n');
    fprintf(fid, '           rst => rst,\n');
    fprintf(fid, '           rst_red => rst_red,\n');
    fprintf(fid, '           start_enable => start_enable,\n');
    fprintf(fid, '           bit_select => bit_select_%d,\n',b);
    fprintf(fid, '           en_neuron => en_neuron_%d,\n',b);
    fprintf(fid, '           sum_finish => sum_finish_%d,\n',b);
    fprintf(fid, '           data_fc => data_fc_%d,\n',b);
    fprintf(fid, '           addr_FC => rom_addr_FC_%d,\n',b);
    fprintf(fid, '           addr_Sm => rom_addr_Sm_%d,\n',b);
    fprintf(fid, '           exp_Sm => exp_Sm_%d,\n',b);
    fprintf(fid, '           inv_Sm => inv_Sm_%d,\n',b);
    fprintf(fid, '           enable_lastlayer => enable_lastlayer_%d,\n',b);
    fprintf(fid, '           next_pipeline_step => next_pipeline_step_%d);\n\n',b);
end
fprintf(fid, 'VOT_ENABLE : VOT_enable_generator\n');
fprintf(fid, 'port map ( \n');
for b = 1 : 3
    fprintf(fid, '           data_fc_%d => data_fc_%d,\n',b,b);
    fprintf(fid, '           en_neuron_%d => en_neuron_%d,\n',b,b);
    fprintf(fid, '           addr_FC_%d => rom_addr_FC_%d,\n',b,b);
    fprintf(fid, '           bit_select_%d => bit_select_%d,\n',b,b);
    fprintf(fid, '           next_pipeline_step_%d => next_pipeline_step_%d,\n',b,b);
    fprintf(fid, '           addr_Sm_%d => rom_addr_Sm_%d,\n', b,b);
    fprintf(fid, '           exp_Sm_%d => exp_Sm_%d,\n',b,b);
    fprintf(fid, '           inv_Sm_%d => inv_Sm_%d,\n',b,b);
    fprintf(fid, '           sum_finish_%d => sum_finish_%d,\n',b,b);
    fprintf(fid, '           enable_lastlayer_%d => enable_lastlayer_%d,\n',b,b);
end
fprintf(fid, '           data_fc => data_fc,\n');
fprintf(fid, '           en_neuron => en_neuron,\n');
fprintf(fid, '           addr_FC => rom_addr_FC,\n');
fprintf(fid, '           bit_select => bit_select,\n');
fprintf(fid, '           next_pipeline_step => next_pipeline_step,\n');
fprintf(fid, '           addr_Sm => rom_addr_Sm,\n');
fprintf(fid, '           exp_Sm => exp_Sm,\n');
fprintf(fid, '           inv_Sm => inv_Sm,\n');
fprintf(fid, '           sum_finish => sum_finish,\n');
fprintf(fid, '           enable_lastlayer => enable_lastlayer);\n');

fprintf(fid, '--Conversion of the input data from the CNN from parallel to serial, we need to use PAR2SER instead of BitMux because the influx of data is not constant\n');
for b = 1 : 3
    fprintf(fid, 'PAR2SER_L1_%d: PAR2SER\n',b);
    fprintf(fid, 'generic map (input_size => input_size_L1fc)\n');
    fprintf(fid, 'port map ( clk => clk,\n');
    fprintf(fid, '           rst => rst,\n');
    fprintf(fid, '           data_in => x,\n');
    fprintf(fid, '           en_neuron => en_neuron,\n');
    fprintf(fid, '           bit_select => bit_select,\n');
    fprintf(fid, '           bit_out => bit_selected_L1_%d);\n\n',b);
end
fprintf(fid, 'VOT_PAR2SER_L1: VOT_PAR2SER \n');
fprintf(fid, 'port map ( \n');
for a = 1 : 3
        fprintf(fid, '\t\t serial_out_%d => bit_selected_L1_%d,\n',a,a);
end
        fprintf(fid, '\t\t serial_out_v => bit_selected_L1);\n');
fprintf(fid, '\n');
fprintf(fid, '--Data is sent from the parallel to serial converter when en_neuron = 1 and the neurons can process it\n');
fprintf(fid, ' data_inL1 <= bit_selected_L1 when (en_neuron = ''1'') else ''0'';\n');
fprintf(fid, '-- Layer 1 Neurons instantiation\n');
for i = 1:number_of_neurons_FC(1)
    for b = 1 : 3
        fprintf(fid, 'LAYER_1_NEU_%d_%d: layer1_FCneuron_%d\n', i,b,i);
        fprintf(fid, 'port map ( clk => clk,\n');
        fprintf(fid, '           rst => rst,\n');
        fprintf(fid, '           next_pipeline_step => next_pipeline_step,\n');
        fprintf(fid, '           data_in_bit => data_inL1,\n');
        fprintf(fid, '           bit_select => bit_select,\n');
        fprintf(fid, '           rom_addr => rom_addr_FC,\n');
        fprintf(fid, '           neuron_mac => layer_1_neurons_mac_%d(%d));\n',b, i-1);
    end
    fprintf(fid, 'VOT_LAYER_1_NEU_%d : VOT_layer1_FCneuron_%d \n', i, i);
        fprintf(fid, 'port map ( \n');
        for b = 1 : 3
            fprintf(fid, '\t\t neuron_mac_%d => layer_1_neurons_mac_%d(%d),\n',b, b, i-1);
        end
        fprintf(fid, '\t\t neuron_mac_v => layer_1_neurons_mac(%d));\n', i-1);
end
fprintf(fid, '-- Register of the output data from the neurons\n');
for b = 1 : 3
    fprintf(fid, 'LAYER_1_REG_%d: Register_FCL1 \n',b);
    fprintf(fid, 'port map ( clk => clk, \n');
    fprintf(fid, '           rst => rst,\n');
    fprintf(fid, '           data_in => layer_1_neurons_mac, \n');
    fprintf(fid, '           next_pipeline_step => next_pipeline_step,\n');
    fprintf(fid, '           data_out => data_out_register_L1_%d);  \n',b);
    fprintf(fid, '\n');
end
fprintf(fid, 'VOT_LAYER_1_REG: VOT_Register_FCL1 \n');
    fprintf(fid, 'port map (  \n');
    for b = 1 : 3
        fprintf(fid, '       data_out_%d => data_out_register_L1_%d,\n',b,b);
    end
    fprintf(fid, '       data_out_v => data_out_register_L1);\n');

fprintf(fid, ' -- Assignment of value to the max and min signals for layer 1--\n');
fprintf(fid, "mac_max_L1(weight_size_L2fc + fractional_size_L2fc + n_extra_bits + 1 downto w_fractional_size_L2fc + fractional_size_L2fc + 1) <= (others => '0');\n");
fprintf(fid, "mac_max_L1(w_fractional_size_L2fc + fractional_size_L2fc downto w_fractional_size_L2fc ) <= (others => '1');\n");
fprintf(fid, "mac_max_L1(w_fractional_size_L2fc - 1 downto 0) <= (others => '0');\n");
fprintf(fid, "\n");
fprintf(fid, "mac_min_L1(weight_size_L2fc + fractional_size_L2fc + n_extra_bits + 1 downto w_fractional_size_L2fc + fractional_size_L2fc + 1) <= (others => '1');\n");
fprintf(fid, "mac_min_L1( w_fractional_size_L2fc + fractional_size_L2fc downto 0 ) <= (others => '0');\n");
fprintf(fid, "\n");
fprintf(fid, ' ctrl_muxL1 <= rom_addr_Fc(log2c(number_of_outputs_L1fc) - 1 downto 0 );\n');
% for b = 1 : 3
    fprintf(fid, 'LAYER_1_MUX: Mux_FCL1 \n');
    fprintf(fid, 'port map ( data_in => data_out_register_L1, \n');
    if(layers_fc == 2)
        fprintf(fid, '           ctrl => rom_addr_Sm, \n');
    else
        fprintf(fid, '           ctrl => ctrl_muxL1, \n');
    end
    fprintf(fid, '           mac_max => mac_max_L1,\n');
    fprintf(fid, '           mac_min => mac_min_L1,\n');
    fprintf(fid, '           data_out => data_out_multiplexer_L1); \n');
% end
% fprintf(fid, 'VOT_LAYER_1_MUX : VOT_Mux_FCL1\n');
%     fprintf(fid, 'port map (  \n');
%     for b = 1 : 3
%         fprintf(fid, '       data_out_%d => data_out_multiplexer_L1_%d, \n',b,b);
%     end
%     fprintf(fid, '       data_out_v => data_out_multiplexer_L1); \n');

if(activations_fc(1) ==1)
    for b = 1 : 3
        fprintf(fid, 'Sigmoid_functionFCL1_%d : sigmoidFCL1\n',b);
        fprintf(fid, '   port map(\n');
        fprintf(fid, '   data_in => data_out_multiplexer_L1,\n');
        fprintf(fid, '   data_out => data_in_L2_%d);\n',b);
    end
    fprintf(fid, 'VOT_Sigmoid_functionFCL1 : VOT_sigmoidFCL1 \n');
    fprintf(fid, '   port map(\n');
        for b = 1 : 3
            fprintf(fid, '\t\tdata_out_%d => data_in_L2_%d,\n',b,b);
        end
        fprintf(fid, '\t\tdata_out_v => data_in_L2);\n');
else
    fprintf(fid,'data_in_L2 <= data_out_multiplexer_L1\n');
end
for j = 2 : layers_fc - 1
    for b = 1 : 3
        fprintf(fid, 'PAR2SER_L%d_%d: PAR2SER\n', j,b);
        fprintf(fid, 'generic map (input_size => input_size_L%dfc)\n', j);
        fprintf(fid, 'port map ( clk => clk,\n');
        fprintf(fid, '           rst => rst,\n');
        fprintf(fid, '           data_in => data_in_L%d,\n', j);
        fprintf(fid, '           en_neuron => en_neuron,\n');
        fprintf(fid, '           bit_select => bit_select,\n');
        fprintf(fid, '           bit_out => bit_selected_L%d_%d);\n\n', j,b);
    end
    fprintf(fid, 'VOT_PAR2SER_L%d: VOT_PAR2SER \n',j);
    fprintf(fid, 'port map ( \n');
    for a = 1 : 3
            fprintf(fid, '\t\t serial_out_%d => bit_selected_L%d_%d,\n',a,j,a);
    end
            fprintf(fid, '\t\t serial_out_v => bit_selected_L%d);\n',j);

    fprintf(fid, '-- Layer 1 Neurons instantiation\n');
    for i = 1:number_of_neurons_FC(j)
        for b = 1 : 3
            fprintf(fid, 'LAYER_%d_NEU_%d_%d: layer%d_FCneuron_%d\n',j,i,b,j,i);
            fprintf(fid, 'port map ( clk => clk,\n');
            fprintf(fid, '           rst => rst,\n');
            fprintf(fid, '           next_pipeline_step => next_pipeline_step,\n');
            fprintf(fid, '           data_in_bit => bit_selected_L%d,\n', j);
            fprintf(fid, '           bit_select => bit_select,\n');
            fprintf(fid, '           rom_addr => rom_addr_FC,\n');
            fprintf(fid, '           neuron_mac => layer_%d_neurons_mac_%d(%d));\n', j,b, i-1);
        end
        fprintf(fid, 'VOT_LAYER_%d_NEU_%d : VOT_layer%d_FCneuron_%d \n',j, i, j, i);
        fprintf(fid, 'port map ( \n');
        for b = 1 : 3
            fprintf(fid, '\t\t neuron_mac_%d => layer_%d_neurons_mac_%d(%d),\n',b,j, b, i-1);
        end
        fprintf(fid, '\t\t neuron_mac_v => layer_%d_neurons_mac(%d));\n',j, i-1);
    end
    fprintf(fid, '-- Register of the output data from the neurons\n');
    for b = 1 : 3
        fprintf(fid, 'LAYER_%d_REG_%d: Register_FCL%d \n', j,b, j);
        fprintf(fid, 'port map ( clk => clk, \n');
        fprintf(fid, '           rst => rst,\n');
        fprintf(fid, '           data_in => layer_%d_neurons_mac, \n', j);
        fprintf(fid, '           next_pipeline_step => next_pipeline_step,\n');
        fprintf(fid, '           data_out => data_out_register_L%d_%d);  \n', j,b);
    end
    fprintf(fid, 'VOT_LAYER_%d_REG: VOT_Register_FCL%d \n',j,j);
    fprintf(fid, 'port map (  \n');
    for b = 1 : 3
        fprintf(fid, '       data_out_%d => data_out_register_L%d_%d,\n',b,j,b);
    end
    fprintf(fid, '       data_out_v => data_out_register_L%d);\n',j);

    fprintf(fid, '                                      \n');
    fprintf(fid, ' -- Assignment of value to the max and min signals for layer 1--\n');
    if  ( j ==  layers_fc - 1 )
        fprintf(fid, 'mac_max_L%d <= "%s";\n',j, dec2q(q2dec('01111111',integer_exp_sm,fractional_exp_sm,'bin'), integer_w_fc+integer_act_fc+n_extra_bits+1,fractional_w_fc+fractional_act_fc,'bin'));
        fprintf(fid, 'mac_max_L%d <= "%s";\n',j, dec2q(q2dec('10000000',integer_exp_sm,fractional_exp_sm,'bin'), integer_w_fc+integer_act_fc+n_extra_bits+1,fractional_w_fc+fractional_act_fc,'bin'));
    else    
        fprintf(fid, "mac_max_L%d(weight_size_L%dfc + fractional_size_L%dfc + n_extra_bits + 1 downto w_fractional_size_L%dfc + fractional_size_L%dfc + 1) <= (others => '0');\n", j, j , j  , j, j );
        fprintf(fid, "mac_max_L%d(w_fractional_size_L%dfc + fractional_size_L%dfc downto w_fractional_size_L%dfc ) <= (others => '1');\n", j, j , j  , j);
        fprintf(fid, "mac_max_L%d(w_fractional_size_L%dfc - 1 downto 0) <= (others => '0');\n", j, j );
        fprintf(fid, "\n");
        
        fprintf(fid, "mac_min_L%d(weight_size_L%dfc + fractional_size_L%dfc + n_extra_bits + 1 downto w_fractional_size_L%dfc + fractional_size_L%dfc + 1) <= (others => '1');\n", j, j , j , j, j);
        fprintf(fid, "mac_min_L%d( w_fractional_size_L%dfc + fractional_size_L%dfc downto 0 ) <= (others => '0');\n", j, j , j );
    end
    fprintf(fid, "\n");
    %fprintf(fid, ' mac_max_L2  <= "000001111111000000";\n' );
    %fprintf(fid, ' mac_min_L2  <= "111110000000000000"\n');
    fprintf(fid, ' ctrl_muxL%d  <= rom_addr_Fc(log2c(number_of_outputs_L%dfc) - 1 downto 0 );\n', j, j );
    % for b = 1 : 3
        fprintf(fid, 'LAYER_%d_MUX: Mux_FCL%d \n', j, j);
        fprintf(fid, 'port map ( data_in => data_out_register_L%d, \n', j);
        if (j == layers_fc - 1)
            fprintf(fid, '           ctrl => rom_addr_Sm, \n');
        else
            fprintf(fid, '           ctrl => ctrl_muxL%d, \n', j);
        end
        fprintf(fid, '           mac_max => mac_max_L%d,\n', j);
        fprintf(fid, '           mac_min => mac_min_L%d,\n', j);
        fprintf(fid, '           data_out => data_out_multiplexer_L%d); \n', j);
    % end
    % fprintf(fid, 'VOT_LAYER_%d_MUX : VOT_Mux_FCL%d\n',j,j);
    % fprintf(fid, 'port map (  \n');
    % for b = 1 : 3
    %     fprintf(fid, '       data_out_%d => data_out_multiplexer_L%d_%d, \n',b,j,b);
    % end
    % fprintf(fid, '       data_out_v => data_out_multiplexer_L%d); \n',j);

    if(activations_fc(j) == 1)
        for b = 1 : 3
            fprintf(fid, 'Sigmoid_functionFCL%d_%d : sigmoidFCL%d\n', j ,b, j );
            fprintf(fid, '   port map(\n');
            fprintf(fid, '   data_in => data_out_multiplexer_L%d,\n', j);
            fprintf(fid, '   data_out => data_in_L%d_%d);\n', j +1,b);
        end
        fprintf(fid, 'VOT_Sigmoid_functionFCL%d : VOT_sigmoidFCL%d \n',j,j);
        fprintf(fid, '   port map(\n');
        for b = 1 : 3
            fprintf(fid, '\t\tdata_out_%d => data_in_L%d_%d,\n',b,j+1,b);
        end
        fprintf(fid, '\t\tdata_out_v => data_in_L%d);\n',j+1);
    else
        fprintf(fid,'data_in_L%d <= data_out_multiplexer_L%d;\n', j + 1, j);
    end
end
fprintf(fid, '\n');
fprintf(fid, '------------SOFTMAX IMPLEMENTATION--------------------\n');
fprintf(fid, '--First step is to perform the exponential of each input\n');
for b = 1 : 3
    fprintf(fid, 'EXP_%d : exponential\n',b);
    fprintf(fid, 'port map ( data_in => data_in_L%d,\n', layers_fc);
    fprintf(fid, '           data_out => data_out_exponential_%d);\n',b);
end
fprintf(fid, 'VOT_EXP : VOT_exponential \n');
fprintf(fid, '   port map(\n');
for b = 1 : 3
    fprintf(fid, '        data_out_%d => data_out_exponential_%d,\n',b,b);
end
fprintf(fid, '        data_out_v => data_out_exponential);\n');

for b = 1 : 3
    fprintf(fid, 'Register_softmax_exp_%d : Reg_softmax_2\n',b);
    fprintf(fid, '    port map (\n');
    fprintf(fid, '        clk => clk,\n');
    fprintf(fid, '        rst => rst,\n');
    fprintf(fid, '        data_in => data_out_exponential,\n');
    fprintf(fid, '        reg_Sm => exp_Sm,\n');
    fprintf(fid, '        data_out => data_in_sum_%d\n',b);
    fprintf(fid, '    );\n');
end
fprintf(fid, 'VOT_Register_softmax_exp : VOT_Reg_softmax_2 \n');
fprintf(fid, '    port map (\n');
for b = 1 : 3
    fprintf(fid, '       data_out_%d => data_in_sum_%d,\n',b,b);
end
fprintf(fid, '       data_out_v => data_in_sum); \n');

fprintf(fid, '--Then we sum each of the results and inverse the result\n');
for b = 1 : 3
    fprintf(fid, 'BIT_MUX_SUM_SM_%d: PAR2SER\n',b);
    fprintf(fid, '    port map (\n');
    fprintf(fid, '        clk => clk,\n');
    fprintf(fid, '        rst => rst,\n');
    fprintf(fid, '        data_in => data_in_sum,\n');
    fprintf(fid, '        bit_select => bit_select,\n');
    fprintf(fid, '        en_neuron => en_neuron,\n');
    fprintf(fid, '        bit_out => bit_selected_sum_%d\n',b);
    fprintf(fid, '    );\n');
end
fprintf(fid, 'VOT_BIT_MUX_SUM_SM: VOT_PAR2SER \n');
fprintf(fid, 'port map ( \n');
for a = 1 : 3
        fprintf(fid, '\t\t serial_out_%d => bit_selected_sum_%d,\n',a,a);
end
        fprintf(fid, '\t\t serial_out_v => bit_selected_sum);\n');
fprintf(fid, '\n');

for b = 1 : 3
    fprintf(fid, 'SUM_EXP_%d: sum\n',b);
    fprintf(fid, 'port map ( clk => clk,\n');
    fprintf(fid, '           rst => rst,\n');
    fprintf(fid, '           next_pipeline_step => next_pipeline_step,\n');
    fprintf(fid, '           data_in_bit => bit_selected_sum,\n');
    fprintf(fid, '           bit_select => bit_select,\n');
    fprintf(fid, '           neuron_mac => sum_expo_%d);\n',b);
end
fprintf(fid, 'VOT_SUM_EXP : VOT_sum \n');
fprintf(fid, 'port map (  \n');
for b = 1 : 3
    fprintf(fid, '        neuron_mac_%d => sum_expo_%d,\n',b,b);
end
fprintf(fid, '        neuron_mac_v => sum_expo);\n');

for b = 1 : 3
    fprintf(fid, 'INV_%d : inverse\n',b);
    fprintf(fid, 'port map ( data_in => sum_expo,\n');
    fprintf(fid, '           data_out => inverse_result_%d);\n',b);
end
fprintf(fid, 'VOT_INV : VOT_inverse\n');
fprintf(fid, '    port map (\n');
for b = 1 : 3
    fprintf(fid, '       data_out_%d => inverse_result_%d,\n',b,b);
end
fprintf(fid, '       data_out_v => inverse_result);\n');

fprintf(fid, '--Finally, we multiply the inverse by each of the exponentials\n');
for b = 1 : 3
    fprintf(fid, 'Register_softmax2_%d : Reg_softmax_2\n',b);
    fprintf(fid, 'port map(\n');
    fprintf(fid, '    clk => clk,\n');
    fprintf(fid, '    rst => rst,\n');
    fprintf(fid, '    data_in => inverse_result,\n');
    fprintf(fid, '    reg_Sm => inv_Sm,\n');
    fprintf(fid, '    data_out => data_inverse_reg_%d);\n',b);
end
fprintf(fid, 'VOT_Register_softmax2 : VOT_Reg_softmax_2 \n');
fprintf(fid, '    port map (\n');
for b = 1 : 3
    fprintf(fid, '       data_out_%d => data_inverse_reg_%d,\n',b,b);
end
fprintf(fid, '       data_out_v => data_inverse_reg);\n');

for b = 1 : 3
    fprintf(fid, 'Register_softmax1_%d : Reg_softmax_1\n',b);
    fprintf(fid, 'port map(\n');
    fprintf(fid, '    clk => clk,\n');
    fprintf(fid, '    rst => rst,\n');
    fprintf(fid, '    data_in => data_out_exponential,\n');
    fprintf(fid, '    index => unsigned(rom_addr_Sm),\n');
    fprintf(fid, '    data_out => data_in_softmax_%d);\n',b);
end
fprintf(fid, 'VOT_Register_softmax1 : VOT_Reg_softmax_1 \n');
fprintf(fid, 'port map(\n');
for b = 1 : 3
    fprintf(fid, '       data_out_%d => data_in_softmax_%d,\n',b,b);
end
fprintf(fid, '       data_out_v => data_in_softmax);\n');

for b = 1 : 3
    fprintf(fid, 'BIT_MUX_SM_%d: PAR2SER\n',b);
    fprintf(fid, 'port map ( clk => clk,\n');
    fprintf(fid, '           rst => rst,\n');
    fprintf(fid, '           data_in => data_inverse_reg,\n');
    fprintf(fid, '           bit_select => bit_select,\n');
    fprintf(fid, '           en_neuron => en_neuron,\n');
    fprintf(fid, '           bit_out => bit_selected_softmax_%d);\n',b);
end
fprintf(fid, 'VOT_BIT_MUX_SM : VOT_PAR2SER \n');
fprintf(fid, 'port map ( \n');
for a = 1 : 3
        fprintf(fid, '\t\t serial_out_%d => bit_selected_softmax_%d,\n',a,a);
end
        fprintf(fid, '\t\t serial_out_v => bit_selected_softmax);\n');

for i = 1 : outputsFC
    for b = 1 : 3
        fprintf(fid, 'LAYER_OUT_NEU_%d_%d: layer_out_neuron_%d\n', i,b, i);
        fprintf(fid, 'port map ( clk => clk,\n');
        fprintf(fid, '           rst => rst,\n');
        fprintf(fid, '           next_pipeline_step => sum_finish,\n');
        fprintf(fid, '           data_in_bit => bit_selected_softmax,\n');
        fprintf(fid, '           bit_select => bit_select,\n');
        fprintf(fid, '           weight => signed(data_in_softmax(%d)),\n', i - 1);
        fprintf(fid, '           neuron_mac => layer_out_neurons_mac_%d(%d));\n',b, i - 1);
    end
    fprintf(fid,'VOT_LAYER_OUT_NEU_%d : VOT_layer_out_neuron_%d \n',i, i);
    fprintf(fid, 'port map ( \n');
    for b = 1 : 3
        fprintf(fid,'\t\t neuron_mac_%d => layer_out_neurons_mac_%d(%d), \n',b,b, i - 1);
    end
    fprintf(fid,'\t\t neuron_mac_v => layer_out_neurons_mac(%d));\n', i - 1);
end
fprintf(fid, '--We compute the maximum value of the outputs of the softmax as the result of the entire network\n');
for b = 1 : 3
    fprintf(fid, 'LAST_LAYER_REG_%d: Register_FCLast\n',b);
    fprintf(fid, 'port map ( data_in => layer_out_neurons_mac,\n');
    fprintf(fid, '           clk => clk,\n');
    fprintf(fid, '           rst => rst,\n');
    fprintf(fid, '           next_pipeline_step => enable_lastlayer,\n');
    fprintf(fid, '           start_threshold => start_th_%d,\n',b);
    fprintf(fid, '           data_out => data_out_register_L_out_%d);\n',b);
end
fprintf(fid,'VOT_LAST_LAYER_REG: VOT_Register_FCLast \n');
fprintf(fid, 'port map(\n');
for b = 1 : 3
    fprintf(fid,'\t\t start_threshold_%d => start_th_%d,\n',b,b);
    fprintf(fid,'\t\t data_out_%d => data_out_register_L_out_%d,\n',b,b);
end
fprintf(fid,'\t\t start_threshold => start_th,\n');
fprintf(fid,'\t\t data_out => data_out_register_L_out);\n');

for b = 1 : 3
    fprintf(fid, 'THRSHLD_%d: entity work.threshold(Behavioral)\n',b);
    fprintf(fid, '    port map (\n');
    fprintf(fid, '        clk => clk,\n');
    fprintf(fid, '        rst => rst,\n');
    fprintf(fid, '        start => start_th,\n');
    fprintf(fid, '        finish => finish_%d,\n',b);
    fprintf(fid, '        y_in => data_out_register_L_out,\n');
    fprintf(fid, '        y_out => y_%d);\n',b);
end
fprintf(fid,'VOT_THRSHLD : VOT_threshold \n');
fprintf(fid, '    port map (\n');
for b = 1 : 3 
    fprintf(fid,'\t      y_out_%d => y_%d,\n',b,b);
    fprintf(fid,'\t      finish_%d => finish_%d,\n',b,b);
end
fprintf(fid,'\t      y_out => y,\n');
fprintf(fid,'\t      finish => finish);\n');
if(riscv == 1)
    fprintf(fid, 'output_sm <= data_out_register_L_out;\n');
end
fprintf(fid, 'end Behavioral;\n');
fclose(fid);
end

