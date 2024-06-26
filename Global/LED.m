% This function generates the module for LED signal that shows the output
% of the network
function LED(layers_fc)
    file_name = 'CNN_Network/Global/LED.vhd';
    fid = fopen(file_name, 'w');    
    fprintf(fid, 'library IEEE;\n');
    fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
    fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
    fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n\n');    
    fprintf(fid, 'entity LED is\n');
    fprintf(fid, '    Port (\n');
    fprintf(fid, '        clk : in STD_LOGIC;\n');
    fprintf(fid, '        y : in unsigned(log2c(number_of_outputs_L%dfc) - 1 downto 0);\n', layers_fc);
    fprintf(fid, '        an : out STD_LOGIC_VECTOR(7 downto 0);\n');
    fprintf(fid, '        seg : out STD_LOGIC_VECTOR(6 downto 0)\n');
    fprintf(fid, '    );\n');
    fprintf(fid, 'end LED;\n');   
    fprintf(fid, 'architecture Behavioral of LED is\n');
    fprintf(fid, '    signal seg1 : STD_LOGIC_VECTOR(6 downto 0);\n');
    fprintf(fid, '    signal c_reg, c_next : unsigned(11 downto 0) := (others => ''0'');\n');
    fprintf(fid, 'begin\n\n');    
    fprintf(fid, '    with y select\n');
    fprintf(fid, '        seg1 <=  "1000000" when "0000",\n');
    fprintf(fid, '                 "1111001" when "0001",\n');
    fprintf(fid, '                 "0100100" when "0010",\n');
    fprintf(fid, '                 "0110000" when "0011",\n');
    fprintf(fid, '                 "0011001" when "0100",\n');
    fprintf(fid, '                 "0010010" when "0101",\n');
    fprintf(fid, '                 "0000010" when "0110",\n');
    fprintf(fid, '                 "1111000" when "0111",\n');
    fprintf(fid, '                 "0000000" when "1000",\n');
    fprintf(fid, '                 "0010000" when "1001",\n');
    fprintf(fid, '                 "0111111" when others;\n');   
    fprintf(fid, '    an <= "01111111";\n');
    fprintf(fid, '    seg <= seg1;\n\n');    
    fprintf(fid, 'end Behavioral;\n');   
    fclose(fid);
end
