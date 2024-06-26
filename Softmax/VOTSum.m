function VOTSum(layers_fc,n_integer, n_decimal)
    name = sprintf('CNN_Network/Softmax/VOT_sum.vhd');
    fid = fopen(name, 'wt');
        fprintf(fid, 'library IEEE;\n');
        fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
        fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
        fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
        fprintf(fid, 'use IEEE.MATH_REAL.ALL;\n');
        fprintf(fid, '\n');
        fprintf(fid, 'entity VOT_sum is\n');
        fprintf(fid, '\t Port ( \n');
        for b = 1 : 3
            fprintf(fid, '        neuron_mac_%d : in std_logic_vector (input_size_L%dfc-1 downto 0);\n',b, layers_fc);
        end
        fprintf(fid, '        neuron_mac_v : out std_logic_vector (input_size_L%dfc-1 downto 0));\n', layers_fc);
        fprintf(fid, 'end VOT_sum;\n');
        fprintf(fid, '\n');
        fprintf(fid, 'architecture Behavioral of VOT_sum is\n');
        fprintf(fid, '\n');
        fprintf(fid, 'begin\n');
        fprintf(fid, 'neuron_mac_v <= (neuron_mac_1 and neuron_mac_2) or (neuron_mac_1 and neuron_mac_3) or (neuron_mac_2 and neuron_mac_3);\n');
        fprintf(fid, 'end Behavioral;\n\n');   
    fclose(fid);
end