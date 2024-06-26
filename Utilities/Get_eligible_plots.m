function [pl_pop] = Get_eligible_plots(pl_pop, eligible_struct)

% ========================================================================
% ** IndoMod function **
% Returns household IDs associated with the set of the map pixels 
% in map_idx. This script also appends an indicator column to pl.pop to
% help determine which household instances are eligible for the scenarios
% ========================================================================

%If all households are elgible for the scenario, change id and exit
%function. 

%Generate matrix of eligible land uses. 
flat_idx = zeros(size(pl_pop,1), 1);  
flat_idx(find(pl_pop.slope == 1)) = 1;
moderate_idx = zeros(size(pl_pop,1), 1);  
moderate_idx(find(pl_pop.slope == 2)) = 1;
steep_idx = zeros(size(pl_pop,1), 1); 
steep_idx(find(pl_pop.slope == 3)) = 1;

rented = 1 - pl_pop.Tenure_idx;
non_soilcons = 1 - pl_pop.SoilCons_idx;

coffee_idx = zeros(size(pl_pop,1), 1);  
coffee_idx(find(pl_pop.lu == 1)) = 1;
hort_idx = zeros(size(pl_pop,1), 1);  
hort_idx(find(pl_pop.lu == 2)) = 1;
rice_idx = zeros(size(pl_pop,1), 1); 
rice_idx(find(pl_pop.lu == 3)) = 1;
mixed_idx = zeros(size(pl_pop,1), 1); 
mixed_idx(find(pl_pop.lu == 4)) = 1;

%Merge into matrix 
eligible_mat = [flat_idx(:), moderate_idx(:), steep_idx(:),...
               rented(:), pl_pop.Tenure_idx,...
               non_soilcons(:), pl_pop.SoilCons_idx,...
               coffee_idx(:), hort_idx(:),...
               rice_idx(:), mixed_idx(:)];
                   
%Create diagonal matrix for eligible land uses as defined in .xlsx file
define_eligible = table2array(eligible_struct.plots);

%Now multiply the matrices.
pl_pop.scenario_idx = (define_eligible * eligible_mat')';

%If not equal to 4, one of the criteria has failed, so this plot is
%not eligible (before considering min plot sizes. 
pl_pop.scenario_idx(find(pl_pop.scenario_idx < 4)) = 0 ;
pl_pop.scenario_idx(find(pl_pop.scenario_idx == 4)) = 1 ;
    
end

        