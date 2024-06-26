% This function generates the generator of control signals for the FC part of the network
% INPUTS
% Number of layers in FC part of the network
% Z dimension of the input matriz coming from the CNN part of the network
% Number of layers of FC
function GenEnable(number_of_layers_fc, layers_cnn)
name = sprintf('CNN_Network/FC/enable_generator.vhd');
fid = fopen(name, 'wt');
fprintf(fid, '-----------------------------------ENABLE GENERATOR-------------------------------------\n');
fprintf(fid, '--This module provides the control signal to manage the functioning of the complete fully connected network\n');
fprintf(fid, '--INPUTS\n');
fprintf(fid, '--start_enable : start the processing of data when there is an available data in the CNN network output\n');
fprintf(fid, '--OUTPUTS\n');
fprintf(fid, '--data_fc: signal indicating that a data has been processed by the FC network so that the CNN can send a new one\n');
fprintf(fid, '--bit_select: control signal to select the bit of the input byte to be processed at each moment by the neurons\n');
fprintf(fid, '--en_neuron : signal indicating when the neurons can process an input\n');
fprintf(fid, '--addr_FC :signal to select the weight to be operated at each moment in the fully connected layers of the network\n');
fprintf(fid, '--next_pipeline_step : signal to indicate that a set of input data has been processed by the neurons\n\n');
fprintf(fid, '--addr_Sm : signal to select the weight to be operated at each moment of the softmax layer of the network\n');
fprintf(fid, '--enable_lastlayer : control isgnal to enable the register of the output layer when the data is calculated\n');
fprintf(fid, 'library IEEE;\n');
fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid, '\n');
fprintf(fid, 'entity enable_generator is\n');
fprintf(fid, '    Port ( clk : in STD_LOGIC;\n');
fprintf(fid, '           rst : in STD_LOGIC;\n');
fprintf(fid, '           rst_red : in std_logic;\n');
fprintf(fid, '           start_enable : in STD_LOGIC;\n');
fprintf(fid, '           data_fc : out std_logic;\n');
fprintf(fid, '           en_neuron : out std_logic;\n');
fprintf(fid, '           addr_FC : out STD_LOGIC_VECTOR (log2c(biggest_ROM_size)-1 downto 0);\n');
fprintf(fid, '           bit_select : out unsigned (log2c(input_size_L1fc)-1 downto 0);\n');
fprintf(fid, '           next_pipeline_step: out STD_LOGIC;\n');
fprintf(fid, '           addr_Sm : out std_logic_vector(log2c(number_of_outputs_L%dfc) - 1 downto 0 );\n', number_of_layers_fc);
fprintf(fid, '           exp_Sm: out std_logic;\n');
fprintf(fid, '           inv_Sm: out std_logic;\n');
fprintf(fid, '           sum_finish: out std_logic;\n');
fprintf(fid, '           enable_lastlayer : out STD_LOGIC);\n');
fprintf(fid, 'end enable_generator;');
fprintf(fid, '\n');
fprintf(fid, 'architecture Behavioral of enable_generator is\n');
fprintf(fid, 'type state_type is (idle , s_wait, s0,');
if number_of_layers_fc ~= 2
    fprintf(fid, 's_fc, ');
end
fprintf(fid, 's_sm_1,s_sm_2);\n');
fprintf(fid, 'signal state_reg, state_next : state_type;\n');
fprintf(fid, '---Layer 1\n');
fprintf(fid, 'signal max_cnt  : unsigned(log2c(input_size_L1fc)-1 downto 0) := (others => ''0''); \n');
fprintf(fid, 'signal cnt_layer_reg, cnt_layer_next : unsigned(log2c(number_of_layers%d) - 1 downto 0):= (others => ''0''); \n', layers_cnn);
fprintf(fid, 'signal cnt_reg, cnt_next : unsigned (log2c(input_size_L1fc)+log2c(biggest_ROM_size)-1 downto 0) := (others => ''0''); \n');
fprintf(fid, 'signal next_pipeline_step_reg, next_pipeline_step_next : std_logic;\n');
if number_of_layers_fc ~= 2
    fprintf(fid, 'signal cnt_layerFC_reg, cnt_layerFC_next : unsigned (log2c(number_of_neurons_L2fc)-1 downto 0) := (others => ''0''); ');
