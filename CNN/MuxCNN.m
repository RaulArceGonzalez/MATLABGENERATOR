% This function generates the multiplexers of the CNN network
% INPUTS
% Number of layer of the network
% Z dimension of the previous layer 
function [] = MuxCNN(num,number_of_layers)
    name = sprintf('CNN_Network/CNN/MUX_%d.vhd',num);
    fid = fopen(name, 'wt');  
    fprintf(fid, '------ MUX ---------\n');
    fprintf(fid, '--This module selects the output signal to transmit each of the output signals of the filters of one layer as an input signal to the filters of the next layer.\n');
    fprintf(fid, '--as input signal to the filters of the next layer. In this way we transmit the result matrix to the next layer.\n');
    fprintf(fid, '--INPUTS\n');
    fprintf(fid, '--data_inx : output signal of the convolutional filter, one for each filter\n');
    fprintf(fid, '--index: signal that selects the output signal, its value goes from 0 to the number of layers.\n');
    fprintf(fid, '--OUTPUTS\n');
    fprintf(fid, '--data_out : selected output signal \n');
    fprintf(fid, 'library IEEE;\n');
    fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
    fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
    fprintf(fid, 'use work.tfg_irene_package.all;\n\n');
    fprintf(fid, 'entity  MUX_%d is\n', num);
    fprintf(fid, '\tPort( \n');
    for i = 0: number_of_layers - 1
        fprintf(fid, '\tdata_in%d : in STD_LOGIC_VECTOR(input_sizeL%d + weight_sizeL%d + n_extra_bits -1  downto 0); \n', i, num - 1, num - 1 );
    end
    fprintf(fid, '\t index : in  STD_LOGIC_VECTOR(log2c(number_of_layers%d) - 1 downto 0); \n', num);
    fprintf(fid, '\tdata_out : out STD_LOGIC_VECTOR(input_sizeL%d + weight_sizeL%d + n_extra_bits -1  downto 0));\n', num-1, num-1);
    fprintf(fid, 'end MUX_%d; \n', num);
    fprintf(fid, 'architecture Behavioral of MUX_%d is\n', num');
    fprintf(fid, 'begin\n');
    for i = 0: number_of_layers - 1
       if ( i == 0)
         fprintf(fid, 'data_out <=   data_in%d when index = "%s" else \n', i, dec2bin(i, ceil(log2(number_of_layers))));
       else
       fprintf(fid, '\t data_in%d when index = "%s" else \n', i, dec2bin(i, ceil(log2(number_of_layers))));
       end
     end
     fprintf(fid, '\t (others => ''0'');\n');
     fprintf(fid, 'end Behavioral;\n\n');        
    fclose(fid);
end

