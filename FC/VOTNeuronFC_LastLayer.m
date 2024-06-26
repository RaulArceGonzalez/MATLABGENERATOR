function VOTNeuronFC_LastLayer(number_of_neuron, number_of_layers_fc)

    name = sprintf('CNN_Network/FC/VOT_layer_out_neuron_%d.vhd', number_of_neuron);
    fid = fopen(name, 'wt');
    fprintf(fid, 'library IEEE;\n');
    fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
    fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
    fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
    fprintf(fid, 'use IEEE.MATH_REAL.ALL;\n');
    fprintf(fid, '\n');
    fprintf(fid, 'entity VOT_layer_out_neuron_%d is\n', number_of_neuron);
    fprintf(fid, '\tPort ( \n');
    for b = 1 : 3
        fprintf(fid,'\t\t neuron_mac_%d : in STD_LOGIC_VECTOR (input_size_L%dfc-1 downto 0);\n',b, number_of_layers_fc);
    end
    fprintf(fid,'\t\t neuron_mac_v : out STD_LOGIC_VECTOR (input_size_L%dfc-1 downto 0));\n', number_of_layers_fc);
    fprintf(fid, 'end VOT_layer_out_neuron_%d;\n', number_of_neuron);
    fprintf(fid, '\n');
    fprintf(fid, 'architecture Behavioral of VOT_layer_out_neuron_%d is\n', number_of_neuron);
    fprintf(fid, '\n'); 
    fprintf(fid, 'begin\n');
    fprintf(fid, 'neuron_mac_v <= (neuron_mac_1 and neuron_mac_2) or (neuron_mac_1 and neuron_mac_3) or (neuron_mac_2 and neuron_mac_3);\n');
    fprintf(fid, 'end Behavioral;\n\n');   
    fclose(fid);
end