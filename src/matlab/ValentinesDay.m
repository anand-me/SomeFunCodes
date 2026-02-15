%% Heart Shape Animation using the equation:
%% y = x^(2/3) + 0.9*sin(kx)*sqrt(3-x^2)
clear all;close all;clc;
%% Define x range (domain is limited by sqrt(3-x^2))
x = linspace(-sqrt(3), sqrt(3), 1000);
%% Define k range for animation
k_values = linspace(0.1, 100, 200); % 200 frames for smooth animation | play with this number
gif_filename = 'heart_animation_linkedin.gif';
frame_delay = 0.12; % play with this number
figure('Position', [100, 100, 1000, 800]);
set(gcf, 'Color', 'black');
hold on;
grid on;
axis equal;
xlim([-3, 3]);
ylim([-2, 4]);
set(gca, 'Color', 'black', 'XColor', 'white', 'YColor', 'white');
set(gca, 'FontSize', 18); % Increased from 12 to 18
set(gca, 'GridColor', [0.5, 0.5, 0.5]); % Gray grid
xlabel('x', 'FontSize', 18, 'Color', 'white', 'FontWeight', 'bold'); 
ylabel('y', 'FontSize', 18, 'Color', 'white', 'FontWeight', 'bold'); 
%% Initialize plot handle
h = plot(x, zeros(size(x)), 'Color', [1, 0.2, 0.5], 'LineWidth', 4); 
fprintf('Creating LinkedIn-ready heart animation...\n');
fprintf('Saving to: %s\n', gif_filename);
%% Animation loop 
for i = 1:length(k_values)
    k = k_values(i);
    % Calculate y values for current k
    % Handle the x^(2/3) term carefully for negative x values || crucial
    y = zeros(size(x));
    for j = 1:length(x)
        if x(j) >= 0
            y(j) = x(j)^(2/3) + 0.9*sin(k*x(j))*sqrt(3-x(j)^2);
        else
            % For negative x, use (-|x|)^(2/3) = |x|^(2/3) || easy approach
            y(j) = abs(x(j))^(2/3) + 0.9*sin(k*x(j))*sqrt(3-x(j)^2);
        end
    end
    % Update plot 
    set(h, 'XData', x, 'YData', y);
    title_str = sprintf('y = x^{2/3} + 0.9sin(%.2fx)√(3-x²)', k);
    title(title_str, 'FontSize', 20, 'Color', 'white', 'FontWeight', 'bold'); % Larger title
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);
    if i == 1
        imwrite(imind, cm, gif_filename, 'gif', 'Loopcount', inf, 'DelayTime', frame_delay);
    else
        imwrite(imind, cm, gif_filename, 'gif', 'WriteMode', 'append', 'DelayTime', frame_delay);
    end
    %% Progress indicator
    if mod(i, 25) == 0
        fprintf('Progress: %.1f%% (%d/%d frames)\n', (i/length(k_values))*100, i, length(k_values));
    end
     pause(frame_delay * 0.3); % Slower display
end
pause(2);
if exist(gif_filename, 'file')
    info = dir(gif_filename);
else
    fprintf(' Error: GIF not created\n');
end
fprintf('Final k value: %.2f\n', k_values(end));
%% BONUS: Create the static comparison 
figure('Position', [150, 150, 1000, 800]);
set(gcf, 'Color', 'black');
hold on;
grid on;
axis equal;
xlim([-3, 3]);
ylim([-2, 4]);
set(gca, 'Color', 'black', 'XColor', 'white', 'YColor', 'white');
set(gca, 'FontSize', 18);
set(gca, 'GridColor', [0.5, 0.5, 0.5]);
title('Heart Shapes for Different k Values', 'FontSize', 20, 'Color', 'white', 'FontWeight', 'bold');
xlabel('x', 'FontSize', 18, 'Color', 'white', 'FontWeight', 'bold');
ylabel('y', 'FontSize', 18, 'Color', 'white', 'FontWeight', 'bold');
%% Plot for selected k values
k_selected = [0.1, 1, 5, 10, 25, 50, 100];
colors = hsv(length(k_selected));
for i = 1:length(k_selected)
    k = k_selected(i);
    y = zeros(size(x)); 
    for j = 1:length(x)
        if x(j) >= 0
            y(j) = x(j)^(2/3) + 0.9*sin(k*x(j))*sqrt(3-x(j)^2);
        else
            y(j) = abs(x(j))^(2/3) + 0.9*sin(k*x(j))*sqrt(3-x(j)^2);
        end
    end 
    plot(x, y, 'Color', colors(i,:), 'LineWidth', 2.5, ...
         'DisplayName', sprintf('k = %.1f', k));
end
legend('show', 'Location', 'best', 'TextColor', 'white', 'Color', 'black');
print('heart_comparison_dark.png', '-dpng', '-r200');
fprintf(' Static comparison saved: heart_comparison_dark.png\n');