end
fprintf(fid, '\n');
fprintf(fid, '--Softmax\n');
fprintf(fid, 'signal count_next, count_reg : unsigned (log2c(number_of_outputs_L%dfc) - 1 downto 0 ):= (others => ''0''); \n', number_of_layers_fc);
fprintf(fid, ' signal c_reg, c_next : unsigned( 1 downto 0 );\n');
fprintf(fid, 'signal enable_lastlayer_reg, enable_lastlayer_next, first_step_reg, first_step_next, sum_finish_reg, sum_finish_next : std_logic := ''0'';\n');
fprintf(fid, '\n');
fprintf(fid, 'begin\n');
fprintf(fid, '\n');
fprintf(fid, '--State and data registers\n');
fprintf(fid, 'process (clk)\n');
fprintf(fid, 'begin\n');
fprintf(fid, '    if rising_edge(clk) then\n');
fprintf(fid, '        if (rst = ''0'') then\n');
fprintf(fid, '            cnt_reg <= (others => ''0'');\n');
fprintf(fid, '            count_reg <= (others => ''0'');\n');
fprintf(fid, '            next_pipeline_step_reg <= ''0'';\n');
fprintf(fid, '            cnt_layer_reg <= (others=>''0'');\n');
if number_of_layers_fc ~= 2
    fprintf(fid, '            cnt_layerFC_reg <= (others=>''0'');\n');
end
fprintf(fid, '            sum_finish_reg <= ''0'';\n');
fprintf(fid, '            c_reg <= (others=>''0'');\n');
fprintf(fid, '        else\n');
fprintf(fid, '            cnt_reg <= cnt_next;\n');
fprintf(fid, '            cnt_layer_reg <= cnt_layer_next;\n');
if number_of_layers_fc ~= 2
    fprintf(fid, '            cnt_layerFC_reg <= cnt_layerFC_next;\n');
end
fprintf(fid, '            count_reg <= count_next;\n');
fprintf(fid, '            state_reg <= state_next;\n');
fprintf(fid, '            next_pipeline_step_reg <= next_pipeline_step_next;\n');
fprintf(fid, '            enable_lastlayer_reg <= enable_lastlayer_next;\n');
fprintf(fid, '            first_step_reg <= first_step_next;\n');
fprintf(fid, '            sum_finish_reg <= sum_finish_next;\n');
fprintf(fid, '            c_reg <= c_next;\n');
fprintf(fid, '        end if;\n');
fprintf(fid, '    end if;\n');
fprintf(fid, 'end process;\n');
fprintf(fid,'--Next state logic\n');
fprintf(fid,'process(rst_red, first_step_reg,sum_finish_reg,enable_lastlayer_reg, max_cnt,state_reg, cnt_reg, start_enable, count_reg,next_pipeline_step_reg, c_reg,  ');
if number_of_layers_fc ~= 2
    fprintf(fid, 'cnt_layerFC_reg,');
end
fprintf(fid,'cnt_layer_reg )\n');
fprintf(fid,'begin\n');
fprintf(fid,'cnt_next <= cnt_reg;\n');
fprintf(fid,'count_next <= count_reg;\n');
fprintf(fid,'state_next <= state_reg;\n');
fprintf(fid,'next_pipeline_step_next <= next_pipeline_step_reg;\n');
fprintf(fid,'enable_lastlayer_next <= enable_lastlayer_reg;\n');
fprintf(fid,'cnt_layer_next <= cnt_layer_reg;\n');
if number_of_layers_fc ~= 2
    fprintf(fid,'cnt_layerFC_next <= cnt_layerFC_reg;\n');
end
fprintf(fid,'first_step_next <= first_step_reg;\n');
fprintf(fid,'en_neuron <= ''0'';\n');
fprintf(fid,'sum_finish_next <= sum_finish_reg;\n');
fprintf(fid,'data_fc <= ''0'';\n');
fprintf(fid, 'c_next <= c_reg;\n');
fprintf(fid, 'exp_Sm <= ''0'';\n');
fprintf(fid, 'inv_Sm <= ''0'';\n');
fprintf(fid,'\n');
fprintf(fid,'case state_reg is\n');
fprintf(fid,'when idle  =>\n');
fprintf(fid,'     data_fc <= ''0'';\n');
fprintf(fid,'     sum_finish_next <= ''0'';\n');
fprintf(fid,'     cnt_next <= (others=>''0'');\n');
fprintf(fid, '    cnt_layer_next <= (others=>''0'');\n');
if number_of_layers_fc ~= 2
    fprintf(fid, '    cnt_layerFC_next <= "0000010";\n');
