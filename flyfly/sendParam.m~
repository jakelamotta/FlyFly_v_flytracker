function [success] = sendParam(param,port)
% Function that send quit command and the parameter file to FlyTracker
    import java.net.ServerSocket
    import java.io.*
    retry = 0;
    number_of_retries = 1;
    success = false;
    server_socket = [];
    output_socket = [];
    
    while true
        
        retry = retry +1;
        
        try
            if ((number_of_retries > 0) && (retry > number_of_retries))
                fprintf(1,'Too many retries, data merging could not be performed\n');
                break;
            end
            
            server_socket = ServerSocket(port);
            server_socket.setSoTimeout(10000);
            
            output_socket = server_socket.accept;
            
            disp('Client is connected..');
            
            output_stream = output_socket.getOutputStream;
            doutput_stream = DataOutputStream(output_stream);
            
            toWrite = serialize(param);
            size_ = size(toWrite);
            
            for k=1:size_(1)
                doutput_stream.writeDouble(toWrite(k));
            end
            
            doutput_stream.flush;
            success = true;
            
            if ~isempty(server_socket)
                server_socket.close
            end
            
            if ~isempty(output_socket)
                output_socket.close;
            end
            
            break;
            
        catch e
            disp(e.message);
            
            if ~isempty(server_socket)
                server_socket.close
            end
            
            if ~isempty(output_socket)
                output_socket.close;
            end
            
            %pause(1);
        end    
    end
end