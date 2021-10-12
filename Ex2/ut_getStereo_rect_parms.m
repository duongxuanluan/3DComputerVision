function [Rrectc, Rrectcc,K,ctcc_new,Hc,Hcc] = ut_getStereo_rect_parms(camp)
% UT_GETSTEREO_RECT_PARMS - rectification parameters of two stereo cameras
%
% [Rrectc, Rrectcc,K,ctcc,Hc,Hcc] = ut_getStereo_rect_parms(camp)
% calculates the rectification parameters associated with the stereocamera
% parameters that are stored in camp. The method of rectification follows
% the same course as in Matlab's: rectifyStereoImages.
%
% Input:
% camp          Stereo Camera system parameters
%
% Output:
% Rrectc:       Rotation matrix for virtual rotation of camera 1
% Rrectcc:      Rotation matrix for virtual rotation of camera 2
% K:            calibration matrix after rectification of both cameras
% ctcc:         Baseline vector after rectification
% Hc:           tform to transform image 1
% Hcc:          tform to transform image 2
%
% Matrices are given in non-transposed form (pre-multiplication)

ccRc=camp.RotationOfCamera2';
cctc = camp.TranslationOfCamera2';
cRcc = ccRc';
ctcc = -cRcc*cctc;

%% step 1: deskew
axang = rotm2axang(ccRc');
axang(4) = axang(4)/2;
Rdeskew = axang2rotm(axang)';

%% step 2: align with baseline
Lt = Rdeskew*ctcc;
% find the axis of rotation
e_align = cross(Lt,[1 0 0]');

if norm(e_align) == 0 % no rotation
    R_align = eye(3);
else
    e_align = e_align / norm(e_align);
    % find the angle of rotation
    Lt_xdir_angle = acos((dot(Lt,[1 0 0]'))/(norm(Lt)*norm([1 0 0]')));
    R_align = axang2rotm([e_align;Lt_xdir_angle]');
end

Rrectc = R_align * Rdeskew;
Rrectcc = R_align * Rdeskew';

Kc = camp.CameraParameters1.IntrinsicMatrix';
Kcc = camp.CameraParameters2.IntrinsicMatrix';
K = Kc;
d = min([Kcc(1,1),Kc(1,1)]);    % new focal distance
K(1,1) = d;                     % set new focal distance
K(2,2) = d;
cy = (Kcc(2,3)+Kc(2,3))/ 2;     % find new y center
K(2,3) = cy;                    % set new y center
K(1,2) = 0;                     % set the skew to 0

Hc  = projective2d((K * Rrectc / Kc)');
Hcc = projective2d((K * Rrectcc / Kcc)');

% apply row alignment to translation
ctcc_new = R_align * Lt;

