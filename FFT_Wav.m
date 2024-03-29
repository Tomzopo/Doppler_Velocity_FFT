%Thomas Stewart
%15/11/2019

%{
Well my thoughts for solving this.
Well using the sound file my attempt is to find the dominant frequencies in
the file to help determine the frequencies being received from the
observer when the vehicle is moving towards and the frequencies for when 
the vehicle is moving away from the observer.
Then using those frequencies taking the formula for the doppler effect to
determine the velocity of the vehicle.
%}

%{
First read the audio data and FFT the data to find the dominant
frequencies
%} 
function FFT_Wav()
    [data, fs] = audioread('challenge_2020.wav');
    
    L = length(data);     % Length of signal
    
    %{
    Splitting the clips to try get dominant freqs
    from the parts of the sound where the doppler freq
    can be measured more acurately and not be overwhelm by
    the loudness of the vehicle when it has reached the observer
    %}
    data = data(1:(4/15)*L);
    %data = data((9/15*L):L);

    L = length(data);
    Y = fft(data);
    P2 = abs(Y);
    
    %Only getting half the spectrum since its duplicated
    P1 = P2(1:floor(L/2+1)); 
    P1(2:end-1) = 2*P1(2:end-1);

    %Determining frequency axis based on 
    f = fs*(0:(L/2))/L;
    
    plot(f,P1) 
    title('Amplitude Freq Spectrum of Wav')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    
    %Using the graph plug in the values
    %Dominant frequencies are the doppler values for moving towards
    %(fs_max) and away (fs_min)
    %Taken dom frequencies for moving towards and away from observer, from
    %Fig1 and Fig2 respectively.
    vs_km = dopCalc(294.2, 371.5);
    fprintf('Speed of Object is: %fkm/h\n', vs_km);

end

%{
Then using the two observed frequencies we can solve a linear equation of
the doppler effect.
%} 
function vs_km = dopCalc(fs_min, fs_max)
    c = 343;
    %Linear Equation
    %fs_max = (c)/(c-v)*f_o
    %fs_min = (c)/(c+v)*f_o
    
    %Simplified to solve for v
    v = c*(fs_max-fs_min)/(fs_max+fs_min);
    
    %m/s -> km/h
    vs_km = v * 3.6;
end

%{
Based on the results I'm getting the velocity seems quite unrealistic
So my thoughts is that the velocity is not constant and some
acceleration/deceleration is occuring.
%}