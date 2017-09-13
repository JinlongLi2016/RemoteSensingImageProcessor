function [fusi_img] = FusionHandlerBy( fusi_type )
% The Image Fusion Interface.
% Call Fusion function via this file
% params:
%   fusi_type: (str) specifies the fusion type
% @ Amos(jinlongli520.gmail.com) 2017-09-13 00:08:50

%% Call Different Fusion Function according 
% to fusion_type
if strcmp(fusi_type, 'weight')
    fusi_img = WeightMerger();
elseif strcmp(fusi_type, 'ratio')
        fusi_img = RatiTran();
elseif strcmp(fusi_type, 'IHS')
            fusi_img = IHSMerger();
elseif strcmp(fusi_type, 'multiplication')
    fusi_img = MultiMerge();
else
    fprintf('Fusion Type Not Implemented....');
end

end