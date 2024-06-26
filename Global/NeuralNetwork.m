% This function generates the global module of the system
% INPUTS
% Number of layers of the FC part of the network
% Number of layers of the CNN part of the network
function NeuralNetwork(layers_fc, layers_cnn,riscv)
file_name = 'CNN_Network/Global/neural_network.vhd';
fid = fopen(file_name, 'w');
fprintf(fid, '-----------------------------------------MODULE Neural Network----------------------------------------------------------\n');
fprintf(fid, '--Global module of the system\n');
fprintf(fid, '--INPUTS\n');
fprintf(fid, '--data_in : If we are using the mock_memory for testing this input is not used\n');
fprintf(fid, '--address : If we are using the mock_memory for testing this input is not used\n');
fprintf(fid, '--start   : If we want an automatic start this signal is not used, for a manual start uncomment the lines of code of the start signal in the controller\n');
fprintf(fid, '--OUTPUTS\n');
fprintf(fid, '--finish   : signals that the system is finished\n');
fprintf(fid, '--en_riscv : signals that the systems is processing\n');
fprintf(fid, '--y        : output if the system\n');
fprintf(fid, '--an,seg   : control signals for the LEDs\n');
fprintf(fid, 'library IEEE;\n');
fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n\n');
fprintf(fid, 'entity neural_network is\n');
fprintf(fid, '    port (\n');
fprintf(fid, '        clk : in std_logic;\n');
fprintf(fid, '        rst : in std_logic;\n');
fprintf(fid, '        en_riscv : out std_logic;\n');
if (riscv == 1)
    fprintf(fid, '        start : in std_logic;\n');
    fprintf(fid, '        data_in : in std_logic_vector(31 downto 0);\n');
    fprintf(fid, '        address : out std_logic_vector(log2c(number_of_inputs) - 1 downto 0);\n');
    fprintf(fid, '        output_sm : out output_t;\n');
else
    fprintf(fid, '        an : out std_logic_vector(7 downto 0);\n');
    fprintf(fid, '        seg : out std_logic_vector(6 downto 0);\n');
end
fprintf(fid, '        y : out std_logic_vector(log2c(number_of_outputs_L%dfc) - 1 downto 0);\n', layers_fc);
fprintf(fid, '        finish : out std_logic\n');
fprintf(fid, '    );\n');
fprintf(fid, 'end neural_network;\n');
fprintf(fid, 'architecture Behavioral of neural_network is\n');
fprintf(fid, '    -- Component declaration --\n');
fprintf(fid, '    component CNN_red is\n');
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
fprintf(fid, '            address : out std_logic_vector(log2c(number_of_inputs) - 1 downto 0 );\n');
fprintf(fid, '            data_out : out std_logic_vector(input_size_L1fc - 1 downto 0)\n');
fprintf(fid, '        );\n');
fprintf(fid, '    end component;\n');
fprintf(fid, '    component FC is\n');
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
fprintf(fid, '    end component;\n');
fprintf(fid, '    component controller is\n');
fprintf(fid, '        Port (\n');
fprintf(fid, '            clk : in STD_LOGIC;\n');
fprintf(fid, '            rst : in STD_LOGIC;\n');
fprintf(fid, '            rst_red : out STD_LOGIC;\n');
fprintf(fid, '            en_riscv : out STD_LOGIC;\n');
if ( riscv == 1)
    fprintf(fid, '            start : in STD_LOGIC;\n');
    fprintf(fid, '            output_sm_red : in vector_sm_signed(0 to number_of_outputs_L%dfc - 1);\n', layers_fc);
    fprintf(fid, '            output_sm : out vector_sm_signed(0 to number_of_outputs_L%dfc - 1);\n', layers_fc);
end
fprintf(fid, '            finish_red : in STD_LOGIC;\n');
fprintf(fid, '            y_red : in unsigned(log2c(number_of_outputs_L%dfc) - 1 downto 0);\n', layers_fc);
fprintf(fid, '            start_red : out STD_LOGIC;\n');
fprintf(fid, '            finish : out STD_LOGIC;\n');
fprintf(fid, '            y : out unsigned(log2c(number_of_outputs_L%dfc) - 1 downto 0)\n', layers_fc);
fprintf(fid, '        );\n');
fprintf(fid, '    end component;\n');
if(riscv == 0)
    fprintf(fid, '    component Mock_Memory is\n');
    fprintf(fid, '        Port (\n');
    fprintf(fid, '            clk : in std_logic;\n');
    fprintf(fid, '            rst : in std_logic;\n');
    fprintf(fid, '            address : in STD_LOGIC_VECTOR(log2c(number_of_inputs) - 1 downto 0);\n');
    fprintf(fid, '            data_out : out STD_LOGIC_VECTOR(input_sizeL1 - 1 downto 0)\n');
    fprintf(fid, '        );\n');
    fprintf(fid, '    end component;\n');
    fprintf(fid, '    component LED is\n');
    fprintf(fid, '        Port (\n');
    fprintf(fid, '            clk : in STD_LOGIC;\n');
    fprintf(fid, '            y : in unsigned(log2c(number_of_outputs_L%dfc) - 1 downto 0);\n', layers_fc);
    fprintf(fid, '            an : out STD_LOGIC_VECTOR(7 downto 0);\n');
    fprintf(fid, '            seg : out STD_LOGIC_VECTOR(6 downto 0)\n');
    fprintf(fid, '        );\n');
    fprintf(fid, '    end component;\n');
