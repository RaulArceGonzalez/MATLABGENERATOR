% This function generates the MaxPool filter of the first layer
function [] = Layer2MaxPool(activations)
name = sprintf('CNN_Network/CNN/MAXPOOL_Layer2.vhd');
fid = fopen(name, 'wt');
fprintf(fid, '-----------------------------------------MODULO MAXPOOL LAYER 1 ----------------------------------------------------------\n');
fprintf(fid, '--This module is going to perform the MaxPool operation, which consists of calculating the maximum of a set of data.\n');
fprintf(fid, '--This is achieved by comparing the input with the data already recorded, if it is greater the input is stored and if not it is discarded.\n');
fprintf(fid, '--INPUTS\n');
fprintf(fid, '--data_in, data_in2 : data processed by the convolution layer and relu, coming from the multiplexer. In this layer we received two because the convolution operation is parallelized.\n');
fprintf(fid, '--index : signal indicating that there is data available to be processed\n');
fprintf(fid, '--OUTPUTS\n');
fprintf(fid, '--data_out: output signal, one output for each filter pass that corresponds to the highest data of those recorded\n');
fprintf(fid, 'library IEEE;\n');
fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n\n');
if(activations == 1)
    fprintf(fid, 'entity MAXPOOL_LAYER2 is\n');
    fprintf(fid, '    Port (\n');
    fprintf(fid, '        clk : in STD_LOGIC;\n');
    fprintf(fid, '        rst : in STD_LOGIC;\n');
    fprintf(fid, '        index : in std_logic;\n');
    fprintf(fid, '        data_in : in STD_LOGIC_VECTOR(input_sizeL1 - 1 downto 0);\n');
    fprintf(fid, '        data_in2 : in STD_LOGIC_VECTOR(input_sizeL1 - 1 downto 0);\n');
    fprintf(fid, '        data_out : out STD_LOGIC_VECTOR(input_sizeL1 - 1 downto 0)\n');
    fprintf(fid, '    );\n');
    fprintf(fid, 'end MAXPOOL_LAYER2;\n\n');   
    fprintf(fid, 'architecture Behavioral of MAXPOOL_LAYER2 is\n');
    fprintf(fid, '    signal data_out_reg, data_aux, data_out_next: STD_LOGIC_VECTOR(input_sizeL1  - 1 downto 0) := (others => ''0'');\n');
    
else
    fprintf(fid, 'entity MAXPOOL_LAYER2 is\n');
    fprintf(fid, '    Port (\n');
    fprintf(fid, '        clk : in STD_LOGIC;\n');
    fprintf(fid, '        rst : in STD_LOGIC;\n');
    fprintf(fid, '        index : in std_logic;\n');
    fprintf(fid, '        data_in : in STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);\n');
    fprintf(fid, '        data_in2 : in STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);\n');
    fprintf(fid, '        data_out : out STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0)\n');
    fprintf(fid, '    );\n');
    fprintf(fid, 'end MAXPOOL_LAYER2;\n\n');   
    fprintf(fid, 'architecture Behavioral of MAXPOOL_LAYER2 is\n');
    fprintf(fid, '    signal data_out_reg, data_aux, data_out_next: STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0) := (others => ''0'');\n');
    
end
fprintf(fid, 'begin\n');
fprintf(fid, '    process(clk)\n');
fprintf(fid, '    begin\n');
fprintf(fid, '        if (clk''event and clk = ''1'') then\n');
fprintf(fid, '            if (rst = ''0'') then\n');
fprintf(fid, '                data_out_reg <= (others => ''0'');\n');
fprintf(fid, '            else\n');
fprintf(fid, '                data_out_reg <= data_out_next;\n');
fprintf(fid, '            end if;\n');
fprintf(fid, '        end if;\n');
fprintf(fid, '    end process;\n\n');
fprintf(fid, '    process(index, data_in, data_in2, data_aux)\n');
fprintf(fid, '    begin\n');
fprintf(fid, '        if (index = ''1'') then\n');
fprintf(fid, '            if (data_in > data_in2) then\n');
fprintf(fid, '                data_aux <= data_in;\n');
fprintf(fid, '            else\n');
fprintf(fid, '                data_aux <= data_in2;\n');
fprintf(fid, '            end if;\n');
fprintf(fid, '        else\n');
fprintf(fid, '            data_aux <= (others => ''0'');\n');
fprintf(fid, '        end if;\n');
fprintf(fid, '    end process;\n\n');
fprintf(fid, '    process(index, data_aux, data_out_next, data_out_reg)\n');
fprintf(fid, '    begin\n');
fprintf(fid, '        if (index = ''1'') then\n');
fprintf(fid, '            if (data_aux > data_out_reg) then\n');
fprintf(fid, '                data_out_next <= data_aux;\n');
fprintf(fid, '            else\n');
fprintf(fid, '                data_out_next <= data_out_reg;\n');
fprintf(fid, '            end if;\n');
fprintf(fid, '        else\n');
fprintf(fid, '            data_out_next <= (others => ''0'');\n');
fprintf(fid, '        end if;\n');
fprintf(fid, '    end process;\n\n');
fprintf(fid, '    data_out <= data_out_reg;\n');
fprintf(fid, 'end Behavioral;\n');

fclose(fid);
end

