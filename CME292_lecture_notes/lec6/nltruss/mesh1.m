function  [nel,nodes,conn,bc] = mesh1()

nodes = [0, 8, 0, 8; ...
         0, 0, 6, 6]';
conn = [1, 1, 2, 3, 3, 1;...
        2, 3, 4, 4, 2, 4];
bc(:,:,1)=[0, 1, 1, 1; 0, 0, 1, 1]';
bc(:,:,2)=[0, 0, 0, 1.5e8; 0, 0, 0, 0]';

nel = size(conn,2);

end