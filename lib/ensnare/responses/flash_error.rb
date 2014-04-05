class Ensnare::Response::FlashError < Ensnare::Response::Response    

    def run
        if(!@violations.blank?)
            @flash[:error] = @options[:content] || "We have noticed malicious activity from your IP Address/session. Please do not be evil."
        end

        return false
    end

end
