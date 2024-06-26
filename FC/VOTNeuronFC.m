function VOTNeuronFC(bias_term,weights, n_integer_w, n_decimal_w,number_of_neuron, biggest_ROM_size, n_integer_act, n_decimal_act, n_extra_bits,layer ,layer_conv, number_of_neuronsFC)
name = sprintf('CNN_Network/FC/VOT_layer%d_FCneuron_%d.vhd',layer, number_of_neuron);
fid = fopen(name, 'wt');
fprintf(fid, 'library IEEE;\n');
fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
fprintf(fid, 'use IEEE.MATH_REAL.ALL;\n');
fprintf(fid, '\n');
fprintf(fid, 'entity VOT_layer%d_FCneuron_%d is\n', layer,number_of_neuron);
fprintf(fid, '\tPort ( \n');
for b = 1 : 3
            fprintf(fid, '\t\t neuron_mac_%d : in std_logic_vector(input_size_L%dfc+weight_size_L%dfc + n_extra_bits-1 downto 0);\n',b, layer, layer);
end
            fprintf(fid, '\t\t neuron_mac_v : out std_logic_vector(input_size_L%dfc+weight_size_L%dfc + n_extra_bits-1 downto 0));\n', layer, layer);
fprintf(fid, 'end VOT_layer%d_FCneuron_%d ;\n', layer,number_of_neuron);
fprintf(fid, '\n');
fprintf(fid, 'architecture Behavioral of VOT_layer%d_FCneuron_%d is\n', layer,number_of_neuron);
fprintf(fid, 'begin\n');
    fprintf(fid, 'neuron_mac_v <= (neuron_mac_1 and neuron_mac_2) or (neuron_mac_1 and neuron_mac_3) or (neuron_mac_2 and neuron_mac_3);\n');
fprintf(fid, 'end Behavioral;\n\n');
fclose(fid);
end