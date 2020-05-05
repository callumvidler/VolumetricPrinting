grayImage = imread('Cross_Section_Example.png');


[rows, columns, numberOfColorBands] = size(grayImage);
if numberOfColorBands > 1
  grayImage = grayImage(:, :, 2); 
end

subplot(1, 3, 1);
imshow(grayImage, []);
fontSize = 20;
title('Original Grayscale Image', 'FontSize', fontSize, 'Interpreter', 'None');
% Set up figure properties:
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Get rid of tool bar and pulldown menus that are along top of figure.
set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% Give a name to the title bar.
set(gcf, 'Name', 'FFT Algorithm', 'NumberTitle', 'Off') 
% Display the original gray scale image.
subplot(1, 3, 2);
F=fft2(grayImage);
S=fftshift(log(1+abs(F)));

h = surf(S)
set(h,'edgecolor','none')

subplot(1, 3, 2);

Filtered = S^(-1); 
set(h,'edgecolor','none')
IFF = ifft(Filtered); 
FINAL_IM = uint8(real(IFF)); 

imshow(FINAL_IM,); 

title('Spectrum Image', 'FontSize', fontSize, 'Interpreter', 'None');