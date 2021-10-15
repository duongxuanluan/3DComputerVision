function [ fv ] = CleanNanFromFV( fv )
%CLEANNANFROMFV Summary of this function goes here
%   Detailed explanation goes here
    vL = find(isnan(fv.vertices(:,1)));
    members = any(ismember(fv.faces, vL),2);
    fv.faces(members,:) = [];
end