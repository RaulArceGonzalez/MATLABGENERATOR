% This function generates the module for the the threshold function
% implemented in the last part of the network
% INPUTS
% Number of layers of the FC part of the network
function Threshold(layers_fc)
file_name = 'CNN_Network/Softmax/threshold.vhd';
fid = fopen(file_name, 'w');
fprintf(fid, 'library IEEE;\n');
fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid,'use IEEE.NUMERIC_STD.ALL;\n\n');
fprintf(fid, '\n');
fprintf(fid, 'entity threshold is\n');
fprintf(fid, '    Port (\n');
fprintf(fid, '        clk : std_logic;\n');
fprintf(fid, '        rst : std_logic;\n');
fprintf(fid, '        y_in : in vector_sm_signed(0 to number_of_outputs_L%dfc-1);\n', layers_fc);
fprintf(fid, '        start : in std_logic;\n');
fprintf(fid, '        y_out : out unsigned(log2c(number_of_outputs_L%dfc) -1 downto 0);\n', layers_fc);
fprintf(fid, '        finish : out std_logic\n');
fprintf(fid, '    );\n');
fprintf(fid, 'end threshold;\n');
fprintf(fid, '\n');
fprintf(fid, 'architecture Behavioral of threshold is\n');
fprintf(fid, '    type state_type is (idle , s_wait, s0);\n');
fprintf(fid, '    signal state_reg, state_next : state_type;\n');
fprintf(fid, '    signal data_reg, data_next: signed(input_size_L%dfc-1 downto 0) := (others => ''0'');\n', layers_fc);
fprintf(fid, '    signal c_reg, c_next, c_aux_reg, c_aux_next : unsigned(log2c(number_of_outputs_L%dfc) - 1 downto 0) := (others => ''0'');\n', layers_fc);
fprintf(fid, '\n');
fprintf(fid, 'begin\n');
fprintf(fid, '    process(clk)\n');
fprintf(fid, '    begin\n');
fprintf(fid, '        if (clk''event and clk = ''1'') then\n');
fprintf(fid, '            if (rst = ''0'') then\n');
fprintf(fid, '                c_reg <= (others=>''0'');\n');
fprintf(fid, '                data_reg <= (others=>''0'');\n');
fprintf(fid, '                state_reg <= idle;\n');
fprintf(fid, '                c_aux_reg <= (others =>''0'');\n');
fprintf(fid, '            else\n');
fprintf(fid, '                data_reg <= data_next;\n');
fprintf(fid, '                c_reg <= c_next;\n');
fprintf(fid, '                state_reg <= state_next;\n');
fprintf(fid, '                c_aux_reg <= c_aux_next;\n');
fprintf(fid, '            end if;\n');
fprintf(fid, '        end if;\n');
fprintf(fid, '    end process;\n');
fprintf(fid, '\n');
fprintf(fid, '    process(state_reg, data_reg, y_in, start, c_reg, c_aux_reg)\n');
fprintf(fid, '    begin\n');
fprintf(fid, '        c_next <= c_reg;\n');
fprintf(fid, '        data_next <= data_reg;\n');
fprintf(fid, '        state_next <= state_reg;\n');
fprintf(fid, '        c_aux_next <= c_aux_reg;\n');
fprintf(fid, '        case state_reg is\n');
fprintf(fid, '            when idle =>\n');
fprintf(fid, '                finish <= ''0'';\n');
fprintf(fid, '                data_next <= (others => ''0'');\n');
fprintf(fid, '                c_next<= (others => ''0'');\n');
fprintf(fid, '                state_next <= s_wait;\n');
fprintf(fid, '            when s_wait =>\n');
fprintf(fid, '                finish <= ''0'';\n');
fprintf(fid, '                if(start = ''1'') then\n');
fprintf(fid, '                    state_next <= s0;\n');
fprintf(fid, '                end if;\n');
fprintf(fid, '            when s0 =>\n');
fprintf(fid, '                if(y_in(to_integer(c_reg)) > data_reg) then\n');
fprintf(fid, '                    data_next <= y_in(to_integer(c_reg));\n');
fprintf(fid, '                    c_aux_next <= c_reg;\n');
fprintf(fid, '                else\n');
fprintf(fid, '                    data_next <= data_reg;\n');
fprintf(fid, '                end if;\n');
fprintf(fid, '                if(c_reg = number_of_outputs_L%dfc - 1) then\n', layers_fc);
fprintf(fid, '                    data_next <= (others=>''0'');\n');
fprintf(fid, '                    c_next <= (others=>''0'');\n');
fprintf(fid, '                    finish <= ''1'';\n');
fprintf(fid, '                    state_next <= s_wait;\n');
fprintf(fid, '                else\n');
fprintf(fid, '                    c_next <= c_reg + 1;\n');
fprintf(fid, '                    finish <= ''0'';\n');
fprintf(fid, '                end if;\n');
fprintf(fid, '        end case;\n');
fprintf(fid, '    end process;\n');
fprintf(fid, '\n');
fprintf(fid, '    y_out <= c_aux_reg;\n');
fprintf(fid, '\n');
fprintf(fid, 'end Behavioral;\n');
