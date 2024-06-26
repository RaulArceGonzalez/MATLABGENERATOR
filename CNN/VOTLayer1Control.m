% This function generates the module for the control signal generator of
% the first layer of the CNN part of the network
% INPUTS
% Number of bits of the input data of the layer
% Number of data to be processed by the convolutional filters
function [] = VOTLayer1Control(input_size, mult1)
        name = sprintf('CNN_Network/CNN/VOT_GEN1.vhd');
        fid = fopen(name, 'wt');
        fprintf(fid, '\n');
        fprintf(fid, 'library IEEE;\n');
        fprintf(fid, 'use IEEE.STD_LOGIC_1164.ALL;\n');
        fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
        fprintf(fid, 'use IEEE.NUMERIC_STD.ALL;\n');
        fprintf(fid, 'entity VOT_GEN1 is\n');
        fprintf(fid, '\t Port (\n');
        for b = 1 : 3
        fprintf(fid, '\t\t en_neuron_%d : in std_logic;\n',b);
        fprintf(fid, '\t\t count_%d : in unsigned( log2c(input_sizeL1)-1   downto 0);\n',b);
        fprintf(fid, '\t\t mul_%d: in std_logic_vector(log2c(mult1) - 1 downto 0);\n',b);
        fprintf(fid, '\t\t dato_out1_%d: in std_logic; \n',b);
        fprintf(fid, '\t\t dato_out2_%d : in std_logic;\n',b);
        fprintf(fid, '\t\t next_pipeline_step_%d : in std_logic;\n',b);
        end
        fprintf(fid, '\t\t en_neuron_v : out std_logic;\n');
        fprintf(fid, '\t\t count_v : out unsigned( log2c(input_sizeL1)-1   downto 0);\n');
        fprintf(fid, '\t\t mul_v: out std_logic_vector(log2c(mult1) - 1 downto 0);\n');
        fprintf(fid, '\t\t dato_out1_v: out std_logic; \n');
        fprintf(fid, '\t\t dato_out2_v : out std_logic;\n');
        fprintf(fid, '\t\t next_pipeline_step_v : out std_logic);\n');
        fprintf(fid, 'end VOT_GEN1;\n');
        fprintf(fid, 'architecture Behavioral of VOT_GEN1 is\n');
        fprintf(fid, 'Begin \n');
        fprintf(fid, 'next_pipeline_step_v <= (next_pipeline_step_1 and next_pipeline_step_2) or (next_pipeline_step_1 and next_pipeline_step_3) or (next_pipeline_step_2 and next_pipeline_step_3);\n');
        fprintf(fid, 'dato_out2_v <= (dato_out2_1 and dato_out2_2) or (dato_out2_1 and dato_out2_3) or (dato_out2_2 and dato_out2_3);\n');
        fprintf(fid, 'dato_out1_v <= (dato_out1_1 and dato_out1_2) or (dato_out1_1 and dato_out1_3) or (dato_out1_2 and dato_out1_3);\n');
        fprintf(fid, 'en_neuron_v <= (en_neuron_1 and en_neuron_2) or (en_neuron_1 and en_neuron_3) or (en_neuron_2 and en_neuron_3);\n');
        fprintf(fid, 'count_v <= (count_1 and count_2) or (count_1 and count_3) or (count_2 and count_3);\n');
        fprintf(fid, 'mul_v <= (mul_1 and mul_2) or (mul_1 and mul_3) or (mul_2 and mul_3);\n');
        fprintf(fid,'end Behavioral;\n');
        fclose(fid);          
end