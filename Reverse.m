function [r] = Reverse(Array)
%Reverse takes a 1d array as a input, and outputs the same 1d array but
%with the elements in reversed order, to those of the array that was
%passed in as an input
%Inputs:  Array   = 1d array
%Outputs: r       = 1d array with elements reversed
%Author: Richard Ng

r = flip(Array); %flip returns array with elements flipped

end

