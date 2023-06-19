function  [nel,nodes,conn,bc] = mesh2()

nseg = 8;

bottom_x = 1:2*nseg+1; bottom_ind=1:2*nseg+1;
top_x    = 2:2:2*nseg+1; top_ind = 2*nseg+2:2*nseg+2+length(top_x)-1;
nodes(:,1) = [bottom_x,top_x];
nodes(:,2) = [zeros(size(bottom_x)),ones(size(top_x))];

conn = [bottom_ind(1:end-1),top_ind(1:end-1),bottom_ind(2:2:end),bottom_ind(1:2:end-1),bottom_ind(3:2:end);...
        bottom_ind(2:end)  ,top_ind(2:end),  top_ind,            top_ind,              top_ind  ];

bc = zeros([size(nodes),2]);
bc(:,:,1)=1;
bc(bottom_ind(1),:,1)   = 0; %Left bottom node pinned
bc(bottom_ind(end),2,1) = 0; %Right bottom node roller

force_down=-5*1.5e7;
bc(bottom_ind(2:end-1),2,2) = force_down/length(bottom_ind(2:end-1));
bc(top_ind(end),1,2)        = 4.5e7;

nel = size(conn,2);

end