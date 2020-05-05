%MATLAB Code for Serial Communication between Arduino and MATLAB

x=serial('COM3','BAUD', 9600);

fopen(x);
go = true;

while go
                 
a= input('Press 1 to turn ON LED & 0 to turn OFF:');
fprintf(x,a);  

if (a == 2)
  go=false;
end
end

