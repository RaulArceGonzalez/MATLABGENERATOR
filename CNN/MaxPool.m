% This function generates the MaxPool filter module
function [] =  MaxPool(activations, layer)
name = sprintf('CNN_Network/CNN/MAXPOOL_L%d.vhd', layer);
fid = fopen(name, 'wt');
fprintf(fid, '-----------------------------------------MAXPOOL ----------------------------------------------------------\n');
fprintf(fid, '--This module is going to perform the MaxPool operation, which consists of calculating the maximum of a set of data.\n');
fprintf(fid, '--This is achieved by comparing the input with the data already recorded, if it is greater the input is stored and if not it is discarded.\n');
fprintf(fid, '--INPUTS\n');
fprintf(fid, '--data_in: data processed by the convolution layer and relu, coming from the multiplexer. \n');
fprintf(fid, '--next_data_pool : signal indicating when the processing of a filter pass is finished\n');
fprintf(fid, '--index : siganl indicating that there is data avaiable to be processed\n');
fprintf(fid, '--OUTPUTS\n');
fprintf(fid, '--data_out: output signal, one output for each filter pass that corresponds to the highest data of those recorded\n\n');
fprintf(fid, 'library IEEE;\n');
fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n\n');
fprintf(fid, '--library UNISIM;\n');
fprintf(fid, '--use UNISIM.VComponents.all;\n');
if(activations == 1)
    fprintf(fid, 'entity MAXPOOL_L%d is\n', layer);
    fprintf(fid, ' generic (\n');
    fprintf(fid, ' input_size : integer := 8; \n');
    fprintf(fid, ' weight_size : integer := 8);\n');
    fprintf(fid, 'Port (clk : in STD_LOGIC;\n');
    fprintf(fid, '      rst : in STD_LOGIC;\n');
    fprintf(fid, '      next_data_pool : in STD_LOGIC;\n');
    fprintf(fid, '      index : STD_LOGIC;\n');
    fprintf(fid, '      data_in : in STD_LOGIC_VECTOR(input_size  - 1 downto 0);\n');
    fprintf(fid, '      data_out : out STD_LOGIC_VECTOR(input_size  - 1 downto 0));\n');
    fprintf(fid, 'end MAXPOOL_L%d;\n\n', layer);
    fprintf(fid, 'architecture Behavioral of MAXPOOL_L%d is\n', layer);
    fprintf(fid, 'signal data_reg, data_reg2, data_next: STD_LOGIC_VECTOR(input_size  - 1 downto 0) := (others => ''0'');\n');
    
else
    fprintf(fid, 'entity MAXPOOL_L%d is\n', layer);
    fprintf(fid, ' generic (\n');
    fprintf(fid, ' input_size : integer := 8; \n');
    fprintf(fid, ' weight_size : integer := 8);\n');
    fprintf(fid, 'Port (clk : in STD_LOGIC;\n');
    fprintf(fid, '      rst : in STD_LOGIC;\n');
    fprintf(fid, '      next_data_pool : in STD_LOGIC;\n');
    fprintf(fid, '      index : STD_LOGIC;\n');
    fprintf(fid, '      data_in : in STD_LOGIC_VECTOR(input_size + weight_size + n_extra_bits - 1 downto 0);\n');
    fprintf(fid, '      data_out : out STD_LOGIC_VECTOR(input_size + weight_size + n_extra_bits - 1 downto 0));\n');
    fprintf(fid, 'end MAXPOOL_L%d;\n\n', layer);
    fprintf(fid, 'architecture Behavioral of MAXPOOL_L%d is\n', layer);
    fprintf(fid, 'signal data_reg, data_reg2, data_next: STD_LOGIC_VECTOR(input_size + weight_size + n_extra_bits - 1 downto 0) := (others => ''0'');\n');   
end
fprintf(fid, '-- Register \n');
fprintf(fid, 'begin\n');
fprintf(fid, 'process(clk) \n');
fprintf(fid, 'begin \n');
fprintf(fid, ' if (clk''event and clk = ''1'') then \n');
fprintf(fid, '     if (rst = ''0'') then \n');
fprintf(fid, '         data_reg <= (others=>''0'');\n');
fprintf(fid, '         data_reg2 <= (others=>''0'');\n');
fprintf(fid, '     else  \n');
fprintf(fid, '          data_reg <= data_next;                  \n');
fprintf(fid, '         if(next_data_pool = ''1'') then   --when the generator''s pool signal is activated we send the output data\n');
fprintf(fid, '           data_reg2 <= data_reg;\n');
fprintf(fid, '         end if;\n');
fprintf(fid, '     end if;\n');
fprintf(fid, 'end if;\n');
fprintf(fid, 'end process; \n');
fprintf(fid, '\n');
fprintf(fid, '-- Next-state logic \n');
fprintf(fid, '\n');
fprintf(fid, 'process(index,data_reg, data_in) -- Comparison between the stored data and the incoming one, we keep the biggest. We perfomr this operation only when the index signal is activated, signaling that there''s new data available.\n');
fprintf(fid, 'begin\n');
fprintf(fid, 'if(index = ''1'') then        \n');
fprintf(fid, '   if(data_in > data_reg) then        \n');
fprintf(fid, '      data_next <= data_in;\n');
fprintf(fid, '   else\n');
fprintf(fid, '      data_next <= data_reg;\n');
fprintf(fid, '   end if;\n');
fprintf(fid, 'else \n');
fprintf(fid, '      data_next <= (others=>''0'');  \n');
fprintf(fid, 'end if;\n');
fprintf(fid, 'end process;\n');
fprintf(fid, '\n');
fprintf(fid, '--Output logic \n');
fprintf(fid, '\n');
fprintf(fid, 'data_out <= data_reg;\n');
fprintf(fid, 'end Behavioral;\n');
fclose(fid);
end

