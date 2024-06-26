% This function generates the exponential module used in the softmax layer of the network
% INPUTS
% number of layers of the fully connected part of th enetwork
% number of bits of the input data
% number of bits of the integer part of the input data
% number of bits of the decimal part of the input data
function sigmoidFC(layer,input_size, n_integer, n_decimal)
    name = sprintf('CNN_Network/FC/sigmoidFCL%d.vhd', layer);
    fid = fopen(name, 'wt');
    fprintf(fid, '--------------------------Sigmoid------------------------------------\n');
    fprintf(fid, '-- This module performs the sigmoid function with a LUT\n');
    fprintf(fid, '---INPUTS\n');
    fprintf(fid, '-- data_in : Results of the convolution operations.\n');
    fprintf(fid, '---OUTPUTS\n');
    fprintf(fid, '-- data_out : Sigmoid of the input data.\n\n');
    fprintf(fid, 'library IEEE;\n');
    fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
    fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
    fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
    fprintf(fid, 'use IEEE.MATH_REAL.ALL;\n');
    fprintf(fid, '\n');
    fprintf(fid, 'entity sigmoidFCL%d is\n', layer);
    fprintf(fid, '\tPort ( \n'); 
    fprintf(fid, '\t\tdata_in : in std_logic_vector(input_size_L%dfc-1 downto 0); \n', layer);
    fprintf(fid, '\t\tdata_out : out std_logic_vector(input_size_L%dfc-1 downto 0));\n', layer);
    fprintf(fid, 'end sigmoidFCL%d;\n', layer);
    fprintf(fid, '\n');
    fprintf(fid, 'architecture Behavioral of sigmoidFCL%d is\n', layer);
    fprintf(fid, '\n');
    fprintf(fid, 'Begin\n');
    fprintf(fid, 'with data_in select data_out <= \n');
    char = '10000000';
    origin = zeros((2^input_size),1);
    origin(1,1) = q2dec(char,n_integer, n_decimal,'bin' );
    for i = 2: (2^input_size)
        origin(i,1) = origin(i - 1,1) + 2^(-n_decimal);
    end
    for i = 1: (2^input_size )
        formatSpec = '"%s" when "%s",\n';
        fprintf(fid, formatSpec, dec2q(sigmoid(origin(i , 1)), n_integer,n_decimal, 'bin'), dec2q(origin(i, 1), n_integer,n_decimal, 'bin'));
    end
    fprintf(fid, '\t\t "%s" when others; \n ', dec2bin(0, (n_integer + n_decimal + 1 )));
    fprintf(fid, 'end Behavioral;\n\n');   
    fclose(fid);
end