end
fprintf(fid, '    signal data_ready, data_fc, finish_red, start_red : std_logic;\n');
fprintf(fid, '    signal address_byte : std_logic_vector(1 downto 0);\n');
fprintf(fid, '    signal address_buff: STD_LOGIC_VECTOR(log2c(number_of_inputs) - 1 downto 0 );\n');
if ( riscv == 0)
    fprintf(fid, '    signal data_in : std_logic_vector(input_sizeL1 - 1 downto 0);\n');
end
fprintf(fid, '    signal data_in_red : std_logic_vector(input_sizeL1 - 1 downto 0);\n');
fprintf(fid, '    signal output_sm_red, output_sm_buff : vector_sm_signed(0 to number_of_outputs_L%dfc - 1);\n', layers_fc);
fprintf(fid, '    signal y_red, y_buff: unsigned(0 to log2c(number_of_outputs_L%dfc) - 1);\n', layers_fc);
fprintf(fid, '    signal x_reg, x_next : std_logic_vector(input_size_L1fc - 1 downto 0);\n');
fprintf(fid, '    signal data_out : std_logic_vector(input_size_L1fc - 1 downto 0);\n');
fprintf(fid, '    signal rst_cnn, rst_red : std_logic;\n');
fprintf(fid, 'begin\n');
if ( riscv == 1)
    fprintf(fid, 'process(output_sm_buff)\n');
    fprintf(fid, 'begin\n');
    fprintf(fid, 'for i in 0 to number_of_outputs_L%dfc - 1 loop\n', layers_fc);
    fprintf(fid, 'output_sm(i) <= std_logic_vector(resize(output_sm_buff(i), 32));\n');
    fprintf(fid, 'end loop;\n');
    fprintf(fid, 'end process;\n');
end
fprintf(fid, '    CNN_network : CNN_red\n');
fprintf(fid, '        port map (\n');
fprintf(fid, '            clk => clk,\n');
fprintf(fid, '            rst => rst,\n');
fprintf(fid, '            rst_red => rst_red,\n');
if(riscv == 1)
    fprintf(fid, '            address => address,\n');
else
    fprintf(fid, '            address => address_buff,\n');
end
fprintf(fid, '            data_fc => data_fc,\n');
fprintf(fid, '            data_in => data_in,\n');
fprintf(fid, '            data_ready => data_ready,\n');
fprintf(fid, '            start_red => start_red,\n');
fprintf(fid, '            data_out => data_out\n');
fprintf(fid, '        );\n');
fprintf(fid, '    process (clk)\n');
fprintf(fid, '    begin\n');
fprintf(fid, '        if rising_edge(clk) then\n');
fprintf(fid, '            if (rst = ''0'') then\n');
fprintf(fid, '                x_reg <= (others => ''0'');\n');
fprintf(fid, '            else\n');
fprintf(fid, '                x_reg <= x_next;\n');
fprintf(fid, '            end if;\n');
fprintf(fid, '        end if;\n');
fprintf(fid, '    end process;\n\n');
fprintf(fid, '    x_next <= data_out;\n');
fprintf(fid, '    FC_network: FC\n');
fprintf(fid, '        port map (\n');
fprintf(fid, '            clk => clk,\n');
fprintf(fid, '            rst => rst,\n');
fprintf(fid, '            rst_red => rst_red,\n');
fprintf(fid, '            start_enable => data_ready,\n');
fprintf(fid, '            data_fc => data_fc,\n');
fprintf(fid, '            finish => finish_red,\n');
if(riscv==1)
    fprintf(fid, '            output_sm  => output_sm_red,\n');
end
fprintf(fid, '            x => x_reg,\n');
fprintf(fid, '            y => y_red\n');
fprintf(fid, '        );\n');
fprintf(fid, '    control: controller\n');
fprintf(fid, '        port map (\n');
fprintf(fid, '            clk => clk,\n');
fprintf(fid, '            rst => rst,\n');
if ( riscv == 1)
    fprintf(fid, '    start => start,\n');
    fprintf(fid, '    output_sm_red => output_sm_red,\n');
    fprintf(fid, '    output_sm => output_sm_buff,\n');
end
fprintf(fid, '    en_riscv => en_riscv,\n');
fprintf(fid, '            start_red => start_red,\n');
fprintf(fid, '            finish_red => finish_red,\n');
fprintf(fid, '            finish => finish,\n');
fprintf(fid, '            y_red => y_red,\n');
fprintf(fid, '            rst_red => rst_red,\n');
fprintf(fid, '            y => y_buff\n');
fprintf(fid, '        );\n');
fprintf(fid, '    y <= std_logic_vector(y_buff);\n');
if( riscv == 0)
    fprintf(fid, '    Mem_Prueba : Mock_Memory\n');
    fprintf(fid, '        port map (\n');
    fprintf(fid, '            clk => clk,\n');
    fprintf(fid, '            rst => rst,\n');
    fprintf(fid, '            address => address_buff,\n');
    fprintf(fid, '            data_out => data_in\n');
    fprintf(fid, '        );\n');
    fprintf(fid, '    LED_OUT : LED\n');
    fprintf(fid, '        port map (\n');
    fprintf(fid, '            clk => clk,\n');
    fprintf(fid, '            y => y_buff,\n');
    fprintf(fid, '            an => an,\n');
    fprintf(fid, '            seg => seg\n');
    fprintf(fid, '        );\n\n');
end
fprintf(fid, 'end Behavioral;\n');
fclose(fid);
end