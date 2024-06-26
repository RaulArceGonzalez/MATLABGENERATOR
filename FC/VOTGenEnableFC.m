function VOTGenEnableFC(number_of_layers_fc, layers_cnn)
name = sprintf('CNN_Network/FC/VOT_enable_generator.vhd');
fid = fopen(name, 'wt');
fprintf(fid, 'library IEEE;\n');
fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid, '\n');
fprintf(fid, 'entity VOT_enable_generator is\n');
fprintf(fid, '    Port ( \n');
for b = 1 : 3
    fprintf(fid, '           data_fc_%d : in std_logic;\n',b);
    fprintf(fid, '           en_neuron_%d : in std_logic;\n',b);
    fprintf(fid, '           addr_FC_%d : in std_logic_vector(log2c(biggest_ROM_size)-1 downto 0);\n',b);
    fprintf(fid, '           bit_select_%d : in unsigned(log2c(input_size_L1fc)-1 downto 0);\n',b);
    fprintf(fid, '           next_pipeline_step_%d: in std_logic;\n',b);
    fprintf(fid, '           addr_Sm_%d : in std_logic_vector(log2c(number_of_outputs_L%dfc) - 1 downto 0 );\n', b,number_of_layers_fc);
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
fprintf(fid, '           addr_Sm : out std_logic_vector(log2c(number_of_outputs_L%dfc) - 1 downto 0 );\n', number_of_layers_fc);
fprintf(fid, '           exp_Sm: out std_logic;\n');
fprintf(fid, '           inv_Sm: out std_logic;\n');
fprintf(fid, '           sum_finish: out std_logic;\n');
fprintf(fid, '           enable_lastlayer : out STD_LOGIC);\n');
fprintf(fid, 'end VOT_enable_generator;');
fprintf(fid, '\n');
fprintf(fid, 'architecture Behavioral of VOT_enable_generator is\n');
fprintf(fid, 'begin\n');
    fprintf(fid, 'data_fc <= (data_fc_1 and data_fc_2) or (data_fc_1 and data_fc_3) or (data_fc_2 and data_fc_3);\n');
    fprintf(fid, 'en_neuron <= (en_neuron_1 and en_neuron_2) or (en_neuron_1 and en_neuron_3) or (en_neuron_2 and en_neuron_3);\n');
    fprintf(fid, 'addr_FC <= (addr_FC_1 and addr_FC_2) or (addr_FC_1 and addr_FC_3) or (addr_FC_2 and addr_FC_3);\n');
    fprintf(fid, 'bit_select <= (bit_select_1 and bit_select_2) or (bit_select_1 and bit_select_3) or (bit_select_2 and bit_select_3);\n');
    fprintf(fid, 'next_pipeline_step <= (next_pipeline_step_1 and next_pipeline_step_2) or (next_pipeline_step_1 and next_pipeline_step_3) or (next_pipeline_step_2 and next_pipeline_step_3);\n');
    fprintf(fid, 'addr_Sm <= (addr_Sm_1 and addr_Sm_2) or (addr_Sm_1 and addr_Sm_3) or (addr_Sm_2 and addr_Sm_3);\n');
    fprintf(fid, 'exp_Sm <= (exp_Sm_1 and exp_Sm_2) or (exp_Sm_1 and exp_Sm_3) or (exp_Sm_2 and exp_Sm_3);\n');
    fprintf(fid, 'inv_Sm <= (inv_Sm_1 and inv_Sm_2) or (inv_Sm_1 and inv_Sm_3) or (inv_Sm_2 and inv_Sm_3);\n');
    fprintf(fid, 'sum_finish <= (sum_finish_1 and sum_finish_2) or (sum_finish_1 and sum_finish_3) or (sum_finish_2 and sum_finish_3);\n');
    fprintf(fid, 'enable_lastlayer <= (enable_lastlayer_1 and enable_lastlayer_2) or (enable_lastlayer_1 and enable_lastlayer_3) or (enable_lastlayer_2 and enable_lastlayer_3);\n');
fprintf(fid, 'end Behavioral;\n');
fclose(fid);
end