% Initialize Serial Port
s = serial('/dev/cu.usbmodem141301');  % replace 'COM3' with the correct port name for your setup
set(s, 'BaudRate', 9600, 'Terminator', 'LF');
fopen(s);

% Initialize the figure for plotting
figure;
h = animatedline;
xlabel('Time (samples)');
ylabel('Temperature (°C)');
title('Real-time Temperature Data from Arduino');

% Read and plot data in real time
N = 100; % Number of data points to display
counter = 1;

try
    while true
        % Read data from serial port
        line = fscanf(s); % Read the line
        % Extract temperature value from the received line
        startIndex = strfind(line, ': ') + 2;
        temperatureCelsius = str2double(line(startIndex:end));
        
        if ~isnan(temperatureCelsius)
            % Update the plot
            addpoints(h, counter, temperatureCelsius);

            % Adjust X-axis
            if counter > N
                axis([counter-N counter min(temperatureCelsius-5,0) max(temperatureCelsius+5,40)]); % Adjust Y limits as necessary
            end

            % Increment counter
            counter = counter + 1;
        end
        
        % Redraw the plot
        drawnow;
    end
catch
    % Close the serial port if an error occurs or the loop is stopped
    fclose(s);
    delete(s);
    clear s;
end
