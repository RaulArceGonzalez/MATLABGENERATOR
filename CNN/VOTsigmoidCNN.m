% This function generates the exponential module used in the softmax layer of the network
% INPUTS
% number of layers of the fully connected part of th enetwork
% number of bits of the input data
% number of bits of the integer part of the input data
% number of bits of the decimal part of the input data
function VOTsigmoidCNN(layer,input_size, n_integer, n_decimal)
    name = sprintf('CNN_Network/CNN/VOT_sigmoidL%d.vhd', layer);
    fid = fopen(name, 'wt');
    fprintf(fid, '\n');
    fprintf(fid, 'library IEEE;\n');
    fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
    fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
    fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
    fprintf(fid, 'entity VOT_sigmoid_L%d is\n', layer);
    fprintf(fid, '\tPort ( \n'); 
    for x = 1 : 3
        fprintf(fid, '\t\t data_out_%d : in std_logic_vector(input_sizeL%d-1 downto 0);\n',x, layer);
    end
        fprintf(fid, '\t\t data_out_v : out std_logic_vector(input_sizeL%d-1 downto 0));\n', layer);
    fprintf(fid, 'end VOT_sigmoid_L%d;\n', layer);
    fprintf(fid, '\n');
    fprintf(fid, 'architecture Behavioral of VOT_sigmoid_L%d is\n', layer);
    fprintf(fid, '\n');
    fprintf(fid, 'Begin\n');
    fprintf(fid, 'data_out_v <= (data_out_1 and data_out_2) or (data_out_1 and data_out_3) or (data_out_2 and data_out_3);\n');
    fprintf(fid, 'end Behavioral;\n\n');   
    fclose(fid);
end