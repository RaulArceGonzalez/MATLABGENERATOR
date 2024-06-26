    function inverse(layers_fc,input_size, n_enteros, n_decimales)
    name = sprintf('CNN_Network/Softmax/inverse.vhd');
    fid = fopen(name, 'wt');
    fprintf(fid, '--------------------------INV------------------------------------\n');
    fprintf(fid, '-- This module performs the inverse of the input data (which is the sum of the exponential to perform the softmax function)\n');
    fprintf(fid, '---INPUTS\n');
    fprintf(fid, '-- data_in : Sum of the exponentials\n');
    fprintf(fid, '---OUTPUTS\n');
    fprintf(fid, '-- data_out : Inverse of the sum\n\n');
    % Escritura en fichero de las líneas comunes a todas las neuronas %
    
    fprintf(fid, 'library IEEE;\n');
    fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
    fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
    fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
    fprintf(fid, 'use IEEE.MATH_REAL.ALL;\n');
    fprintf(fid, '\n');

    fprintf(fid, 'entity inverse is\n');
    fprintf(fid, '\tPort ( \n'); 
    fprintf(fid, '\t\tdata_in : in STD_LOGIC_VECTOR (input_size_L%dfc-1 downto 0); \n', layers_fc);
    fprintf(fid, '\t\tdata_out : out STD_LOGIC_VECTOR (input_size_L%dfc-1 downto 0));\n', layers_fc);
    fprintf(fid, 'end inverse;\n');
    fprintf(fid, '\n');

    fprintf(fid, 'architecture Behavioral of inverse is\n');
    fprintf(fid, '\n');
    fprintf(fid, 'Begin\n');
    fprintf(fid, 'with data_in select data_out <= \n');
    char = '10000000';
    origin = zeros((2^input_size),1);
    origin(1,1) = q2dec(char,n_enteros, n_decimales,'bin' );
    for i = 2: (2^input_size)
                origin(i,1) = origin(i - 1,1) + 2^(-n_decimales);
    end
    for i = 1: (2^input_size )   
            formatSpec = '"%s" when "%s",\n';
            fprintf(fid, formatSpec, dec2q((1/(origin(i , 1))), 1,(n_enteros + n_decimales - 1), 'bin'), dec2q(origin(i, 1), n_enteros,n_decimales, 'bin'));
    end
    fprintf(fid, '\t\t "%s" when others; \n ', dec2bin(0, (n_enteros + n_decimales + 1 )));
    fprintf(fid, 'end Behavioral;\n\n');   
    fclose(fid);
