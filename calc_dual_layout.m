% Define the function to calculate the circular layout of the tree, tree is
% of the matlab-tree class
function layout = calc_dual_layout(tree,treelayout,graph_param)
angles=treelayout{1};
distances=treelayout{2};
anglevals=angles.values;
anglevalues=vertcat(anglevals{:});
distancevals=distances.values;
distancevalues=vertcat(distancevals{:});



figure();
% Plot the points
polarplot(deg2rad(anglevalues), distancevalues, 'o', 'Color','blue');
selectedKeys = keys(distances);
selectedKeys = selectedKeys(cell2mat(cellfun(@(x) x == 1, values(distances), 'UniformOutput', false)));
subsetMap = containers.Map(selectedKeys, values(angles, selectedKeys));
leafAngles = cell2mat(subsetMap.values);
leafAngles_copy=leafAngles;
leafAngles(leafAngles>360)=leafAngles(leafAngles>360) - 360;
centered_angles = leafAngles - 90;
wrapped_angles = centered_angles;
wrapped_angles(wrapped_angles < 0) = wrapped_angles(wrapped_angles < 0) + 360;
sorted_wrapped_angles = sort(wrapped_angles);
sorted_angles = mod(sorted_wrapped_angles + 90, 360);

sorted_angles_og=sorted_angles;
sorted_angles_og(sorted_angles_og<90)=sorted_angles_og(sorted_angles_og<90)+360;
sorted_keys = zeros(size(sorted_angles_og));
for i = 1:length(sorted_angles_og)
    for j = 1:length(angles)
        if sorted_angles_og(i) == angles(j)
            sorted_keys(i) = j;
            break;
        end
    end
end
%disp(sorted_keys);
faceEdgeList = populateFaces(tree,sorted_keys); %populate our face edge list
% Initialize connections array
connections = {};

% Iterate over each element in the cell array
for i = 1:length(faceEdgeList)-1
    % Get the current element
    currentElement = faceEdgeList{i};

    temp={}; %temp array to store the j for which there are connnections
    
    % Iterate over the subsequent elements in the cell array
    for j = i+1:length(faceEdgeList)
        % Get the next element
        nextElement = faceEdgeList{j};
        
        % Find the shared elements between the current and next elements
        sharedElements = intersect(currentElement, nextElement);
        
        if isempty(sharedElements)==0
            temp=[temp j];
        end
    end
    
    % Add the temporary array to the connections array
    connections{i} = temp;
end

layout=connections;

for i = 1:length(leafAngles)
        disp(i);
        myIndex= find(sorted_angles==leafAngles(i));
        iterator_select=myIndex;
    text(deg2rad(leafAngles(i)), 1, "Leaf"+string(iterator_select),'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'Margin', 25);
end

% Connect certain points in the tree with straight lines
hold on;
for i=1:tree.nnodes
    for j=1:tree.nnodes
        if i==tree.getparent(j) || j==tree.getparent(i)
            line([deg2rad(angles(i)), deg2rad(angles(j))], [distances(i), distances(j)],'Color','blue');
        end
    end
end
% Connect face-points in the dual with straight lines
midangles={};
for i=1:length(sorted_angles_og)
    mid_angle=0;
    if i~=length(sorted_angles_og)
        mid_angle=(sorted_angles_og(i)+sorted_angles_og(i+1))/2;
    else
        mid_angle=(sorted_angles_og(i)+450)/2;
    end
    midangles{i}=mid_angle;
end
for i=1:length(midangles)-1
    text(deg2rad(midangles{i}), 1, "Face"+string(i+1),'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'Margin', 25,'Color','red');
end
text(deg2rad(midangles{length(midangles)}), 1, "Face"+string(1),'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'Margin', 25,'Color','red');
midangles_reorder=midangles(1:end-1);
last_element=midangles{end};
midangles_reorder=[last_element midangles_reorder];
for i=1:length(connections)
    for j=1:length(connections{i})
        line([deg2rad(midangles_reorder{connections{i}{j}}),deg2rad(midangles_reorder{i})],[1,1],'Color','red');
    end
end
k = 1;
theta = linspace(0,2*pi);
rho = linspace(k,k);
polarplot(theta,rho,'blue');
hold off;
if graph_param==1
    figure();
    k = 1;
    theta = linspace(0,2*pi);
    rho = linspace(k,k);
    polarplot(theta,rho,'blue');
    for i=1:length(connections)
        for j=1:length(connections{i})
            line([deg2rad(midangles_reorder{connections{i}{j}}),deg2rad(midangles_reorder{i})],[1,1],'Color','red');
        end
    end
end

