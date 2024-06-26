% This function generates the module for the register of the softmax layer 
function Reg_softmax_2(layers_fc)

    name = sprintf('CNN_Network/Softmax/Reg_softmax_2.vhd');
    fid = fopen(name, 'wt');
    fprintf(fid, 'library IEEE;\n');
    fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
    fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
    fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
    fprintf(fid, 'use IEEE.MATH_REAL.ALL;\n');
    fprintf(fid, '\n');
    fprintf(fid, 'entity Reg_softmax_2 is\n');
    fprintf(fid, ' Port ( clk : in std_logic;\n');
    fprintf(fid, '        rst : in std_logic;\n');
    fprintf(fid, '        data_in : in std_logic_vector(input_size_L%dfc - 1 downto 0);\n', layers_fc);
    fprintf(fid, '        reg_Sm : in std_logic;\n');
    fprintf(fid, '        data_out : out std_logic_vector(input_size_L%dfc - 1 downto 0)\n', layers_fc);
    fprintf(fid, '    );\n');
    fprintf(fid, 'end Reg_softmax_2;\n');
    fprintf(fid, '\n');
    fprintf(fid, 'architecture Behavioral of Reg_softmax_2 is\n');
    fprintf(fid, '    signal data_next, data_reg : std_logic_vector(input_size_L%dfc - 1 downto 0):= (others=>''0'');\n', layers_fc);
    fprintf(fid, '    begin\n');
    fprintf(fid, '    -- Register\n');
    fprintf(fid, '    process (clk)\n');
    fprintf(fid, '    begin\n');
    fprintf(fid, '        if (clk''event and clk = ''1'') then\n');
    fprintf(fid, '            if (rst = ''0'') then\n');
    fprintf(fid, '                data_reg <= (others => ''0'');\n');
    fprintf(fid, '            else\n');
    fprintf(fid, '                    data_reg <= data_next;\n');
    fprintf(fid, '            end if;\n');
    fprintf(fid, '        end if;\n');
    fprintf(fid, '    end process;\n');
    fprintf(fid, '\n');
    fprintf(fid, '    -- Input process\n');
    fprintf(fid, '    process (data_in, reg_Sm, data_next, data_reg)\n');
    fprintf(fid, '    begin\n');
    fprintf(fid, '            if (reg_Sm = ''1'') then\n');
    fprintf(fid, '                data_next <= data_in;\n');
    fprintf(fid, '            else\n');
    fprintf(fid, '                data_next <= data_reg;\n');
    fprintf(fid, '            end if;\n');
    fprintf(fid, '    end process;\n');
    fprintf(fid, '\n');
    fprintf(fid, '    -- Output assignment\n');
    fprintf(fid, '    data_out <= data_reg;\n');
    fprintf(fid, 'end Behavioral;\n');
    
    fclose(fid);
           
   