end
fprintf(fid,'     count_next <= (others => ''0'');\n');
fprintf(fid,'     next_pipeline_step_next  <= ''0'';\n');
fprintf(fid,'     state_next <= s_wait;\n');
fprintf(fid,'     enable_lastlayer_next <=''0'';\n');
fprintf(fid,'     first_step_next <= ''1'';\n');
fprintf(fid, '    c_next <= (others => ''0'');\n');
fprintf(fid,'when s_wait =>\n');
fprintf(fid,'     sum_finish_next <= ''0'';\n');
fprintf(fid,'     data_fc <= ''0'';\n');
fprintf(fid,'     next_pipeline_step_next  <= ''0'';\n');
fprintf(fid,'     enable_lastlayer_next <=''0'';\n');
fprintf(fid,'     count_next <= (others => ''0'');\n');
fprintf(fid,'     if(start_enable = ''1'') then   --When there is new data available to be processed by the network we generate the corresponding control signals\n');
fprintf(fid,'        state_next <= s0;         --The first stage corresponds to the first layer of the FC which is responsible for processing the data coming from the CNN\n');
fprintf(fid,'     end if;\n');
fprintf(fid,'    if(rst_red = ''1'') then\n');
fprintf(fid,'        state_next <= idle;\n');
fprintf(fid,'    end if;\n');
fprintf(fid, 'when s0 =>\n');
fprintf(fid, '   if(cnt_reg(log2c(input_size_L1fc) - 1 downto 0 )= max_cnt) then   --When the counter reaches the max_cnt value the processing of the data is completed and we move to the next one\n');
fprintf(fid, '        if (cnt_reg(log2c(input_size_L1fc) +log2c(biggest_ROM_size)-1 downto log2c(input_size_L1fc))= biggest_ROM_size - 1) then --When the counter reaches the biggest value of the ROM all the inputs of the FC network have been processed\n');
fprintf(fid, '          next_pipeline_step_next <= ''1'';  --We notify the neurons of the inner layer that all the data  has been processed\n');
if number_of_layers_fc ~= 2
    fprintf(fid, '          state_next <= s_fc;                --We now generate the control signal for the output layer\n');
else
    fprintf(fid, '          state_next <= s_sm_1;                --We now generate the control signal for the output layer\n');
    
end
fprintf(fid, '          cnt_next <= (others => ''0'');       \n');
fprintf(fid, '        else\n');
fprintf(fid, '          cnt_next <= cnt_reg + 1;\n');
fprintf(fid, '        if(cnt_layer_reg = number_of_layers%d - 1 ) then  --If there are still data available from the cnn (Every data calculated by each of the neurons) then we activate the signal data_fc else we wait for new data to be available\n', layers_cnn);
fprintf(fid, '          cnt_layer_next <= (others=>''0'');\n');
fprintf(fid, '        else\n');
fprintf(fid, '          data_fc <= ''1'';                         \n');
fprintf(fid, '          cnt_layer_next <= cnt_layer_reg + 1;\n');
fprintf(fid, '        end if;\n');
fprintf(fid, '        state_next <= s_wait;\n');
fprintf(fid, '     en_neuron <= ''1'';\n');
fprintf(fid, '       end if;\n');
fprintf(fid, '    else\n');
fprintf(fid, '     cnt_next <= cnt_reg + 1;\n');
fprintf(fid, '     en_neuron <= ''1'';\n');
fprintf(fid, '    end if;\n');
if number_of_layers_fc ~= 2
    fprintf(fid, 'when s_fc =>\n');
    fprintf(fid, '          next_pipeline_step_next <= ''0'';  --We notify the neurons of the inner layer that all the data  has been processed\n');
    fprintf(fid, '   if(cnt_reg(log2c(input_size_L1fc) - 1 downto 0 )= max_cnt) then   --When the counter reaches the max_cnt value the processing of the data is completed and we move to the next one\n');
    fprintf(fid, '        if (cnt_reg(log2c(input_size_L1fc) +log2c(number_of_neurons_L1fc)-1 downto log2c(input_size_L1fc))= number_of_neurons_L1fc - 1) then --When the counter reaches the number of neurons in hte second layer we can move to the next one\n');
    fprintf(fid, '          next_pipeline_step_next <= ''1'';  --We notify the neurons of the inner layer that all the data  has been processed\n');
    fprintf(fid, '          if(cnt_layerFC_reg > layers_fc - 2) then  --We repeat this step as long as there are layers in the FC network that have not been processed\n');
    fprintf(fid, '              state_next <= s_sm_1;                \n');
    fprintf(fid, '              cnt_layerFC_next <= (others=>''0'');                \n');
    fprintf(fid, '          next_pipeline_step_next <= ''1'';  --We notify the neurons of the inner layer that all the data  has been processed\n');
    fprintf(fid, '          else \n');
    fprintf(fid, '          cnt_layerFC_next <= cnt_layerFC_reg + 1; \n');
    fprintf(fid, '          end if; \n');
    fprintf(fid, '          cnt_next <= (others => ''0'');       \n');
    fprintf(fid, '        else\n');
    fprintf(fid, '          cnt_next <= cnt_reg + 1;\n');
    fprintf(fid, '     en_neuron <= ''1'';\n');
    fprintf(fid, '       end if;\n');
    fprintf(fid, '    else\n');
    fprintf(fid, '      cnt_next <= cnt_reg + 1;\n');
    fprintf(fid, '     en_neuron <= ''1'';\n');
    fprintf(fid, '    end if;\n');
