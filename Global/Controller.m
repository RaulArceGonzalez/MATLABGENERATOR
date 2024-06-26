% This function generates the control module of the entire network
% It is set up for the start to be automatic when the system is initiated,
% if you want to change it to manual then uncomment the lines of code for
% the start signal
function Controller(layers_fc, riscv)
fid = fopen('CNN_Network/Global/controller.vhd','w');
fprintf(fid,'----------------------------CONTROLLER----------------------------\n');
fprintf(fid,'-- These module is a controller of the entire neural network\n');
fprintf(fid,'--INPUTS\n');
fprintf(fid,'--start : signals for the entire system to start\n');
fprintf(fid,'--finish_red : signals that the system has finished\n');
fprintf(fid,'--y_red : output of the neural network\n');
fprintf(fid,'--OUTPUTS\n');
fprintf(fid,'--rst_red : signal to reset the red after processing an image\n');
fprintf(fid,'--start_red : signal for the system to start,  we generate it from the processor so it is only send when the system is not already functioning\n');
fprintf(fid,'--finish : signals that the system has finished.\n');
fprintf(fid,'--en_riscv :  signal that notifies to the cpu that the system is functioning\n');
fprintf(fid,'--y : output of the neural network\n\n');
fprintf(fid,'library IEEE;\n');
fprintf(fid,'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid,'use work.tfg_irene_package.ALL;\n');
fprintf(fid,'use IEEE.NUMERIC_STD.ALL;\n\n');
fprintf(fid,'entity controller is\n');
fprintf(fid, '        Port (\n');
fprintf(fid, '            clk : in STD_LOGIC;\n');
fprintf(fid, '            rst : in STD_LOGIC;\n');
fprintf(fid, '            rst_red : out STD_LOGIC;\n');
if ( riscv == 1)
    fprintf(fid, '            start : in STD_LOGIC;\n');
    fprintf(fid, '            output_sm_red : in vector_sm_signed(0 to number_of_outputs_L%dfc - 1);\n', layers_fc);
    fprintf(fid, '            output_sm : out vector_sm_signed(0 to number_of_outputs_L%dfc - 1);\n', layers_fc);
end
fprintf(fid, '            en_riscv : out STD_LOGIC;\n');
fprintf(fid, '            finish_red : in STD_LOGIC;\n');
fprintf(fid, '            y_red : in unsigned(log2c(number_of_outputs_L%dfc) - 1 downto 0);\n', layers_fc);
fprintf(fid, '            start_red : out STD_LOGIC;\n');
fprintf(fid, '            finish : out STD_LOGIC;\n');
fprintf(fid, '            y : out unsigned(log2c(number_of_outputs_L%dfc) - 1 downto 0)\n', layers_fc);
fprintf(fid, '        );\n');
fprintf(fid,'end controller;\n\n');
fprintf(fid,'architecture Behavioral of controller is\n');
fprintf(fid,'type state_type is (idle , espera, infer, result);\n\n');
fprintf(fid,'--Registers\n');
fprintf(fid,'signal state_reg, state_next : state_type;\n');
fprintf(fid,'signal finish_reg, finish_next, en_riscv_reg, en_riscv_next, rst_reg, rst_next : std_logic;\n');
fprintf(fid,'signal y_reg, y_next : unsigned(0 to log2c(number_of_outputs_L%dfc)-1);\n\n', layers_fc);
fprintf(fid,'signal output_sm_reg, output_sm_next : vector_sm_signed(0 to number_of_outputs_L2fc - 1);\n');
fprintf(fid,'begin\n');
fprintf(fid,'--Register\n');
fprintf(fid, 'process(clk)\n');
fprintf(fid, 'begin\n');
fprintf(fid, '    if (clk''event and clk = ''1'') then\n');
fprintf(fid, '        if (rst = ''0'') then\n');
fprintf(fid, '            state_reg <= idle;\n');
fprintf(fid, '            en_riscv_reg <= ''0'';\n');
fprintf(fid, '            y_reg <= (others => ''0'');\n');
fprintf(fid, '            finish_reg <= ''0'';\n');
fprintf(fid, '            rst_reg <= ''0'';\n');
fprintf(fid, '            output_sm_reg <= (others => (others => ''0''));\n');
fprintf(fid, '        else\n');
fprintf(fid, '            state_reg <= state_next;\n');
fprintf(fid, '            y_reg <= y_next;\n');
fprintf(fid, '            finish_reg <= finish_next;\n');
fprintf(fid, '            en_riscv_reg <= en_riscv_next;\n');
fprintf(fid, '            rst_reg <= rst_next;\n');
fprintf(fid, '            output_sm_reg <= output_sm_next;\n');
fprintf(fid, '        end if;\n');
fprintf(fid, '    end if;\n');
fprintf(fid, 'end process;\n');
fprintf(fid, 'process(finish_red, y_red, state_reg, y_reg, finish_reg, rst_reg, en_riscv_reg ');
if ( riscv == 1)
    fprintf(fid, ', output_sm_reg, output_sm_red, start ');
end
fprintf( fid, ')\n');
fprintf(fid, 'begin\n');
fprintf(fid, '    state_next <= state_reg;\n');
fprintf(fid, '    y_next <= y_reg;\n');
fprintf(fid, '    finish_next <= finish_reg;\n');
fprintf(fid, '    en_riscv_next <= en_riscv_reg;\n');
if (riscv == 1)
    
    fprintf(fid, '    output_sm_next <= output_sm_reg;\n');
end
fprintf(fid, '    start_red <= ''0'';\n');
fprintf(fid, '    rst_next <= rst_reg;\n');
fprintf(fid, '    case state_reg is\n');
fprintf(fid, '        when idle =>\n');
fprintf(fid, '            y_next <= (others => ''0'');\n');
fprintf(fid, '            finish_next <= ''0'';\n');
fprintf(fid, '            en_riscv_next <= ''0'';\n');
if ( riscv == 1)
    fprintf(fid, '            output_sm_next <= (others => (others => ''0''));\n');
end
fprintf(fid, '            state_next <= espera;\n');
fprintf(fid, '            rst_next <= ''0'';\n');
fprintf(fid, '        when espera =>\n');
fprintf(fid, '            rst_next <= ''0'';\n');
if (riscv == 1)
    fprintf(fid, '            if (start = ''1'') then\n');
    fprintf(fid, '                en_riscv_next <= ''1'';\n');
    fprintf(fid, '                output_sm_next <= (others => (others => ''0''));\n');
end
fprintf(fid, '                finish_next <= ''0'';\n');
fprintf(fid, '                state_next <= infer;\n');
fprintf(fid, '                start_red <= ''1'';\n');
if(riscv==1)
    fprintf(fid, '            end if;\n');
end
fprintf(fid, '        when infer =>\n');
fprintf(fid, '                start_red <= ''0'';\n');
fprintf(fid, '            if (finish_red = ''1'') then\n');
fprintf(fid, '                rst_next <= ''1'';\n');
fprintf(fid, '                state_next <= result;\n');
fprintf(fid, '                finish_next <= ''1'';\n');
fprintf(fid, '                en_riscv_next <= ''0'';\n');
fprintf(fid, '            end if;\n');
fprintf(fid, '        when result =>\n');
fprintf(fid, '            y_next <= y_red;\n');
if(riscv == 1)
    fprintf(fid, '            output_sm_next <= output_sm_red;\n');
end
fprintf(fid, '            en_riscv_next <= ''0'';\n');
fprintf(fid, '            state_next <= espera;\n');
fprintf(fid, '            rst_next <= ''0'';\n');
fprintf(fid, '            finish_next <= ''0'';\n');

fprintf(fid, '    end case;\n');
fprintf(fid, 'end process;\n');
fprintf(fid, 'y <= y_reg;\n');
if(riscv == 1)
    fprintf(fid, 'output_sm <= output_sm_reg;\n');
end
fprintf(fid, 'en_riscv <= en_riscv_reg;\n');
fprintf(fid, 'finish <= finish_reg;\n');
fprintf(fid, 'rst_red <= rst_reg;\n');
fprintf(fid, 'end Behavioral;');
fclose(fid);