% This function generates the module for the ReLU activation function
% INPUTS
% Number of the layer where the ReLU is located in each case
function [] = ReLU(layer, relu_act)
name = sprintf('CNN_Network/CNN/RELUL%d.vhd', layer);
fid = fopen(name, 'wt');
fprintf(fid, '------------------------- RELU MODULE LAYER %d------------------------------------\n', layer);
fprintf(fid, '--This module is in charge of performing the ReLU operation, it stores the necessary data for the Pool layer of the next filter.\n');
fprintf(fid, '--Data is stored if  is positive, if it is negative a zero is stored instead.\n');
fprintf(fid, '--INPUTS\n');
fprintf(fid, '--next_pipeline_step : signal indicating when we have finished a filter pass and new data is available for filter pooling\n');
fprintf(fid, '--data_in : as input receives the output of the convolutional operation\n');
fprintf(fid, '--index : this signal is used to transmit all the stored data from the relu to the next layer, when it needs to be processed.\n');
fprintf(fid, '--OUTPUTS\n');
fprintf(fid, '--data_out : sends the stored signals with ReLU applied, once the next layer notifies that it can process them.\n');
fprintf(fid, 'library IEEE;\n');
fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
fprintf(fid, 'entity RELUL%d is\n', layer);
fprintf(fid, '\t Port (clk : in std_logic;\n');
fprintf(fid, '\t\t    rst : in std_logic;\n');
fprintf(fid, '\t\t    next_pipeline_step : in std_logic;\n');
fprintf(fid, '\t\t    index : in std_logic;\n');
fprintf(fid, '\t\t    data_in : in std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0);\n', layer, layer);
fprintf(fid, '\t\t    data_out : out std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0));\n', layer, layer);
fprintf(fid, 'end RELUL%d;\n', layer);
fprintf(fid, 'architecture Behavioral of RELUL%d is\n', layer);
fprintf(fid, 'signal c_aux  :std_logic_vector(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 downto 0) := (others => ''0'');\n', layer, layer);
fprintf(fid, 'signal data_reg, data_next : vector_reluL%d(0 to pool%d_size - 1);\n', layer, layer+ 1);
if(layer == 1)
    fprintf(fid, 'signal index2_reg, index2_next : unsigned(pool%d_row -1 downto 0) := (others => ''0'');\n', layer + 1);
else
    fprintf(fid, 'signal index2_reg, index2_next : unsigned(pool%d_size -1 downto 0) := (others => ''0'');\n', layer + 1);
end
fprintf(fid, 'begin\n');
fprintf(fid, '--Register\n');
fprintf(fid, 'process(clk)\n');
fprintf(fid, 'begin\n');
fprintf(fid, 'if (clk''event and clk = ''1'') then \n');
fprintf(fid, '   if (rst = ''0'') then  \n');
fprintf(fid, '	    for i in 0 to pool%d_size - 1 loop\n', layer + 1);
fprintf(fid, '		    data_reg(i) <= (others=>''0'');\n');
fprintf(fid, '	    end loop;\n');
fprintf(fid, '	    index2_reg <=  (others=>''0'');\n');
fprintf(fid, '	 else\n');
fprintf(fid, '	    index2_reg <= index2_next; \n');
fprintf(fid, '	    if(next_pipeline_step = ''1'') then\n');
fprintf(fid, '	 	    for i in 0 to pool%d_size - 1 loop\n', layer + 1);
fprintf(fid, '	 	 	     data_reg(i) <= data_next(i);\n');
fprintf(fid, '	 	     end loop;\n');
fprintf(fid, '	    end if;\n');
fprintf(fid, '   end if;\n');
fprintf(fid, 'end if;\n');
fprintf(fid, 'end process;\n');
fprintf(fid, '\n');
fprintf(fid, '--Next state logic\n');
fprintf(fid, '\n');
fprintf(fid, 'process(index, index2_reg,index2_next) --if index = 1 (the output data of the layer has been calculated) we increment index2 to send the array of  data stored in ReLu (if index has not reached its limit).\n');
fprintf(fid, 'begin \n');
fprintf(fid, '  if(index = ''1'') then                  \n');
if (layer == 1)
    fprintf(fid, '	 if(index2_reg = pool%d_row - 1) then\n', layer + 1);
else
    fprintf(fid, '	 if(index2_reg = pool%d_size - 1) then\n', layer + 1);
end
fprintf(fid, '		 index2_next <=  (others=>''0'');\n');
fprintf(fid, '	 else\n');
fprintf(fid, '		  index2_next <= index2_reg + 1;\n');
fprintf(fid, '	 end if;\n');
fprintf(fid, 'else\n');
fprintf(fid, '	 index2_next <= index2_reg;\n');
fprintf(fid, 'end if;\n');
fprintf(fid, 'end process;\n');
fprintf(fid, '\n');
% if(relu_act == 0)
%     fprintf(fid, 'process(data_in, c_aux)          --If the input data is negative, a zero is stored, otherwise the sum is stored.\n');
%     fprintf(fid, 'begin \n');
%     fprintf(fid, 'c_aux <= (others => ''0'');\n');
%     fprintf(fid, '	 if(data_in(input_sizeL%d + weight_sizeL%d + n_extra_bits - 1 ) = ''0'') then \n', layer, layer);
%     fprintf(fid, '		 c_aux <= data_in;\n');
%     fprintf(fid, '	else\n');
%     fprintf(fid, '		 c_aux <= (others=>''0'');\n');
%     fprintf(fid, 'end if;\n');
%     fprintf(fid, 'end process;\n');
%     fprintf(fid, '\n');
% else
    fprintf(fid, 'process(data_in, c_aux) \n');
    fprintf(fid, 'begin \n');
    fprintf(fid, '		 c_aux <= data_in;\n');
    fprintf(fid, 'end process;\n');
    fprintf(fid, '\n');
% end
fprintf(fid, 'process(data_reg, c_aux, data_next)    --we store incoming data in consecutive order\n');
fprintf(fid, 'begin\n');
fprintf(fid, 'for i in pool%d_size - 1 downto 0 loop\n', layer + 1);
fprintf(fid, '	 if(i = pool%d_size - 1) then\n', layer + 1);
fprintf(fid, '  	 	 data_next(i) <= c_aux;\n');
fprintf(fid, '	 else\n');
fprintf(fid, '        data_next(i) <= data_reg(i + 1);\n');
fprintf(fid, '   end if;\n');
fprintf(fid, 'end loop;\n');
fprintf(fid, 'end process;\n\n');
fprintf(fid, '--Output logic\n\n');
fprintf(fid, 'data_out <= data_reg(to_integer(index2_reg));\n\n');
fprintf(fid, 'end Behavioral;\n');
fclose(fid);
end

