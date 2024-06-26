% This function generates the generator of the computation of the
% directions for layer 1 data
% INPUTS
% Number of layers in the network
% Indicates if there is parallelism in layer 1
function [] = VOTLayer1Interface(layer, layers_cnn, parallelism_layer1, padding)
name = sprintf('CNN_Network/CNN/VOT_Interfaz_ET1.vhd');
fid = fopen(name, 'wt');
fprintf(fid,'\n');
fprintf(fid,'library IEEE;\n');
fprintf(fid,'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid,'use IEEE.NUMERIC_STD.ALL;\n');
fprintf(fid,'\n');
fprintf(fid,'entity VOT_INTERFAZ_ET%d is\n', layer);
fprintf(fid, 'Port (\n');
for e=1 : 3
        fprintf(fid,'\t\t dato_out_%d : in std_logic;\n',e);
        fprintf(fid,'\t\t cero_%d : in std_logic;\n',e);
        fprintf(fid,'\t\t cero2_%d : in std_logic;\n',e);
        fprintf(fid,'\t\t dato_cero_%d : in std_logic;\n',e);
        fprintf(fid,'\t\t dato_cero2_%d : in std_logic;\n',e);
        fprintf(fid,'\t\t dato_addr_%d : in std_logic;\n',e);
        fprintf(fid,'\t\t address_%d : in std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);\n',e);
        fprintf(fid,'\t\t address2_%d : in std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);\n',e);
end
        fprintf(fid,'\t\t dato_out_v : out std_logic;\n');
        fprintf(fid,'\t\t cero_v : out std_logic;\n');
        fprintf(fid,'\t\t cero2_v : out std_logic;\n');
        fprintf(fid,'\t\t dato_cero_v : out std_logic;\n');
        fprintf(fid,'\t\t dato_cero2_v : out std_logic;\n');
        fprintf(fid,'\t\t dato_addr_v : out std_logic;\n');
        fprintf(fid,'\t\t address_v : out std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);\n');
        fprintf(fid,'\t\t address2_v : out std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0));\n');
fprintf(fid,'end VOT_Interfaz_ET%d;\n', layer);
fprintf(fid,'architecture Behavioral of VOT_Interfaz_ET%d is\n', layer);
fprintf(fid, '\n');
fprintf(fid, 'begin\n');
fprintf(fid, 'dato_out_v <= (dato_out_1 and dato_out_2) or (dato_out_1 and dato_out_3) or (dato_out_2 and dato_out_3);\n');
fprintf(fid, 'cero_v <= (cero_1 and cero_2) or (cero_1 and cero_3) or (cero_2 and cero_3);\n');
fprintf(fid, 'cero2_v <= (cero2_1 and cero2_2) or (cero2_1 and cero2_3) or (cero2_2 and cero2_3);\n');
fprintf(fid, 'dato_cero_v <= (dato_cero_1 and dato_cero_2) or (dato_cero_1 and dato_cero_3) or (dato_cero_2 and dato_cero_3);\n');
fprintf(fid, 'dato_cero2_v <= (dato_cero2_1 and dato_cero2_2) or (dato_cero2_1 and dato_cero2_3) or (dato_cero2_2 and dato_cero2_3);\n');
fprintf(fid, 'dato_addr_v <= (dato_addr_1 and dato_addr_2) or (dato_addr_1 and dato_addr_3) or (dato_addr_2 and dato_addr_3);\n');
fprintf(fid, 'address_v <= (address_1 and address_2) or (address_1 and address_3) or (address_2 and address_3);\n');
fprintf(fid, 'address2_v <= (address2_1 and address2_2) or (address2_1 and address2_3) or (address2_2 and address2_3);\n');
fprintf(fid, 'end Behavioral;\n');
fclose(fid);
end