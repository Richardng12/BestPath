function [pathRows,pathCols] = GreedyWalk(currentPos,Orientation,E)
%This function finds a greedy path from a specified start position, heading
%either east or west, and continues 'walking' until the edge of the array
%is reached. For each new element in the path, the GreedyPick function is
%called, so that the adjacent element with the minimum elevation change is
%chosen.

%Inputs:  E  = the elevation data stored in a 2d r by c matrix %where r is
%              the number of rows and c the number of columns.
%
%         Orientation = an integer representing the direction to head in
%         with a value of  1, heading east and a value of -1 heading west
%
%         currentPosition = a 2 element 1d array, where the first number is
%         the row number, and the second number the column number
%
%Outputs:   pathRows = a 1D array containing the row indices of the path
%           pathCols = a 1D array containing the column indices of the path
%Author: Richard Ng

pathRows = []; %create empty arrays
pathCols = [];

%Puts the first starting positions in the pathRows and pathCols array
pathRows = [pathRows,currentPos(1)];
pathCols = [pathCols,currentPos(2)];

if Orientation == 1 %heading east
    %for loop, so the function loops until it hits the edge of the array
    for i = currentPos(2):length(E)-1
        
        %call the function It will output a 2 element 1d array containing
        %the row and column of the element with the smallest elevation
        %change
        [pick] = GreedyPick(currentPos,Orientation,E);
        
        Row = pick(1);    %the first element is the row
        Column = pick(2); %the second element is the column
        
        %sets the pick value into the currentPosition,
        %(so that the function is looped with the new position
        %that had the smallest elevation change)
        currentPos = pick;
        
        %Puts the Row and Column values into the same pathRows and pathCols
        %array, so that the entire path is shown
        pathRows = [pathRows,Row];
        pathCols = [pathCols,Column];
    end
    
elseif Orientation == -1 %heading west
    
    %for loop, so the function loops across the length of the array until
    %the edge is reached
    for i = currentPos(2):-1:2
        
        %call GreedyPick function
        [pick] = GreedyPick(currentPos,Orientation,E);
        
        Row = pick(1); %the first element is the row
        Column = pick(2); %the second element is the column
        
        %sets the pick value into the currentPosition,
        %(so that the function is looped with the new position
        %that had the smallest elevation change)
        currentPos = pick;
        
        %Puts the Row and Column values into the same pathRows and pathCols
        %array, so that the entire path is shown
        pathRows = [pathRows,Row];
        pathCols = [pathCols,Column];
        
    end
end







