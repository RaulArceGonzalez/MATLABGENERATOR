% This function generates the generator of the computation of the directions for each layer
% INPUTS
% Layer of the Interface
% Number of layers of the network
function [] = VOTLayerInterface(layer, layers_cnn, padding,padding_conv)
name = sprintf('CNN_Network/CNN/VOT_Interfaz_ET%d.vhd', layer);
fid = fopen(name, 'wt');
fprintf(fid,'library IEEE;\n');
fprintf(fid,'use IEEE.STD_LOGIC_1164.ALL;\n');
fprintf(fid, 'use work.tfg_irene_package.ALL;\n');
fprintf(fid,'use IEEE.NUMERIC_STD.ALL;\n');
fprintf(fid,'\n');
fprintf(fid,'entity INTERFAZ_ET%d is\n', layer);
fprintf(fid, 'Port ( \n');
for m =1 :TRIPLE
        fprintf(fid,'\t\t dato_out_%d : in std_logic;\n',m);
        fprintf(fid,'\t\t cero_%d : in std_logic;\n',m);
        fprintf(fid,'\t\t dato_cero_%d : in std_logic;\n',m);
        fprintf(fid, '\t\t padding_col%d_%d : in std_logic;\n',layer ,m);
        fprintf(fid, '\t\t padding_row%d_%d : in std_logic;\n', layer ,m);
        fprintf(fid, '\t\t col%d_%d : in unsigned(log2c(column_size%d + 2*(conv%d_padding)) - 1 downto 0);\n', layer,m, layer, layer);
        fprintf(fid, '\t\t p_row%d_%d: in unsigned( log2c(conv%d_padding) downto 0); \n', layer,m, layer);
        fprintf(fid, '\t\t p_col%d_%d : in unsigned( log2c(conv%d_padding) downto 0);  \n', layer,m, layer);
        fprintf(fid,'\t\t conv%d_col_%d : in unsigned(log2c(conv%d_column) - 1 downto 0);\n', layer, m, layer);
        fprintf(fid,'\t\t conv%d_fila_%d : in  unsigned(log2c(conv%d_row) - 1 downto 0);\n', layer, m, layer);
        fprintf(fid,'\t\t pool%d_col_%d : in unsigned(log2c(pool%d_column) - 1 downto 0);\n',layer+1, m, layer+1);
        fprintf(fid,'\t\t pool%d_fila_%d : in  unsigned(log2c(pool%d_row) - 1 downto 0);\n', layer+1, m, layer+1);
end
        fprintf(fid,'\t\t dato_out_v : out std_logic;\n');
        fprintf(fid,'\t\t cero_v : out std_logic;\n');
        fprintf(fid,'\t\t dato_cero_v : out std_logic;\n');
        fprintf(fid, '\t\t padding_col%d_v : out std_logic;\n',layer);
        fprintf(fid, '\t\t padding_row%d_v : out std_logic;\n', layer);
        fprintf(fid, '\t\t col%d_v : out unsigned(log2c(column_size%d + 2*(conv%d_padding)) - 1 downto 0);\n', layer, layer, layer);
        fprintf(fid, '\t\t p_row%d_v: out unsigned( log2c(conv%d_padding) downto 0); \n', layer, layer);
        fprintf(fid, '\t\t p_col%d_v : out unsigned( log2c(conv%d_padding) downto 0);  \n', layer, layer);
        fprintf(fid,'\t\t conv%d_col_v : out unsigned(log2c(conv%d_column) - 1 downto 0);\n', layer, layer);
        fprintf(fid,'\t\t conv%d_fila_v : out  unsigned(log2c(conv%d_row) - 1 downto 0);\n', layer, layer);
        fprintf(fid,'\t\t pool%d_col_v : out unsigned(log2c(pool%d_column) - 1 downto 0);\n',layer+1, layer+1);
        fprintf(fid,'\t\t pool%d_fila_v : out  unsigned(log2c(pool%d_row) - 1 downto 0));\n', layer+1, layer+1);
fprintf(fid,'end Interfaz_ET%d;\n', layer);
fprintf(fid,'architecture Behavioral of Interfaz_ET%d is\n', layer);
fprintf(fid,'begin\n');
fprintf(fid, 'dato_out_v <= (dato_out_1 and dato_out_2) or (dato_out_1 and dato_out_3) or (dato_out_2 and dato_out_3);\n');
fprintf(fid, 'cero_v <= (cero_1 and cero_2) or (cero_1 and cero_3) or (cero_2 and cero_3);\n');
fprintf(fid, 'dato_cero_v <= (dato_cero_1 and dato_cero_2) or (dato_cero_1 and dato_cero_3) or (dato_cero_2 and dato_cero_3);\n');
fprintf(fid, '\t\t padding_col%d_v <= (padding_col%d_1 and padding_col%d_2) or (padding_col%d_1 and padding_col%d_3) or (padding_col%d_2 and padding_col%d_3);\n',layer,layer,layer,layer,layer,layer,layer);
fprintf(fid, '\t\t padding_row%d_v <= (padding_row%d_1 and padding_row%d_2) or (padding_row%d_1 and padding_row%d_3) or (padding_row%d_2 and padding_row%d_3);\n',layer,layer,layer,layer,layer,layer,layer);
fprintf(fid, '\t\t col%d_v <= (col%d_1 and col%d_2) or (col%d_1 and col%d_3) or (col%d_2 and col%d_3);\n', layer,layer,layer,layer,layer,layer,layer);
fprintf(fid, '\t\t p_row%d_v <= (p_row%d_1 and p_row%d_2) or (p_row%d_1 and p_row%d_3) or (p_row%d_2 and p_row%d_3);\n', layer,layer,layer,layer,layer,layer,layer);
fprintf(fid, '\t\t p_col%d_v <= (p_col%d_1 and p_col%d_2) or (p_col%d_1 and p_col%d_3) or (p_col%d_2 and p_col%d_3);  \n', layer,layer,layer,layer,layer,layer,layer);
fprintf(fid,'\t\t conv%d_col_v <= (conv%d_col_1 and conv%d_col_2) or (conv%d_col_1 and conv%d_col_3) or (conv%d_col_2 and conv%d_col_3);\n', layer,layer,layer,layer,layer,layer,layer);
fprintf(fid,'\t\t conv%d_fila_v <= (conv%d_fila_1 and conv%d_fila_2) or (conv%d_fila_1 and conv%d_fila_3) or (conv%d_fila_2 and conv%d_fila_3);\n', layer,layer,layer,layer,layer,layer,layer);
fprintf(fid,'\t\t pool%d_col_v <= (pool%d_col_1 and pool%d_col_2) or (pool%d_col_1 and pool%d_col_3) or (pool%d_col_2 and pool%d_col_3);\n',layer+1, layer+1, layer+1, layer+1, layer+1, layer+1, layer+1);
fprintf(fid,'\t\t pool%d_fila_v <= (pool%d_fila_1 and pool%d_fila_2) or (pool%d_fila_1 and pool%d_fila_3) or (pool%d_fila_2 and pool%d_fila_3);\n', layer+1, layer+1, layer+1, layer+1, layer+1, layer+1, layer+1);
fprintf(fid, 'end Behavioral;\n');
fclose(fid);
end