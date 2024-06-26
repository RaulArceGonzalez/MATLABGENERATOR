% This function generates the mock memory of the system to test different input images
% INPUTS
% Size of the input image
% Number of integer bits of the input data
% Number of decimal bits of the input data
% Number of the classification of the image in the batch
% Input image
% Prediction for the image in the python code
function [] = MockMemory(input_image_size, n_integers, n_decimals, number, category, prediction)
        fileID = fopen('image_1.txt','r');
        formatSpec = '%f';
        image = fscanf(fileID,formatSpec);
        image_input = image.';
        name = sprintf('CNN_Network/Global/Mock_Memory_%s.vhd', category);
        fid = fopen(name, 'wt');
        fprintf(fid, '--Image%d is %s predicted %s;\n', number, category, prediction);
        fprintf(fid, 'library IEEE;\n');
        fprintf(fid, 'library IEEE;\n');
        fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
        fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
        fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
        fprintf(fid, 'use IEEE.MATH_REAL.ALL;\n');
        fprintf(fid, 'entity Mock_Memory is\n');
        fprintf(fid, '\t Port (clk : in std_logic;\n');
        fprintf(fid, '\t\t    rst : in std_logic;\n');
        fprintf(fid, '\t\t    address : in STD_LOGIC_VECTOR(log2c(number_of_inputs) - 1 downto 0 );\n');
        fprintf(fid, '\t\t    data_out : out STD_LOGIC_VECTOR(input_sizeL1 -1 downto 0));\n');
        fprintf(fid, 'end Mock_Memory; \n');
        fprintf(fid, 'architecture Behavioral of Mock_Memory is\n');
        fprintf(fid, 'signal data_out_next, data_out_reg:  STD_LOGIC_VECTOR(input_sizeL1 -1 downto 0); \n');
        fprintf(fid, 'begin\n');
        fprintf(fid, 'process(clk)\n');
        fprintf(fid, 'begin\n');
        fprintf(fid, 'if rising_edge(clk) then\n');
        fprintf(fid, '\t if (rst = ''0'') then\n');
        fprintf(fid, '\t\t data_out_reg <= (others => ''0'');\n');
        fprintf(fid, '\telse\n');
        fprintf(fid, '\t\t data_out_reg <= data_out_next;\n');
        fprintf(fid, '\t end if;\n');
        fprintf(fid, 'end if;\n');
        fprintf(fid, 'end process;\n');  
        fprintf(fid, 'with address select data_out_next <= \n');
        for i = 0 : input_image_size -1
                    fprintf(fid, '\t"%s" when "%s", -- %d\n', dec2q(image_input(i + 1), n_integers, n_decimals, 'bin'), dec2bin(i, ceil(log2(input_image_size))), i );
        end
        fprintf(fid, '\t"%s" when others; \n ', dec2q(0, n_integers, n_decimals, 'bin'));
        fprintf(fid, 'data_out <= data_out_reg;\n');  
        fprintf(fid, 'end Behavioral;\n\n');   
        fclose(fid);
           
end