end
fprintf(fid, 'When s_sm_1 =>\n');
fprintf(fid, '   data_fc <= ''0'';\n');
fprintf(fid, '   next_pipeline_step_next <= ''0'';\n');
fprintf(fid, '   if(first_step_reg = ''1'') then\n');
fprintf(fid, '             cnt_next <=  (others => ''0'');\n');
fprintf(fid, '             first_step_next <= ''0'';\n');
fprintf(fid, '   else\n');
fprintf(fid, 'if (c_reg = 0) then\n');
fprintf(fid, '    cnt_next <= (others => ''0'');\n');
fprintf(fid, '    c_next <= c_reg + 1;\n');
fprintf(fid, '    exp_Sm <= ''1'';\n');
fprintf(fid, 'else\n');
fprintf(fid, '   if(cnt_reg(log2c(input_size_L%dfc) - 1 downto 0 )= max_cnt) then  --When the counter reaches the max_cnt value the processing of the data is completed and we move to the next one\n', number_of_layers_fc);
fprintf(fid, '     if(count_reg = number_of_outputs_L%dfc - 1) then  --As this is the last layer the number of data to be processed is equal to the number of outputs, once this is processed we activate the enable of the last register and wait \n', number_of_layers_fc);
fprintf(fid, '         sum_finish_next<=''1'';\n');
fprintf(fid, '         count_next <= (others => ''0'');\n');
fprintf(fid, '          first_step_next <= ''1''; \n');
fprintf(fid, '          inv_Sm <= ''1''; \n');
fprintf(fid, '         state_next <= s_sm_2;\n');
fprintf(fid, '      else\n');
fprintf(fid, '         count_next <= count_reg + 1;\n');
fprintf(fid, '         c_next <= (others => ''0'');\n');
fprintf(fid, '      end if;\n');
fprintf(fid, '            cnt_next <=  (others => ''0'');\n');
fprintf(fid, '            en_neuron <= ''0'';\n');
fprintf(fid, '   else \n');
fprintf(fid, '            en_neuron <= ''1'';\n');
fprintf(fid, '            cnt_next <= cnt_reg + 1;\n');
fprintf(fid, '   end if;\n');
fprintf(fid, '  end if;\n');
fprintf(fid, 'end if;\n');
fprintf(fid, 'when s_sm_2 => \n');
fprintf(fid, '   sum_finish_next<=''0'';\n');
fprintf(fid, '   next_pipeline_step_next <= ''0'';\n');
fprintf(fid, '\n');
fprintf(fid, '   if(first_step_reg = ''1'') then\n');
fprintf(fid, '        cnt_next <=  (others => ''0'');\n');
fprintf(fid, '        first_step_next <= ''0'';\n');
fprintf(fid, '   else\n');
fprintf(fid, ' if(cnt_reg(log2c(input_size_L%dfc) - 1 downto 0 )= max_cnt) then  --When the counter reaches the max_cnt value the processing of the data is completed and we move to the next one\n', number_of_layers_fc);
fprintf(fid, '               state_next <= s_wait;\n');
fprintf(fid, '               enable_lastlayer_next <=''1'';\n');
fprintf(fid, '            cnt_next <=  (others => ''0'');\n');
fprintf(fid, '            en_neuron <= ''0''; \n');
fprintf(fid, '   else \n');
fprintf(fid, '            cnt_next <= cnt_reg + 1;\n');
fprintf(fid, '            en_neuron <= ''1''; \n');
fprintf(fid, '   end if;\n');
fprintf(fid, '   end if;\n');
fprintf(fid, 'end case;\n');
fprintf(fid, 'end process;\n');
fprintf(fid, '\n');
fprintf(fid, '--Output logic\n');
fprintf(fid, 'max_cnt <= (others => ''1''); --Maximum value of the count\n');
fprintf(fid, 'bit_select <= cnt_reg(log2c(input_size_L1fc)-1 downto 0);  --assignment of the bits corresponding to the count\n');
fprintf(fid, 'addr_FC<= std_logic_vector(cnt_reg(log2c(input_size_L1fc) +log2c(biggest_ROM_size)-1 downto log2c(input_size_L1fc)));\n');
fprintf(fid, 'addr_Sm <= std_logic_vector(count_reg);\n');
fprintf(fid, 'next_pipeline_step <= next_pipeline_step_reg;\n');
fprintf(fid, 'enable_lastlayer <= enable_lastlayer_reg;\n');
fprintf(fid, 'sum_finish <= sum_finish_reg;\n');
fprintf(fid, 'end Behavioral;\n');
fclose(fid);