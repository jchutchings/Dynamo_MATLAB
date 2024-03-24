% Template for compiling and running a Dynamo project.

% Provide files:
pr = 'project_name'; % project name
data = '<path_to_particle_directory>'; % data folder
table = '<path_to_corresponding_table>'; % Dynamo table file (.tbl)
template = '<path_to_template>'; % reference map 
mask = '<path_to_mask>'; % mask file

% make the project
dcp.new(pr,'d',data,'t',table,'template',template,'mask',mask,'show',0);

% populate the project parameters.
% -- iteration round : copy and paste this block below and change r to add more rounds
r = 1;
dvput(pr,['ite_r' num2str(r)],10); % no. of iterations
dvput(pr,['dim_r' num2str(r)],32); % dims
dvput(pr,['cr_r' num2str(r)],40); % cone range
dvput(pr,['cs_r' num2str(r)],5); % cone sampling
%dvput(pr,['cone_flip_r' num2str(r)],1); % flip cone for directionality, optional.
dvput(pr,['ir_r' num2str(r)],20); % in-plane range
dvput(pr,['is_r' num2str(r)],5); % in-plane sampling
%dvput(pr,['cone_flip_r' num2str(r)],1); % flip in-plane orientations for directionality, optional.
dvput(pr,['rf_r' num2str(r)],1); % refine iterations
dvput(pr,['rff_r' num2str(r)],1); % refine factor
dvput(pr,['high_r' num2str(r)],2); % high pass
dvput(pr,['low_r' num2str(r)],6); % low pass
dvput(pr,['lim_r' num2str(r)],[10,10,5]); % shift limits
dvput(pr,['limm_r' num2str(r)],1); % shift mode
dvput(pr,['sym_r' num2str(r)],'c1'); % symmetry

% computing, check GPU identifiers are available with nvidia-smi
dvput(pr,'dst','matlab_gpu','gpus',[0 1 2 3],'cores',1,'mwa',8);

% check and unfold
dvcheck(pr);
dvunfold(pr); 

% run
run(pr);